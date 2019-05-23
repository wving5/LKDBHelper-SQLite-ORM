 

#import <Foundation/Foundation.h>

/* Useless wrapper cuz `NSObject+LKDBHelper.h` is enough to use
 *
 * But, create some BaseModel Class is a good practice for using `LKDBHelper` in REAL-WORLD project
 *
 */

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
