 
#import "LKDBDelete.h"
#import "LKDBConditionGroup.h"
#import "LKDBQueryBuilder.h"

#import "LKDBHelper.h"


@interface LKDBHelper(LKDBDelete)
- (BOOL)executeSQL:(NSString*)sql;
@end

@implementation LKDBHelper(LKDBDelete)
- (BOOL)executeSQL:(NSString*)sql
{
    return [self executeSQL:sql arguments:nil];
}
@end

@interface LKDBDelete(){
    LKDBConditionGroup *conditionGroup;
    
    int limit ;
    int offset ;
    
    NSMutableArray<NSString *> *groupByList;
    NSMutableArray<NSString *> *orderByList;
    
    Class _fromtable;
    BOOL selectCount;
    LKDBHelper *helper;
}
@end

@implementation LKDBDelete
- (instancetype)init{
    self = [super init];
    if (self) {
        conditionGroup =[LKDBConditionGroup clause];
        
        groupByList =[NSMutableArray new];
        orderByList =[NSMutableArray new];
        
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
 
- (instancetype)Where:(LKDBSQLCondition *)sqlCondition{
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

- (instancetype)andAll:(NSArray<LKDBSQLCondition *> *)sqlConditions{
    [conditionGroup andAll:sqlConditions];
    return self;
}

- (instancetype)orAll:(NSArray<LKDBSQLCondition *> *)sqlConditions{
    [conditionGroup orAll:sqlConditions];
    return self;
}

- (LKDBConditionGroup *)innerAndConditionGroup{
    return [conditionGroup innerAndConditionGroup];
}

- (LKDBConditionGroup *)innerOrConditionGroup{
    return [conditionGroup innerOrConditionGroup];
}

- (NSString *)executeSQL{
    NSMutableString *sql =[NSMutableString new];
    [sql appendString:@"DELETE FROM "];
    [sql appendString:[_fromtable getTableName]];
    [sql appendString:@" "];
    
    NSString *conditionQuery = [conditionGroup getQuery];
    if(conditionQuery.length>0){
        [sql appendString:@"WHERE "];
    }
    [sql appendString:conditionQuery];
    
    NSLog(@"sql:%@",sql);
    return sql;
}

- (NSString *)getQuery{
    return [self executeSQL];
}

- (BOOL)execute{
    return [helper  executeSQL:[self executeSQL]];
}
 
@end
