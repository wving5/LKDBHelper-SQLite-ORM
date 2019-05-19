 
#import "LKDBSelect.h"
#import "LKDBConditionGroup.h"
#import "LKDBQueryBuilder.h"

#import "LKDBHelper.h" 

extern NSString* LKDB_Distinct(NSString *name){
    return [@"DISTINCT " stringByAppendingString:name];
}
@interface LKDBHelper(LKDBSelect)

- (NSMutableArray * )executeQuery:(NSString * )sql toClass:(Class)modelClass;


- (NSMutableArray * )executeQuery:(NSString * )sql;


- (NSMutableArray * )executeResult:(FMResultSet * )set Class:(Class)modelClass tableName:(NSString * _Nullable )tableName;

@end

@implementation LKDBHelper(LKDBSelect)

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
        
        NSMutableDictionary*  bindingModel = [[NSMutableDictionary alloc]init];
        
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
    LKDBConditionGroup * conditionGroup;
    
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
- (instancetype)init:(NSArray *)propName{
    
    self = [super init];
    if (self) {
        conditionGroup =[LKDBConditionGroup clause];
        
        groupByList =[NSMutableArray new];
        orderByList =[NSMutableArray new];
        
        propNames =[NSMutableArray new];
        
        if(propName)
            [propNames addObjectsFromArray:propName];
        
        limit = -1;
        offset = -1;
        helper = [LKDBHelper getUsingLKDBHelper];
        
    }
    return self;
}

- (instancetype)from:(Class)fromtable{
    _fromtable =fromtable;
    return self;
}
 
- (instancetype)Where:(LKDBSQLCondition * )sqlCondition{
    [conditionGroup operator:nil sqlCondition:sqlCondition];
    return self;
}

- (instancetype)or:(LKDBSQLCondition *)sqlCondition{
    [conditionGroup or:sqlCondition];
    return self;
}

- (instancetype)and:(LKDBSQLCondition *)sqlCondition{
    [conditionGroup and:sqlCondition];
    return self;
} 

- (instancetype)andAll:(NSArray<LKDBSQLCondition *> * )sqlConditions{
    [conditionGroup andAll:sqlConditions];
    return self;
}

- (instancetype)orAll:(NSArray<LKDBSQLCondition *> * )sqlConditions{
    [conditionGroup orAll:sqlConditions];
    return self;
}

- (LKDBConditionGroup * )innerAndConditionGroup{
    return [conditionGroup innerAndConditionGroup];
}

- (LKDBConditionGroup * )innerOrConditionGroup{
    return [conditionGroup innerOrConditionGroup];
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

- (NSString * )executeSQL{
    NSString * select = @"*";
    if(propNames.count>0){
        select = [propNames componentsJoinedByString:@","];
    }
    
    NSMutableString * sql =[NSMutableString new];
    [sql appendString:@"SELECT "];
    if(selectCount){
        [sql appendString:@"COUNT("];
        [sql appendString:select];
        [sql appendString:@") as count"];
    }else{
        [sql appendString:select];
    }
    [sql appendString:@" FROM "];
    [sql appendString:[_fromtable getTableName]];
    [sql appendString:@" "];
    
    NSString *conditionQuery = [conditionGroup getQuery];
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
    
    if(offset!=-1&&limit!=-1){
        [sql appendFormat:@" LIMIT %d,%d",offset,limit];
    }else if (limit!=-1){
        [sql appendFormat:@" LIMIT %d",limit];
    }
    
    NSLog(@"sql:%@",sql);
    return sql;
}

- (NSString *)getQuery{
    return [self executeSQL];
}

- (NSMutableArray * )queryList{
    return [helper  executeQuery:[self executeSQL] toClass:_fromtable];
}

- (NSMutableArray * )queryOriginalList{
    return [helper  executeQuery:[self executeSQL]];
}

- (id)querySingle{
    limit = 1;
    
    NSMutableArray *result =  [helper  executeQuery:[self executeSQL] toClass:_fromtable];
    if(result.count>0)
        return result.firstObject;
    
    return  nil;
}

- (id)queryOriginaSingle{
    limit = 1;
    
    NSMutableArray *result =  [helper  executeQuery:[self executeSQL]];
    if(result.count>0)
        return result.firstObject;
    
    return  nil;
}

- (int)queryCount{
    selectCount =YES;
    NSArray *counts = [helper  executeQuery:[self executeSQL]];
    int _count=0;
    if([counts count]>0){
        _count=(int)((NSNumber *)[((NSDictionary *)[counts firstObject]) objectForKey:@"count"]).intValue;
    }
    return _count;
}

@end
