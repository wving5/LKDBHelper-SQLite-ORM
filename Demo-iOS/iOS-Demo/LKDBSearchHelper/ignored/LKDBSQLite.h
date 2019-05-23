 

#import <Foundation/Foundation.h>
#import "LKDBTransaction.h"
#import "LKDBSelect.h"
#import "LKDBDelete.h"

/* Useless wrapper */

// TODO: conflict with reserved keyword `delete` `and` `or` from C++ ?

@interface LKDBSQLite : NSObject

// MARK: DAO wrapper
+ (LKDBSelect *)select;
+ (LKDBSelect *)select:(NSArray *)propNames;
+ (LKDBDelete *)delete;
+ (LKDBTransaction *)transaction;

// MARK: LKDB wrapper
+ (int)update:(LKDBPersistenceObject *)object;
+ (int)insert:(LKDBPersistenceObject *)object;
+ (void)delete:(LKDBPersistenceObject *)object;
+ (void)dropTable:(Class)clazz;
+ (void)executeForTransaction:(BOOL (^)(void))block;

@end
