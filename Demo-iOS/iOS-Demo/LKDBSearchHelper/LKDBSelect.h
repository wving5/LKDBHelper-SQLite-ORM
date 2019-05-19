 

#import <Foundation/Foundation.h> 
#import "LKDBConditionGroup.h"
#import "LKDBSQLCondition.h"
#import "LKDBPersistenceObject.h"

extern NSString*  LKDB_Distinct(NSString * name);

@interface LKDBSelect : NSObject

- (instancetype)init:(NSArray * _Nullable)propNames;

- (instancetype)from:(__unsafe_unretained Class )fromtable;
 
- (instancetype)Where:(LKDBSQLCondition *)sqlCondition;
- (instancetype)and:(LKDBSQLCondition *)sqlCondition;
- (instancetype)or:(LKDBSQLCondition *)sqlCondition;

//查询条件包含括号,会构造一个新的 LKDBConditionGroup,小括号包含 
- (LKDBConditionGroup *)innerAndConditionGroup;

- (LKDBConditionGroup *)innerOrConditionGroup;
 
- (instancetype)orderBy:(NSString * )orderBy ascending:(BOOL)ascending;
- (instancetype)groupBy:(NSString * )groupBy;

- (instancetype)offset:(int)offset;
- (instancetype)limit:(int)limit;

- ( NSString * )getQuery;

- (NSArray<LKDBPersistenceObject *> * )queryList;
- (id)querySingle;

- (NSArray * )queryOriginalList;
- (id )queryOriginaSingle;

- (int)queryCount;

@end
