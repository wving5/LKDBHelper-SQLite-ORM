 

#import <Foundation/Foundation.h>

@interface LKDBPersistenceObject : NSObject

+ (NSArray *)transients;  //@override 忽略的字段

+ (int)count;
+ (id)queryByRowId:(NSInteger)rowid;
+ (NSArray *)queryList;
- (int)saveToDB;
- (int)updateToDB;
- (void)deleteToDB;
+ (void)dropToDB;

@end
