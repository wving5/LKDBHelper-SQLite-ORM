

#import "LKDBSelect.h"
#import "LKSQLCompositeCondition.h"
#import "LKDBHelper.h" 

extern NSString* LKDB_Distinct(NSString *name){
    return [@"DISTINCT " stringByAppendingString:name];
}

//MARK:- define LKDB API for ORM query result
@interface LKDBHelper(LKDBSelect)
- (NSMutableArray * )executeQuery:(NSString * )sql toClass:(Class)modelClass;
- (NSMutableArray * )executeQuery:(NSString * )sql;
// declare LKDB private method
- (NSMutableArray * )executeResult:(FMResultSet * )set Class:(Class)modelClass tableName:(NSString * _Nullable )tableName;
@end

@implementation LKDBHelper(LKDBSelect)

// mapping result to Model
- (NSMutableArray * )executeQuery:(NSString * )executeSQL toClass:(Class)modelClass
{
    __block NSMutableArray* results = nil;
    [self executeDB:^(FMDatabase *db) {
        FMResultSet* set = [db executeQuery:executeSQL];
        results = [self executeResult:set Class:modelClass tableName:nil];
        [set close];
    }];
    return results;
}

// mapping result to NSDictionary
- (NSMutableArray * )executeQuery:(NSString * )executeSQL
{
    __block NSMutableArray* results = nil;
    [self executeDB:^(FMDatabase *db) {
        FMResultSet* set = [db executeQuery:executeSQL];
        results = [self executeResult:set];
        [set close];
    }];
    return results;
}

- (NSMutableArray * )executeResult:(FMResultSet * )set
{
    NSMutableArray*  array = [NSMutableArray arrayWithCapacity:0];
    int columnCount = [set columnCount];
    while ([set next]) {
        NSMutableDictionary* bindingModel = [[NSMutableDictionary alloc] init];
        for (int i=0; i<columnCount; i++) {
            NSString*  sqlName = [set columnNameForIndex:i];
            NSObject*  sqlValue = [set objectForColumnIndex:i];
            [bindingModel setObject:sqlValue forKey:sqlName];
        }
        [array addObject:bindingModel];
    }
    return array;
}

@end



@interface LKDBSelect(){
    LKSQLCompositeCondition * conditionGroup;
    
    int limit ;
    int offset ;
    
    NSMutableArray<NSString *> * groupByList;
    NSMutableArray<NSString *> * orderByList;
    
    Class _fromtable;
    BOOL selectCount;
    LKDBHelper * helper;
    NSMutableArray<NSString *> * propNames;
}
@end

@implementation LKDBSelect

// MARK:- DB cretieria
- (instancetype)init:(NSArray *)propName{
    if (self = [super init]) {
        conditionGroup = [LKSQLCompositeCondition clause];
        groupByList = [NSMutableArray array];
        orderByList = [NSMutableArray array];
        propNames = [NSMutableArray array];
        
        if(propName)
            [propNames addObjectsFromArray:propName];
        
        limit = -1;
        offset = -1;
        // FIXME: bad practice
        helper = [LKDBHelper getUsingLKDBHelper];
    }
    return self;
}

- (instancetype)from:(Class)fromtable{
    _fromtable = fromtable;
    return self;
}

- (instancetype)orderBy:(NSString * )orderBy ascending:(BOOL)ascending{
    if(ascending){
        [orderByList addObject:[NSString stringWithFormat:@"%@ ASC",orderBy]];
    }else{
        [orderByList addObject:[NSString stringWithFormat:@"%@ DESC",orderBy]];
    }
    return self;
}

- (instancetype)groupBy:(NSString * )groupBy{
    [groupByList addObject:groupBy];
    return self;
}

- (instancetype)offset:(int)_offset{
    offset = _offset;
    return self;
}
- (instancetype)limit:(int)_limit{
    limit = _limit;
    return self;
}

// MARK: LKDBConditiongGroup wrapper
- (instancetype)where:(LKSQLCondition * )sqlCondition{
    conditionGroup.expr(sqlCondition);
    return self;
}

// MARK:- Translate `SELECT`
- (NSString * )executeSQL{
    NSString * colunms = @"*";
    if(propNames.count>0){
        colunms = [propNames componentsJoinedByString:@","];
    }
    
    NSMutableString * sql = [NSMutableString string];
    [sql appendString:@"SELECT "];
    if(selectCount){
        [sql appendString:@"COUNT("];
        [sql appendString:colunms];
        [sql appendString:@") as count"];
    }else{
        [sql appendString:colunms];
    }
    
    [sql appendString:@" FROM "];
    [sql appendString:[_fromtable getTableName]];
    [sql appendString:@" "];
    
    NSString *conditionQuery = [conditionGroup toString];
    if(conditionQuery.length>0){
        [sql appendString:@"WHERE "];
    }
    [sql appendString:conditionQuery];
    
    if(groupByList.count>0){
        [sql appendString:@" GROUP BY "];
        [sql appendString:[groupByList componentsJoinedByString:@","]];
    }
    
    if(orderByList.count>0){
        [sql appendString:@" ORDER BY "];
        [sql appendString:[orderByList componentsJoinedByString:@","]];
    }
    
    // TODO: offset ?????
    if(offset != -1 && limit != -1){
        [sql appendFormat:@" LIMIT %d,%d",offset,limit];
    }else if (limit != -1){
        [sql appendFormat:@" LIMIT %d",limit];
    }
    
    NSLog(@"## [SqlBuilder] sql:\n\n%@\n\n.",sql);
    return sql;
}

- (NSString *)getQuery{
    return [self executeSQL];
}

// MARK:- LKDB wrapper
- (NSMutableArray * )queryList{
    return [helper executeQuery:[self executeSQL] toClass:_fromtable];
}

- (NSMutableArray * )queryOriginalList{
    return [helper executeQuery:[self executeSQL]];
}

- (id)querySingle{
    limit = 1;
    
    NSMutableArray *result =  [helper executeQuery:[self executeSQL] toClass:_fromtable];
    if(result.count>0)
        return result.firstObject;
    
    return  nil;
}

- (id)queryOriginaSingle{
    limit = 1;
    
    NSMutableArray *result =  [helper executeQuery:[self executeSQL]];
    if(result.count>0)
        return result.firstObject;
    
    return  nil;
}

- (int)queryCount{
    selectCount =YES;
    NSArray *results = [helper executeQuery:[self executeSQL]];
    int count = 0;
    if([results count] > 0){
        count = (int)[[[results firstObject] objectForKey:@"count"] intValue];
    }
    return count;
}

@end
