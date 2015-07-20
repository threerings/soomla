
#import "UnityStoreEventDispatcher.h"
#import "StoreEventHandling.h"
#import "MarketItem.h"
#import "VirtualGood.h"
#import "VirtualCurrency.h"
#import "EquippableVG.h"
#import "UpgradeVG.h"
#import "PurchasableVirtualItem.h"
#import "SoomlaUtils.h"

static UnityStoreEventDispatcher* instance = nil;

extern "C"{
    void eventDispatcher_Init(const char* recieverName) {
        LogDebug(@"SOOMLA Unity UnityStoreEventDispatcher", @"Initializing StoreEventHandler ...");
        [UnityStoreEventDispatcher initialize:[NSString stringWithUTF8String:recieverName]];
    }
    
    void eventDispatcher_PushEventSoomlaStoreInitialized(const char* message) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_SOOMLASTORE_INIT object:instance userInfo:nil];
    }
    
    void eventDispatcher_PushEventUnexpectedStoreError(const char* errMessage) {
        // TODO: we're ignoring errMessage here. change it?

        NSDictionary *userInfo = @{ DICT_ELEMENT_ERROR_CODE: [NSNumber numberWithInt:ERR_GENERAL] };
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_UNEXPECTED_ERROR_IN_STORE object:instance userInfo:userInfo];
    }
    
    void eventDispatcher_PushEventCurrencyBalanceChanged(const char* message) {
        
        NSString* messageS = [NSString stringWithUTF8String:message];
        NSDictionary* eventJSON = [SoomlaUtils jsonStringToDict:messageS];
        NSDictionary *userInfo = @{ DICT_ELEMENT_BALANCE: [eventJSON objectForKey:@"balance"],
                                    DICT_ELEMENT_CURRENCY: [eventJSON objectForKey:@"itemId"],
                                    DICT_ELEMENT_AMOUNT_ADDED: [eventJSON objectForKey:@"amountAdded"]};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_CURRENCY_BALANCE_CHANGED object:instance userInfo:userInfo];
    }
    
    void eventDispatcher_PushEventGoodBalanceChanged(const char* message) {
        NSString* messageS = [NSString stringWithUTF8String:message];
        NSDictionary* eventJSON = [SoomlaUtils jsonStringToDict:messageS];
        NSDictionary *userInfo = @{ DICT_ELEMENT_BALANCE: [eventJSON objectForKey:@"balance"],
                                    DICT_ELEMENT_GOOD: [eventJSON objectForKey:@"itemId"],
                                    DICT_ELEMENT_AMOUNT_ADDED: [eventJSON objectForKey:@"amountAdded"]};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GOOD_BALANCE_CHANGED object:instance userInfo:userInfo];
    }
    
    void eventDispatcher_PushEventGoodEquipped(const char* message) {
        NSString* messageS = [NSString stringWithUTF8String:message];
        NSDictionary* eventJSON = [SoomlaUtils jsonStringToDict:messageS];
        NSDictionary *userInfo = @{ DICT_ELEMENT_EquippableVG: [eventJSON objectForKey:@"itemId"] };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GOOD_EQUIPPED object:instance userInfo:userInfo];
    }
    
    void eventDispatcher_PushEventGoodUnEquipped(const char* message) {
        NSString* messageS = [NSString stringWithUTF8String:message];
        NSDictionary* eventJSON = [SoomlaUtils jsonStringToDict:messageS];
        NSDictionary *userInfo = @{ DICT_ELEMENT_EquippableVG: [eventJSON objectForKey:@"itemId"] };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GOOD_UNEQUIPPED object:instance userInfo:userInfo];
    }
    
    void eventDispatcher_PushEventGoodUpgrade(const char* message) {
        NSString* messageS = [NSString stringWithUTF8String:message];
        NSDictionary* eventJSON = [SoomlaUtils jsonStringToDict:messageS];
        NSDictionary *userInfo = @{ DICT_ELEMENT_GOOD: [eventJSON objectForKey:@"itemId"], DICT_ELEMENT_UpgradeVG: [eventJSON objectForKey:@"upgradeItemId"] };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_GOOD_UPGRADE object:instance userInfo:userInfo];
    }
    
    void eventDispatcher_PushEventItemPurchased(const char* message) {
        NSString* messageS = [NSString stringWithUTF8String:message];
        NSDictionary* eventJSON = [SoomlaUtils jsonStringToDict:messageS];
        NSDictionary *userInfo = @{ DICT_ELEMENT_PURCHASABLE_ID: [eventJSON objectForKey:@"itemId"], DICT_ELEMENT_DEVELOPERPAYLOAD: [eventJSON objectForKey:@"payload"] };

        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_ITEM_PURCHASED object:instance userInfo:userInfo];
    }
    
    void eventDispatcher_PushEventItemPurchaseStarted(const char* message) {
        NSString* messageS = [NSString stringWithUTF8String:message];
        NSDictionary* eventJSON = [SoomlaUtils jsonStringToDict:messageS];
        NSDictionary *userInfo = @{ DICT_ELEMENT_PURCHASABLE_ID: [eventJSON objectForKey:@"itemId"] };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_ITEM_PURCHASE_STARTED object:instance userInfo:userInfo];
    }
    
    void eventDispatcher_SetMarketPurchaseVerified(int transactionId, bool success) {
        NSDictionary *userInfo = @{
                                   DICT_ELEMENT_VERIFIED: [NSNumber numberWithBool:success],
                                   DICT_ELEMENT_TRANSACTION_ID: [NSNumber numberWithInt:transactionId]};
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MARKET_PURCHASE_VERIF_CLIENT object:instance userInfo:userInfo];
    }
    
    void eventDispatcher_SetMarketPurchaseVerifyError(int transactionId) {
        NSDictionary *userInfo = @{DICT_ELEMENT_TRANSACTION_ID: [NSNumber numberWithInt:transactionId]};
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MARKET_PURCHASE_VERIF_ERROR object:instance userInfo:userInfo];
    }
    
    void eventDispatcher_RefreshTransactionReceipt(int transactionId) {
        NSDictionary *userInfo = @{DICT_ELEMENT_TRANSACTION_ID: [NSNumber numberWithInt:transactionId]};
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MARKET_PURCHASE_RECEIPT_REFRESH object:instance userInfo:userInfo];
    }
}

