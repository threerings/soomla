#import "Soomla.h"
#import "UnitySoomlaCoreEventDispatcher.h"
#import "SoomlaEventHandling.h"
#import "Reward.h"
#import "SoomlaUtils.h"

@implementation UnitySoomlaCoreEventDispatcher

+ (void)initialize {
    static UnitySoomlaCoreEventDispatcher* instance = nil;
    if (!instance) {
        instance = [[UnitySoomlaCoreEventDispatcher alloc] init];
    }
}

- (id) init {
    if (self = [super init]) {
        [SoomlaEventHandling observeAllEventsWithObserver:self withSelector:@selector(handleEvent:)];
    }
    
    return self;
}

- (void)handleEvent:(NSNotification*)notification{
    
	if ([notification.name isEqualToString:EVENT_REWARD_GIVEN]) {
        NSDictionary* userInfo = [notification userInfo];
        NSString* rewardId = [userInfo objectForKey:DICT_ELEMENT_REWARD];
        
        NSDictionary* eventJSON = @{
                                    @"rewardId": rewardId
                                    };
        
        UnitySendMessage("CoreEvents", "onRewardGiven", [[SoomlaUtils dictToJsonString:eventJSON] UTF8String]);
	}
	else if ([notification.name isEqualToString:EVENT_REWARD_TAKEN]) {
        NSDictionary* userInfo = [notification userInfo];
        NSString* rewardId = [userInfo objectForKey:DICT_ELEMENT_REWARD];
        
        NSDictionary* eventJSON = @{
                                    @"rewardId": rewardId
                                    };
        
        UnitySendMessage("CoreEvents", "onRewardTaken", [[SoomlaUtils dictToJsonString:eventJSON] UTF8String]);
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
        UnitySendMessage("CoreEvents", "onCustomEvent", [[SoomlaUtils dictToJsonString:eventJSON] UTF8String]);
    }
}

@end
