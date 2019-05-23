

#import <Foundation/Foundation.h>
#import "LKSQLCondition.h"

//MARK: Multi Condition Builder

@interface LKSQLCompositeCondition : LKSQLCondition

+ (instancetype)clause;

// SQL criteria
- (LKSQLCompositeCondition *)where;
- (LKSQLCompositeCondition *)or;
- (LKSQLCompositeCondition *)and;

- (LKSQLCompositeCondition *(^)(LKSQLCondition *))expr;
- (LKSQLCompositeCondition *(^)(NSArray<LKSQLCondition *> *))matchAll;
- (LKSQLCompositeCondition *(^)(NSArray<LKSQLCondition *> *))matchAny;

- (LKSQLCompositeCondition *(^)(NSString *, id))eq;
- (LKSQLCompositeCondition *(^)(NSString *, id))neq;
- (LKSQLCompositeCondition *(^)(NSString *, id))lt;
- (LKSQLCompositeCondition *(^)(NSString *, id))lte;
- (LKSQLCompositeCondition *(^)(NSString *, id))gt;
- (LKSQLCompositeCondition *(^)(NSString *, id))gte;
- (LKSQLCompositeCondition *(^)(NSString *, id))like;
- (LKSQLCompositeCondition *(^)(NSString *, id))isNot;
- (LKSQLCompositeCondition *(^)(NSString *, NSArray<id>*))inStrs;
- (LKSQLCompositeCondition *(^)(NSString *, NSArray<id>*))inNums;


- (NSString *)toString;

@end
