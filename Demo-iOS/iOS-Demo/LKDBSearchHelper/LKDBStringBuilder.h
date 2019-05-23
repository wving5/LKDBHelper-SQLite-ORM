 

#import <Foundation/Foundation.h>

//MARK: Just a string builder wrapper
@interface LKDBStringBuilder : NSObject

- (LKDBStringBuilder *)append:(NSString *)object;
- (LKDBStringBuilder *)appendSpace;

- (NSString *)toString;

@end
