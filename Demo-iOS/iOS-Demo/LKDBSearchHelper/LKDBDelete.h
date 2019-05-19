 

#import <Foundation/Foundation.h> 
#import "LKDBConditionGroup.h"
#import "LKDBSQLCondition.h"
#import "LKDBPersistenceObject.h"


@interface LKDBDelete : NSObject

- (instancetype)init;

- (instancetype)from:(__unsafe_unretained Class)fromtable;
 
- (instancetype)Where:(LKDBSQLCondition *)sqlCondition;
- (instancetype)and:(LKDBSQLCondition *)sqlCondition;
- (instancetype)or:(LKDBSQLCondition *)sqlCondition;

//查询条件包含括号,会构造一个新的 LKDBConditionGroup,小括号包含 
- (LKDBConditionGroup *)innerAndConditionGroup;

- (LKDBConditionGroup *)innerOrConditionGroup;

- (NSString *)getQuery;

- (BOOL)execute;

@end
