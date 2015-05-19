/*
 * Copyright (C) 2012-2014 Soomla Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.soomla.store.events;

import com.soomla.events.SoomlaEvent;
import com.soomla.store.domain.PurchasableVirtualItem;

/**
 * This event is fired when a Market purchase has occurred.
 */
public class MarketPurchaseEvent extends SoomlaEvent {

    /**
     * Constructor
     *
     * @param purchasableVirtualItem the item that was purchased
     * @param payload the amount paid by the user (with real money!)
     * @param token token associated with in-app billing purchase
     */
    public MarketPurchaseEvent(PurchasableVirtualItem purchasableVirtualItem, String payload,
                               String token, String orderId) {
        this(purchasableVirtualItem, payload, token, orderId, null, null, null, null);
    }

    public MarketPurchaseEvent(PurchasableVirtualItem purchasableVirtualItem, String payload,
                               String token, String orderId, Object sender) {
        this(purchasableVirtualItem, payload, token, orderId, null, null, null, sender);
    }

    public MarketPurchaseEvent(PurchasableVirtualItem purchasableVirtualItem, String payload,
                               String token, String orderId, String originalJson, String signature, String userId, Object sender) {
        super(sender);
        mPurchasableVirtualItem = purchasableVirtualItem;
        mPayload = payload;
        mToken = token;
        mOrderId = orderId;
        mOriginalJson = originalJson;
        mSignature = signature;
        mUserId = userId;
    }


    /** Setters and Getters */

    public PurchasableVirtualItem getPurchasableVirtualItem() {
        return mPurchasableVirtualItem;
    }

    public String getPayload() {
        return mPayload;
    }

    public String getToken() {
        return mToken;
    }

    public String getOrderId() {
        return mOrderId;
    }

    public String getOriginalJson() {
        return mOriginalJson;
    }

    public String getSignature() {
        return mSignature;
    }

    public String getUserId() {
        return mUserId;
    }

    /** Private Members */

    private PurchasableVirtualItem mPurchasableVirtualItem;

    private String mPayload;

    private String mToken;

    private String mOrderId;

    private String mOriginalJson;

    private String mSignature;

    private String mUserId;
}
