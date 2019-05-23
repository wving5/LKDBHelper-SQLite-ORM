

#import "LKDBDelete.h"
#import "LKSQLCompositeCondition.h"
#import "LKDBHelper.h"

@interface LKDBDelete(){
    LKSQLCompositeCondition *conditionGroup;
    
    // Refer:   https://www.sqlite.org/lang_delete.html
    // But we ignore all this params for simple...
    int limit ;
    int offset ;
    NSMutableArray<NSString *> *orderByList;
    
    Class _fromtable;
    BOOL selectCount;
    LKDBHelper *helper;
}
@end

@implementation LKDBDelete
- (instancetype)init{
    if (self = [super init]) {
        conditionGroup = [LKSQLCompositeCondition clause];
        
        orderByList = [NSMutableArray array];
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

// MARK: LKSQLCondition wrapper
- (instancetype)where:(LKSQLCondition *)sqlCondition{
    conditionGroup.expr(sqlCondition);
    return self;
}

// MARK: SQL translate
- (NSString *)executeSQL{
    NSMutableString *sql =[NSMutableString new];
    [sql appendString:@"DELETE FROM "];
    [sql appendString:[_fromtable getTableName]];
    [sql appendString:@" "];
    
    NSString *conditionQuery = [conditionGroup toString];
    if(conditionQuery.length>0){
        [sql appendString:@"WHERE "];
    }
    [sql appendString:conditionQuery];
    
    NSLog(@"## [SqlBuilder] sql:\n\n%@\n\n.",sql);
    return sql;
}

- (NSString *)getQuery{
    return [self executeSQL];
}

// MARK:- LKDB wrappper
- (BOOL)execute{
    return [helper executeSQL:[self executeSQL] arguments:nil];
}
 
@end
