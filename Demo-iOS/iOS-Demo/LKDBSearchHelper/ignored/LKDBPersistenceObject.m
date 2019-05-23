 

#import "LKDBPersistenceObject.h"
#import <objc/runtime.h>
#import "LKDBSQLite.h"
#import "LKDBHelper.h"

@implementation LKDBPersistenceObject

+ (void)initialize
{
    //remove unwant property
    for (NSString *property in [[self class] transients]) {
        [self removePropertyWithColumnName:property];
    }
}

+ (NSArray *)transients{
    return nil;
}

+ (id)queryByRowId:(NSInteger)rowid{
    // TODO: mixed function-calling style is so ugly
    return [[[[LKDBSQLite select:nil] from:[self class]] where:LKSQLCompositeCondition.clause.where.eq(@"row",@(rowid))]
            querySingle];
}

+ (NSArray *)queryList{
    return [[[LKDBSQLite select:nil] from:[self class]] queryList];
}

+ (int)count{
    return  [[[LKDBSQLite select:nil] from:[self class]] queryCount];
}

- (int)saveToDB{
    return  [LKDBSQLite insert:self];
}

- (int)updateToDB{
    return  [LKDBSQLite update:self];
}

- (void)deleteToDB{
    [LKDBSQLite delete:self];
}

+ (void)dropToDB{
    [LKDBSQLite dropTable:[self class]];
}

@end
