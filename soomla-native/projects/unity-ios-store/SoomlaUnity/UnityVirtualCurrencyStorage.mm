#import "VirtualItemNotFoundException.h"
#import "UnityCommons.h"
#import "UnityStoreCommons.h"

#import "StorageManager.h"
#import "VirtualCurrencyStorage.h"
extern "C"{
    
    int vcStorage_GetBalance(const char* itemId, int* outBalance) {
        NSString* itemIdS = [NSString stringWithUTF8String:itemId];
        @try {
            *outBalance = [[[StorageManager getInstance] virtualCurrencyStorage] balanceForItem:itemIdS];
        }
        @catch (VirtualItemNotFoundException* e) {
            NSLog(@"Couldn't find a VirtualItem with itemId: %@.", itemIdS);
            return EXCEPTION_ITEM_NOT_FOUND;
        }
        
        return NO_ERR;
    }
    
    int vcStorage_SetBalance(const char* itemId, int balance, bool notify, int* outBalance) {
        NSString* itemIdS = [NSString stringWithUTF8String:itemId];
        @try {
            *outBalance = [[[StorageManager getInstance] virtualCurrencyStorage] setBalance:balance toItem:itemIdS withEvent:notify];
        }
        @catch (VirtualItemNotFoundException* e) {
            NSLog(@"Couldn't find a VirtualItem with itemId: %@.", itemIdS);
            return EXCEPTION_ITEM_NOT_FOUND;
        }
        
        return NO_ERR;
    }
    
    int vcStorage_Add(const char* itemId, int amount, bool notify, int* outBalance) {
        NSString* itemIdS = [NSString stringWithUTF8String:itemId];
        @try {
            *outBalance = [[[StorageManager getInstance] virtualCurrencyStorage] addAmount:amount toItem:itemIdS withEvent:notify];
        }
        @catch (VirtualItemNotFoundException* e) {
            NSLog(@"Couldn't find a VirtualItem with itemId: %@.", itemIdS);
            return EXCEPTION_ITEM_NOT_FOUND;
        }
        
        return NO_ERR;
    }
    
    int vcStorage_Remove(const char* itemId, int amount, bool notify, int* outBalance) {
        NSString* itemIdS = [NSString stringWithUTF8String:itemId];
        @try {
            *outBalance = [[[StorageManager getInstance] virtualCurrencyStorage] removeAmount:amount fromItem:itemIdS withEvent:notify];
        }
        @catch (VirtualItemNotFoundException* e) {
            NSLog(@"Couldn't find a VirtualItem with itemId: %@.", itemIdS);
            return EXCEPTION_ITEM_NOT_FOUND;
        }
        
        return NO_ERR;
    }
    
}