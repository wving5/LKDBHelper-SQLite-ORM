//
//  LKDBSQLBuilderTest.m
//  iOS-Demo
//
//  Copyright © 2019年 Mars. All rights reserved.
//

#import "LKDBSQLBuilderTest.h"
#import "LKSQLCompositeCondition.h"
#import <UIKit/UIKit.h>


@implementation LKDBSQLBuilderTest
#if ENALBE_LKDBSQLBuilderTest == 1

#define DEBUGLOG(fmt, ...) NSLog(fmt "\n...", ##__VA_ARGS__)

+ (void)load
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

+ (void)test {
    LKSQLCompositeCondition *cond = nil;
    
    DEBUGLOG(@"### RUNNING TEST <%@>\n=================", self);
    
    // TEST single condition
    DEBUGLOG(@"#TEST single condition");
    // empty
    cond = LKSQLCompositeCondition.clause;
    NSAssert(cond.toString.length == 0, @"EMPTY clause SHOULD print ''");
    // eq
    cond = LKSQLCompositeCondition.clause.where.eq(@"colA", @0.1);
    DEBUGLOG(@"%@", cond.toString);
    // neq
    cond = LKSQLCompositeCondition.clause.where.neq(@"colA", @"0.01");
    DEBUGLOG(@"%@", cond.toString);
    // lt
    cond = LKSQLCompositeCondition.clause.where.lt(@"colA", @0.001);
    DEBUGLOG(@"%@", cond.toString);
    // lte
    cond = LKSQLCompositeCondition.clause.where.lte(@"colA", @"0.0001");
    DEBUGLOG(@"%@", cond.toString);
    // gt
    cond = LKSQLCompositeCondition.clause.where.gt(@"colA", @(0.0000001)); // REMARK: here NSNumber's auto-Scientific-notation is OK for SQLite's syntax
    DEBUGLOG(@"%@", cond.toString);
    // gte
    cond = LKSQLCompositeCondition.clause.where.gte(@"colA", @"0.000000000001");
    DEBUGLOG(@"%@", cond.toString);
    // like
    cond = LKSQLCompositeCondition.clause.where.like(@"colA", @"0.000000000001");
    DEBUGLOG(@"%@", cond.toString);
    // isNot
    cond = LKSQLCompositeCondition.clause.where.isNot(@"colA", @"0.000000000001");
    DEBUGLOG(@"%@", cond.toString);
    // inStr
    cond = LKSQLCompositeCondition.clause.where.inStrs(@"colA", @[@"val1", @"val2", @"val2"]);
    DEBUGLOG(@"%@", cond.toString);
    // inNum
    cond = LKSQLCompositeCondition.clause.where.inNums(@"colA", @[@1, @2, @3]);
    DEBUGLOG(@"%@", cond.toString);
    
    // nullable case
    // eq
    cond = LKSQLCompositeCondition.clause.where.eq(@"colA", nil);
    DEBUGLOG(@"%@", cond.toString);
    // inStr
    cond = LKSQLCompositeCondition.clause.where.inStrs(@"colA", @[]);
    DEBUGLOG(@"%@", cond.toString);
    cond = LKSQLCompositeCondition.clause.where.inStrs(@"colA", nil);
    DEBUGLOG(@"%@", cond.toString);
    // inNum
    cond = LKSQLCompositeCondition.clause.where.inNums(@"colA", @[]);
    DEBUGLOG(@"%@", cond.toString);
    cond = LKSQLCompositeCondition.clause.where.inNums(@"colA", nil);
    DEBUGLOG(@"%@", cond.toString);
    
    
    // TEST condition group
    // AND, OR
    DEBUGLOG(@"#TEST AND, OR");
    cond = LKSQLCompositeCondition.clause.where
    .eq(@"colA", nil)
    .neq(@"colB", nil)
    .lt(@"colC", nil)
    .and.lte(@"colD", nil)
    .gt(@"colE", nil)
    .gte(@"colF", nil)
    .like(@"colG", nil)
    .isNot(@"colH", nil)
    .inStrs(@"colI", nil)
    .inNums(@"colJ", nil)
    .or.eq(@"colA", nil)
    .or.neq(@"colB", nil)
    .or.lt(@"colC", nil)
    .and.lte(@"colD", nil)
    .or.gt(@"colE", nil)
    .or.gte(@"colF", nil)
    .or.like(@"colG", nil)
    .or.isNot(@"colH", nil)
    .or.inStrs(@"colI", nil)
    .or.inNums(@"colJ", nil)
    ;
    DEBUGLOG(@"%@", cond.toString);
    
    // matchAll
    DEBUGLOG(@"#TEST matchAll");
    cond = LKSQLCompositeCondition.clause.where.eq(@"colA", nil).matchAll(
        @[
          LKSQLCompositeCondition.clause.where.eq(@"colA", nil).neq(@"colAA", nil),
          LKSQLCompositeCondition.clause.where.eq(@"colB", nil).neq(@"colBA", nil),
          LKSQLCompositeCondition.clause.where.eq(@"colC", nil).neq(@"colCA", nil),
          ]
    )
    .and.lte(@"colD", nil)
    .or.eq(@"colA", nil)
    .and.lte(@"colC", nil)
    ;
    DEBUGLOG(@"%@", cond.toString);
    
    // matchAny
    DEBUGLOG(@"#TEST matchAny");
    cond = LKSQLCompositeCondition.clause.where.eq(@"colA", nil).matchAny(
                                                                     @[
                                                                       LKSQLCompositeCondition.clause.where.eq(@"colA", nil).neq(@"colAA", nil),
                                                                       LKSQLCompositeCondition.clause.where.eq(@"colB", nil).neq(@"colBA", nil),
                                                                       LKSQLCompositeCondition.clause.where.eq(@"colC", nil).neq(@"colCA", nil),
                                                                       ]
                                                                     )
    .and.lte(@"colD", nil)
    .or.eq(@"colA", nil)
    .and.lte(@"colC", nil)
    ;
    DEBUGLOG(@"%@", cond.toString);
    
    // nested condition
    DEBUGLOG(@"#TEST nested condition");
    cond = LKSQLCompositeCondition.clause.where.eq(@"colA", nil).and.expr(
        LKSQLCompositeCondition.clause.where.eq(@"colAA", nil).or.neq(@"colAB", nil).and.expr(
            LKSQLCompositeCondition.clause.where.eq(@"colAAA", nil).or.neq(@"colAAB", nil)
            // ...endless nested conditon
        )
    )
    .and.lte(@"colD", nil)
    .or.eq(@"colA", nil)
    .and.lte(@"colC", nil)
    ;
    DEBUGLOG(@"%@", cond.toString);
}


#endif
@end





