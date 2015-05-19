
#import <Foundation/Foundation.h>

@interface UnityStoreEventDispatcher : NSObject{

}
@property (retain, nonatomic) NSString* recieverName;

- (id)init:(NSString*)recieverName;
- (void)handleEvent:(NSNotification*)notification;
+ (void)initialize:(NSString*)recieverName;

@end
