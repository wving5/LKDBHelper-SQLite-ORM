 

#import <Foundation/Foundation.h> 
#import "LKSQLCompositeCondition.h"
#import "LKSQLCondition.h"
#import "LKDBPersistenceObject.h"

// TODO: refactor BAD practice

extern NSString*  LKDB_Distinct(NSString * name);

@interface LKDBSelect : NSObject

- (instancetype)init:(NSArray * _Nullable)propNames;

- (instancetype)from:(__unsafe_unretained Class )fromtable;
- (instancetype)orderBy:(NSString * )orderBy ascending:(BOOL)ascending;
- (instancetype)groupBy:(NSString * )groupBy;
- (instancetype)offset:(int)offset;
- (instancetype)limit:(int)limit;

/* LKSQLCondition wrapper */
- (instancetype)where:(LKSQLCondition *)sqlCondition;

/* SQL translate */
- ( NSString * )getQuery;

/* LKDB wrapper */
- (NSArray<LKDBPersistenceObject *> * )queryList;
- (id)querySingle;
- (NSArray * )queryOriginalList;
- (id )queryOriginaSingle;
- (int)queryCount;

@end
