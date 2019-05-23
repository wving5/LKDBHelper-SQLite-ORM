 

#import "LKDBTransaction.h"
#import "LKDBHelper.h"


typedef NS_ENUM(NSUInteger, LKDBPersistenceObjectAction) {
    LKDBPersistenceObjectActionInsert = 0,
    LKDBPersistenceObjectActionUpdate = 1,
    LKDBPersistenceObjectActionRemove = 2,
};

@interface LKDBTransactionData : NSObject
@property (nonatomic,strong) LKDBPersistenceObject *object;
@property (nonatomic,assign) LKDBPersistenceObjectAction action;

+ (LKDBTransactionData *)init:(LKDBPersistenceObject *)object action:(LKDBPersistenceObjectAction)action;
@end

@implementation LKDBTransactionData
+ (LKDBTransactionData *)init:(LKDBPersistenceObject *)object action:(LKDBPersistenceObjectAction)action{
    LKDBTransactionData *data = [LKDBTransactionData new];
    data.object = object;
    data.action = action;
    return data;
}
@end


@interface LKDBTransaction() {
    NSMutableArray <LKDBTransactionData *> *actionDatas;
}
@end

@implementation LKDBTransaction
- (instancetype)init
{
    self = [super init];
    if (self) {
        actionDatas = [NSMutableArray array];
    }
    return self;
}

// MARK:- DB ops wrapper
- (LKDBTransaction *)updateAll:(NSArray<LKDBPersistenceObject *> *)datas{
    for (LKDBPersistenceObject *object in datas) {
        LKDBTransactionData *data =[LKDBTransactionData init:object action:LKDBPersistenceObjectActionUpdate];
        [actionDatas addObject:data];
    }
    return self;
}

- (LKDBTransaction *)insertAll:(NSArray<LKDBPersistenceObject *> *)datas{
    for (LKDBPersistenceObject *object in datas) {
        LKDBTransactionData *data =[LKDBTransactionData init:object action:LKDBPersistenceObjectActionInsert];
        [actionDatas addObject:data];
    }
    return self;
}

- (LKDBTransaction *)deleteAll:(NSArray<LKDBPersistenceObject *> *)datas{
    for (LKDBPersistenceObject *object in datas) {
        LKDBTransactionData *data =[LKDBTransactionData init:object action:LKDBPersistenceObjectActionRemove];
        [actionDatas addObject:data];
    }
    return self;
}

- (LKDBTransaction *)update:(LKDBPersistenceObject *)object{
    LKDBTransactionData *data =[LKDBTransactionData init:object action:LKDBPersistenceObjectActionUpdate];
    [actionDatas addObject:data];
    return self;
}

- (LKDBTransaction *)insert:(LKDBPersistenceObject *)object{
    LKDBTransactionData *data =[LKDBTransactionData init:object action:LKDBPersistenceObjectActionInsert];
    [actionDatas addObject:data];
    return self;
}

- (LKDBTransaction *)delete:(LKDBPersistenceObject *)object{
    LKDBTransactionData *data =[LKDBTransactionData init:object action:LKDBPersistenceObjectActionRemove];
    [actionDatas addObject:data];
    return self;
}

// MARK:- excute
- (void)execute{
    [[LKDBHelper getUsingLKDBHelper] executeForTransaction:^BOOL(LKDBHelper *helper) {
        @try {
            for (LKDBTransactionData *object in actionDatas) {
                if(object.action==LKDBPersistenceObjectActionInsert)
                    [object.object saveToDB];
                
                if(object.action==LKDBPersistenceObjectActionUpdate)
                    [object.object updateToDB];
                
                if(object.action==LKDBPersistenceObjectActionRemove)
                    [object.object deleteToDB];
            }
            return YES;
        } @catch (NSException *exception) {
             return NO;
        }
    }];
}

- (void)executeForTransaction:(BOOL (^)(void))block{
    [[LKDBHelper getUsingLKDBHelper] executeForTransaction:^BOOL(LKDBHelper *helper) {
        return block();
    }];
}

@end
