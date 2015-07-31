/*
 Copyright (C) 2012-2014 Soomla Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "SoomlaVerification.h"
#import "SoomlaUtils.h"
#import "PurchasableVirtualItem.h"
#import "StoreEventHandling.h"
#import "StoreConfig.h"
#import "FBEncryptorAES.h"

@implementation SoomlaVerification

static NSString* TAG = @"SOOMLA SoomlaVerification";

- (id) initWithTransaction:(SKPaymentTransaction*)t andPurchasable:(PurchasableVirtualItem*)pvi andTransactionId:(int)tid {
    if (self = [super init]) {
        transaction = t;
        purchasable = pvi;
        instanceId = tid;
        // Tell ARC to not dealloc this class instance. until we say so.
        selfRef = CFBridgingRetain(self);
    }
    
    return self;
}

/**
 * Starts the receipt verification process.
 * Sends an event to the Unity client with the receipt data and listens for a response.
 */
- (void)verifyData
{
    LogDebug(TAG, ([NSString stringWithFormat:@"verifying purchase for: %@", transaction.payment.productIdentifier]));
    
    NSData* data = [self getReceipt];
    
    if (data) {
        
        // post event for client to listen to and start listening for client response.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseVerified:) name:EVENT_MARKET_PURCHASE_VERIF_CLIENT object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchaseError:) name:EVENT_MARKET_PURCHASE_VERIF_ERROR object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshReceipt:) name:EVENT_MARKET_PURCHASE_RECEIPT_REFRESH object:nil];
        
        NSString* receiptString = [data base64Encoding];
        [StoreEventHandling postMarketPurchaseVerifyStart:receiptString andTransactionId:transaction.transactionIdentifier];
    } else {
        LogError(TAG, ([NSString stringWithFormat:@"An error occured while trying to get receipt data. Stopping the purchasing process for: %@", transaction.payment.productIdentifier]));
        [StoreEventHandling postUnexpectedError:ERR_VERIFICATION_TIMEOUT forObject:self];
    }
}

/**
 * Executes when Unity sends back a EVENT_MARKET_PURCHASE_RECEIPT_REFRESH event, requesting updated receipt data.
 */
- (void)refreshReceipt:(NSNotification*)notification
{
    LogDebug(TAG, @"Start request for refreshing the receipt");
    SKReceiptRefreshRequest *req = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:nil];
    req.delegate = self;
    [req start];
}

/**
 * Executes when apple finishes getting receipt data, send another verification request to Unity.
 */
- (void)onRefreshReceiptComplete
{
    LogDebug(TAG, ([NSString stringWithFormat:@"re-reading receipt for: %@", transaction.payment.productIdentifier]));
    
    NSData* data = [self getReceipt];
    
    if (data) {
        NSString* receiptString = [data base64Encoding];
        [StoreEventHandling postMarketPurchaseVerifyStart:receiptString andTransactionId:transaction.transactionIdentifier];
    } else {
        LogError(TAG, ([NSString stringWithFormat:@"An error occured while trying to get receipt data. Stopping the purchasing process for: %@", transaction.payment.productIdentifier]));
        [StoreEventHandling postUnexpectedError:ERR_VERIFICATION_TIMEOUT forObject:self];
    }
}

/**
 * Get the receipt data
 */
- (NSData*)getReceipt
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    NSData* data = nil;
    if (version < 7) {
        data = transaction.transactionReceipt;
    } else {
        NSURL* receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[receiptUrl path]]) {
            data = [NSData dataWithContentsOfURL:receiptUrl];
        }
    }
    return data;
}

/**
 * Executes when Unity sends back a EVENT_MARKET_PURCHASE_VERIF_ERROR event
 * meaning something unexpected happened when verifying the receipt. (invalid receipts will still go to the verified code path.)
 */
- (void)purchaseError:(NSNotification*)notification
{
    NSDictionary* userInfo = notification.userInfo;
    NSString* messageId = [userInfo objectForKey:DICT_ELEMENT_TRANSACTION_ID];

    if ([messageId isEqualToString:transaction.transactionIdentifier]) {
        LogError(TAG, ([NSString stringWithFormat:@"Unity sent an error response for transaction id %@", messageId]));
        [StoreEventHandling postUnexpectedError:EVENT_UNEXPECTED_ERROR_IN_STORE forObject:self];
    
        // Deregister for messages and tell ARC that its okay to release ourselves.
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        CFBridgingRelease(selfRef);
    }
}

/**
 * Executes when Unity sends back an event EVENT_MARKET_PURCHASE_VERIF_CLIENT.
 * Responds with a success or failure status and the transaciton id.
 */
- (void)purchaseVerified:(NSNotification*)notification
{
    // got client response, send event back to soomlaStore and deregister self listener.
    NSDictionary* userInfo = notification.userInfo;
    NSString* messageId = [userInfo objectForKey:DICT_ELEMENT_TRANSACTION_ID];

    if ([messageId isEqualToString:transaction.transactionIdentifier]) {
       LogDebug(TAG, ([NSString stringWithFormat:@"Unity sent a response for transaction id %@. verification = %@", messageId, [userInfo objectForKey:DICT_ELEMENT_VERIFIED]]));
        [StoreEventHandling postMarketPurchaseVerification:[userInfo objectForKey:DICT_ELEMENT_VERIFIED] forItem:purchasable andTransaction:transaction forObject:self];
        
        // Deregister for messages and tell ARC that its okay to release ourselves.
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        CFBridgingRelease(selfRef);
    }
}

#pragma mark SKRequestDelegate methods

- (void)requestDidFinish:(SKRequest *)request {
    LogDebug(TAG, @"The refresh request for a receipt completed.");
    [self onRefreshReceiptComplete];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    LogDebug(TAG, ([NSString stringWithFormat:@"Error trying to request receipt: %@", error]));
    [StoreEventHandling postUnexpectedError:ERR_VERIFICATION_FAIL forObject:self];
}

@end
