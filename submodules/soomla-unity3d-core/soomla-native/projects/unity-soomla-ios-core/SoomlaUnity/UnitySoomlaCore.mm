#import "Soomla.h"
#import "UnityCommons.h"
#import "Reward.h"
#import "SequenceReward.h"
#import "RewardStorage.h"
#import "SoomlaUtils.h"
#import "UnitySoomlaCoreEventDispatcher.h"
#import "SoomlaConfig.h"
#import "KeyValueStorage.h"

extern "C" {
    void soomlaCore_Init(const char* secret, bool debug) {
        LogDebug(@"SOOMLA Unity UnitySoomlaCore", @"Initializing SoomlaEventHandler ...");
        
        DEBUG_LOG = debug;
        [UnitySoomlaCoreEventDispatcher initialize];
        [Soomla initializeWithSecret:[NSString stringWithUTF8String:secret]];
    }
    
    void keyValStorage_GetValue(const char* key, char** retVal) {
        NSString* keyS = [NSString stringWithUTF8String:key];
        NSString* valS = [KeyValueStorage getValueForKey:keyS];
        if (!valS) {
            valS = @"";
        }
        
        *retVal = Soom_AutonomousStringCopy([valS UTF8String]);
    }
    
    void keyValStorage_SetValue(const char* key, const char* val) {
        NSString* keyS = [NSString stringWithUTF8String:key];
        NSString* valS = [NSString stringWithUTF8String:val];
        
        [KeyValueStorage setValue:valS forKey:keyS];
    }
    
    void keyValStorage_DeleteKeyValue(const char* key) {
        NSString* keyS = [NSString stringWithUTF8String:key];
        
        [KeyValueStorage deleteValueForKey:keyS];
    }

    long rewardStorage_GetLastGivenTimeMillis(const char* rewardId) {
        NSString* rewardIdS = [NSString stringWithUTF8String:rewardId];
        
        return [RewardStorage getLastGivenTimeMillisForReward:rewardIdS];
    }
    
    int rewardStorage_GetTimesGiven(const char* rewardId) {
        NSString* rewardIdS = [NSString stringWithUTF8String:rewardId];
        
        return [RewardStorage getTimesGivenForReward:rewardIdS];
    }
    
    void rewardStorage_SetTimesGiven(const char* rewardId, bool up, bool notify) {
        NSString* rewardIdS = [NSString stringWithUTF8String:rewardId];
        
        [RewardStorage setTimesGivenForReward:rewardIdS up:up andNotify:notify];
    }

    int rewardStorage_GetLastSeqIdxGiven(const char* rewardId) {
        NSString* rewardIdS = [NSString stringWithUTF8String:rewardId];
        
        return [RewardStorage getLastSeqIdxGivenForSequenceReward:rewardIdS];
    }

    void rewardStorage_SetLastSeqIdxGiven(const char* rewardId, int idx) {
        NSString* rewardIdS = [NSString stringWithUTF8String:rewardId];
        
        return [RewardStorage setLastSeqIdxGiven:idx ForSequenceReward:rewardIdS];
    }    
}