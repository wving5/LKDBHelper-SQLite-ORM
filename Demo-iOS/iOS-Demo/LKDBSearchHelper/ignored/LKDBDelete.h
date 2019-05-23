 

#import <Foundation/Foundation.h> 
#import "LKSQLCompositeCondition.h"
#import "LKSQLCondition.h"
#import "LKDBPersistenceObject.h"

// TODO: refactor BAD practice

@interface LKDBDelete : NSObject

- (instancetype)init;

- (instancetype)from:(__unsafe_unretained Class)fromtable;

/* LKSQLCondition wrapper */
- (instancetype)where:(LKSQLCondition *)sqlCondition;

/* SQL translate */
- (NSString *)getQuery;

- (BOOL)execute;

@end