@implementation UnityStoreEventDispatcher

+ (void)initialize:(NSString*)recieverName {
    if (!instance) {
        instance = [[UnityStoreEventDispatcher alloc] init:recieverName];
    }
}

- (id) init:(NSString*)reciever {
    if (self = [super init]) {
        [StoreEventHandling observeAllEventsWithObserver:self withSelector:@selector(handleEvent:)];
    }
    self.recieverName = reciever;
    return self;
}

- (void)handleEvent:(NSNotification*)notification {
    if (notification.object == self) {
        return;
    }

    const char* reciever = [_recieverName UTF8String];

	if ([notification.name isEqualToString:EVENT_BILLING_NOT_SUPPORTED]) {
	        UnitySendMessage(reciever, "onBillingNotSupported", "");
	}
	else if ([notification.name isEqualToString:EVENT_BILLING_SUPPORTED]) {
	    UnitySendMessage(reciever, "onBillingSupported", "");
	}
	else if ([notification.name isEqualToString:EVENT_CURRENCY_BALANCE_CHANGED]) {
	    NSDictionary* userInfo = [notification userInfo];
        NSString* jsonStr = [SoomlaUtils dictToJsonString:@{
                                        @"itemId": [userInfo objectForKey:DICT_ELEMENT_CURRENCY],
                                        @"balance": (NSNumber*)[userInfo objectForKey:DICT_ELEMENT_BALANCE],
                                        @"amountAdded": (NSNumber*)[userInfo objectForKey:DICT_ELEMENT_AMOUNT_ADDED]
                                        }];
	    UnitySendMessage(reciever, "onCurrencyBalanceChanged", [jsonStr UTF8String]);
	}
	else if ([notification.name isEqualToString:EVENT_GOOD_BALANCE_CHANGED]) {
        NSDictionary* userInfo = [notification userInfo];
        NSString* jsonStr = [SoomlaUtils dictToJsonString:@{
                                                            @"itemId": [userInfo objectForKey:DICT_ELEMENT_GOOD],
                                                            @"balance": (NSNumber*)[userInfo objectForKey:DICT_ELEMENT_BALANCE],
                                                            @"amountAdded": (NSNumber*)[userInfo objectForKey:DICT_ELEMENT_AMOUNT_ADDED]
                                                            }];
        UnitySendMessage(reciever, "onGoodBalanceChanged", [jsonStr UTF8String]);
    }
	else if ([notification.name isEqualToString:EVENT_GOOD_EQUIPPED]) {
        NSDictionary* userInfo = [notification userInfo];
        NSString* jsonStr = [SoomlaUtils dictToJsonString:@{
                                                            @"itemId": [userInfo objectForKey:DICT_ELEMENT_EquippableVG]
                                                            }];
        UnitySendMessage(reciever, "onGoodEquipped", [jsonStr UTF8String]);
    }
	else if ([notification.name isEqualToString:EVENT_GOOD_UNEQUIPPED]) {
        NSDictionary* userInfo = [notification userInfo];
        NSString* jsonStr = [SoomlaUtils dictToJsonString:@{
                                                            @"itemId": [userInfo objectForKey:DICT_ELEMENT_EquippableVG]
                                                            }];
        UnitySendMessage(reciever, "onGoodUnequipped", [jsonStr UTF8String]);
    }
	else if ([notification.name isEqualToString:EVENT_GOOD_UPGRADE]) {
        NSDictionary* userInfo = [notification userInfo];
        NSString* jsonStr = [SoomlaUtils dictToJsonString:@{
                                                            @"itemId": [userInfo objectForKey:DICT_ELEMENT_GOOD],
                                                            @"upgradeItemId": [userInfo objectForKey:DICT_ELEMENT_UpgradeVG]
                                                            }];
        UnitySendMessage(reciever, "onGoodUpgrade", [jsonStr UTF8String]);
    }
	else if ([notification.name isEqualToString:EVENT_ITEM_PURCHASED]) {
        NSDictionary* userInfo = [notification userInfo];
        NSString* jsonStr = [SoomlaUtils dictToJsonString:@{
                                                            @"itemId": [userInfo objectForKey:DICT_ELEMENT_PURCHASABLE_ID],
                                                            @"payload": [userInfo objectForKey:DICT_ELEMENT_DEVELOPERPAYLOAD]
                                                            }];
        UnitySendMessage(reciever, "onItemPurchased", [jsonStr UTF8String]);
    }
	else if ([notification.name isEqualToString:EVENT_ITEM_PURCHASE_STARTED]) {
        NSDictionary* userInfo = [notification userInfo];
        NSString* jsonStr = [SoomlaUtils dictToJsonString:@{
                                                            @"itemId": [userInfo objectForKey:DICT_ELEMENT_PURCHASABLE_ID]
                                                            }];
        UnitySendMessage(reciever, "onItemPurchaseStarted", [jsonStr UTF8String]);
    }
	else if ([notification.name isEqualToString:EVENT_MARKET_PURCHASE_CANCELLED]) {
        NSDictionary* userInfo = [notification userInfo];
        PurchasableVirtualItem* pvi = (PurchasableVirtualItem*)[userInfo objectForKey:DICT_ELEMENT_PURCHASABLE];
        NSString* jsonStr = [SoomlaUtils dictToJsonString:@{
                                                            @"itemId": pvi.itemId
                                                            }];
        UnitySendMessage(reciever, "onMarketPurchaseCancelled", [jsonStr UTF8String]);
    }
	else if ([notification.name isEqualToString:EVENT_MARKET_PURCHASED]) {
        NSDictionary* userInfo = [notification userInfo];
        PurchasableVirtualItem* pvi = (PurchasableVirtualItem*)[userInfo objectForKey:DICT_ELEMENT_PURCHASABLE];
        NSString* jsonStr = [SoomlaUtils dictToJsonString:@{
                                                            @"itemId": pvi.itemId,
                                                            @"payload": [userInfo objectForKey:DICT_ELEMENT_DEVELOPERPAYLOAD],
                                                            @"extra": @{ @"receipt": [userInfo objectForKey:DICT_ELEMENT_RECEIPT], @"token": [userInfo objectForKey:DICT_ELEMENT_TOKEN]}
                                                            }];
        UnitySendMessage(reciever, "onMarketPurchase", [jsonStr UTF8String]);
    }
    else if ([notification.name isEqualToString:EVENT_MARKET_PURCHASE_STARTED]) {
        NSDictionary* userInfo = [notification userInfo];
        PurchasableVirtualItem* pvi = (PurchasableVirtualItem*)[userInfo objectForKey:DICT_ELEMENT_PURCHASABLE];
        NSString* jsonStr = [SoomlaUtils dictToJsonString:@{
                                                            @"itemId": pvi.itemId
                                                            }];
        UnitySendMessage(reciever, "onMarketPurchaseStarted", [jsonStr UTF8String]);
	}
    else if ([notification.name isEqualToString:EVENT_MARKET_PURCHASE_VERIFY_START]) {
        NSDictionary* userInfo = [notification userInfo];
        NSString* jsonStr = [SoomlaUtils dictToJsonString:@{
                                                            @"transactionId": [userInfo objectForKey:DICT_ELEMENT_TRANSACTION_ID],
                                                            @"receipt": [userInfo objectForKey:DICT_ELEMENT_RECEIPT],
                                                            }];
        UnitySendMessage(reciever, "onMarketPurchaseVerifyStarted", [jsonStr UTF8String]);
    }
    else if ([notification.name isEqualToString:EVENT_RESTORE_TRANSACTIONS_FINISHED]) {
        NSDictionary* userInfo = [notification userInfo];
        NSString* jsonStr = [SoomlaUtils dictToJsonString:@{
                                                            @"success": [userInfo objectForKey:DICT_ELEMENT_SUCCESS]
                                                            }];
        UnitySendMessage(reciever, "onRestoreTransactionsFinished", [jsonStr UTF8String]);
    }
    else if ([notification.name isEqualToString:EVENT_RESTORE_TRANSACTIONS_STARTED]) {
        UnitySendMessage(reciever, "onRestoreTransactionsStarted", "");
    }
    else if ([notification.name isEqualToString:EVENT_MARKET_ITEMS_REFRESH_STARTED]) {
        UnitySendMessage(reciever, "onMarketItemsRefreshStarted", "");
    }
    else if ([notification.name isEqualToString:EVENT_MARKET_ITEMS_REFRESH_FINISHED]) {
        NSArray* marketItems = [notification.userInfo objectForKey:DICT_ELEMENT_MARKET_ITEMS];
        NSMutableArray* eventJSON = [NSMutableArray array];
        for(MarketItem* mi in marketItems) {
            NSDictionary* micJSON = @{
                                      @"productId": mi.productId,
                                      @"marketPrice": (mi.marketPriceAndCurrency ?: @""),
                                      @"marketTitle": (mi.marketTitle ?: @""),
                                      @"marketDesc": (mi.marketDescription ?: @""),
                                      @"marketCurrencyCode": (mi.marketCurrencyCode ?: @""),
                                      @"marketPriceMicros": @(mi.marketPriceMicros)
                                      };
            [eventJSON addObject:micJSON];
        }
        NSString* jsonStr = [SoomlaUtils arrayToJsonString:eventJSON];
        UnitySendMessage(reciever, "onMarketItemsRefreshFinished", [jsonStr UTF8String]);
    }
    else if ([notification.name isEqualToString:EVENT_MARKET_ITEMS_REFRESH_FAILED]) {
        NSDictionary* userInfo = [notification userInfo];
        NSString* jsonStr = [SoomlaUtils dictToJsonString:@{
                                                            @"errorMessage": ([userInfo objectForKey:DICT_ELEMENT_ERROR_MESSAGE] ?: @"")
                                                            }];
        UnitySendMessage(reciever, "onMarketItemsRefreshFailed", [jsonStr UTF8String]);
    }
    else if ([notification.name isEqualToString:EVENT_UNEXPECTED_ERROR_IN_STORE]) {
        NSDictionary* userInfo = [notification userInfo];
        NSString* jsonStr = [SoomlaUtils dictToJsonString:@{
                                                            @"errorMessage": ([userInfo objectForKey:DICT_ELEMENT_ERROR_CODE] ?: @"")
                                                            }];
        UnitySendMessage(reciever, "onUnexpectedErrorInStore", [jsonStr UTF8String]);
    }
    else if ([notification.name isEqualToString:EVENT_SOOMLASTORE_INIT]) {
        UnitySendMessage(reciever, "onSoomlaStoreInitialized", "");
    }
}

@end
