

#import "LKDBSQLite.h"
#import "LKDBHelper.h"
#import "LKDBTransaction.h"

@implementation LKDBSQLite

+ (LKDBSelect *)select{
    return [[LKDBSelect alloc] init:nil];
}

+ (LKDBSelect *)select:(NSArray *)propNames{
    return [[LKDBSelect alloc] init:propNames];
}

+ (LKDBDelete *)delete{
    return [[LKDBDelete alloc] init];
}

+ (LKDBTransaction *)transaction{
    return [[LKDBTransaction alloc] init];
}

#pragma mark - LKDB wrapper
+ (void)executeForTransaction:(BOOL (^)(void))block{
    [[LKDBTransaction new] executeForTransaction:block];
}

+ (int)update:(LKDBPersistenceObject *)object{
    return [LKDBSQLite update:object helper:[LKDBHelper getUsingLKDBHelper]];
}

+ (int)insert:(LKDBPersistenceObject *)object{
    return [LKDBSQLite insert:object helper:[LKDBHelper getUsingLKDBHelper]];
}

+ (void)delete:(LKDBPersistenceObject *)object{
    [LKDBSQLite delete:object helper:[LKDBHelper getUsingLKDBHelper]];
}

+ (void)dropTable:(Class)clazz{
    [LKDBSQLite dropTable:clazz helper:[LKDBHelper getUsingLKDBHelper]];
}

+ (int)update:(LKDBPersistenceObject *)object helper:(LKDBHelper *)helper{
    [helper updateToDB:object where:@{@"rowid":[NSNumber numberWithInteger:object.rowid]}];
    return (int)object.rowid;
}

+ (int)insert:(LKDBPersistenceObject *)object helper:(LKDBHelper *)helper{
    [helper  insertToDB:object];
    return (int)object.rowid;
}

+ (void)delete:(LKDBPersistenceObject *)object helper:(LKDBHelper *)helper{
    [helper  deleteToDB:object];
}

+ (void)dropTable:(Class)clazz helper:(LKDBHelper *)helper{
    [helper dropTableWithClass:clazz];
}

@end
