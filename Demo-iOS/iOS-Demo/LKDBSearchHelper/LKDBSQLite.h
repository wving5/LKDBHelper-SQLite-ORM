 

#import <Foundation/Foundation.h>
#import "LKDBTransaction.h"
#import "LKDBSelect.h"
#import "LKDBDelete.h"

@interface LKDBSQLite : NSObject

//事务管理
+ (void)executeForTransaction:(BOOL (^)(void))block;

+ (LKDBSelect *)select;

+ (LKDBSelect *)select:(NSArray *)propNames;

+ (LKDBDelete *)delete;

+ (LKDBTransaction *)transaction;

+ (int)update:(LKDBPersistenceObject *)object;

+ (int)insert:(LKDBPersistenceObject *)object;

+ (void)delete:(LKDBPersistenceObject *)object;

+ (void)dropTable:(Class)clazz;
 
@end
