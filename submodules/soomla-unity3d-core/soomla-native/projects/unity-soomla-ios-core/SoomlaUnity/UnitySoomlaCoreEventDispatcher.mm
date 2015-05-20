#import "Soomla.h"
#import "UnitySoomlaCoreEventDispatcher.h"
#import "SoomlaEventHandling.h"
#import "Reward.h"
#import "SoomlaUtils.h"

@implementation UnitySoomlaCoreEventDispatcher

+ (void)initialize:(NSString*)recieverName  {
    static UnitySoomlaCoreEventDispatcher* instance = nil;
    if (!instance) {
        instance = [[UnitySoomlaCoreEventDispatcher alloc] init:recieverName];
    }
}

- (id) init:(NSString*)reciever  {
    if (self = [super init]) {
        [SoomlaEventHandling observeAllEventsWithObserver:self withSelector:@selector(handleEvent:)];
    }
    self.recieverName = reciever;
    return self;
}

- (void)handleEvent:(NSNotification*)notification {
    const char* reciever = [_recieverName UTF8String];
    
	if ([notification.name isEqualToString:EVENT_REWARD_GIVEN]) {
        NSDictionary* userInfo = [notification userInfo];
        NSString* rewardId = [userInfo objectForKey:DICT_ELEMENT_REWARD];
        
        NSDictionary* eventJSON = @{
                                    @"rewardId": rewardId
                                    };
        
        UnitySendMessage(reciever, "onRewardGiven", [[SoomlaUtils dictToJsonString:eventJSON] UTF8String]);
	}
	else if ([notification.name isEqualToString:EVENT_REWARD_TAKEN]) {
        NSDictionary* userInfo = [notification userInfo];
        NSString* rewardId = [userInfo objectForKey:DICT_ELEMENT_REWARD];
        
        NSDictionary* eventJSON = @{
                                    @"rewardId": rewardId
                                    };
        
        UnitySendMessage(reciever, "onRewardTaken", [[SoomlaUtils dictToJsonString:eventJSON] UTF8String]);
	}
    else if ([notification.name isEqualToString:EVENT_CUSTOM]) {
        NSDictionary* userInfo = [notification userInfo];
        NSString* name = [userInfo objectForKey:DICT_ELEMENT_NAME];
        NSDictionary* extraDict = [userInfo objectForKey:DICT_ELEMENT_EXTRA];
        if (extraDict) {
            extraDict = [NSDictionary dictionary];
        }
        NSDictionary* eventJSON = @{
                                    @"name": name,
                                    @"extra":extraDict
                                    };
        UnitySendMessage(reciever, "onCustomEvent", [[SoomlaUtils dictToJsonString:eventJSON] UTF8String]);
    }
}

@end
