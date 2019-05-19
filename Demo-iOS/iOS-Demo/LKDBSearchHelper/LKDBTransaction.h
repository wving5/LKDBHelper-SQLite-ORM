 

#import <Foundation/Foundation.h>
#import "LKDBPersistenceObject.h"

@interface LKDBTransaction : NSObject

- (LKDBTransaction *)updateAll:(NSArray<LKDBPersistenceObject *> *)datas;
- (LKDBTransaction *)insertAll:(NSArray<LKDBPersistenceObject *> *)datas;
- (LKDBTransaction *)deleteAll:(NSArray<LKDBPersistenceObject *> *)datas;
 
- (LKDBTransaction *)update:(LKDBPersistenceObject *)object;
- (LKDBTransaction *)insert:(LKDBPersistenceObject *)object;
- (LKDBTransaction *)delete:(LKDBPersistenceObject *)object;

- (void)execute;

- (void)executeForTransaction:(BOOL (^)(void))block;

@end
