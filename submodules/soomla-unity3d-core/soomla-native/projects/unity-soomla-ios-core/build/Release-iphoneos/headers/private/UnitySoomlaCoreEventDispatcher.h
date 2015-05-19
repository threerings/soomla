
#import <Foundation/Foundation.h>

@interface UnitySoomlaCoreEventDispatcher : NSObject{
    
}
- (id)init;
- (void)handleEvent:(NSNotification*)notification;
+ (void)initialize;

@end
