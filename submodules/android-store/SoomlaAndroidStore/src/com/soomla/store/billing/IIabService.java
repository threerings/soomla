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

package com.soomla.store.billing;

import java.util.List;

/**
 * This interface defines the functionality that needs to be implemented in order to create an
 * in-app billing service (e.g. Google Play, Amazon App Store, Samsung Apps...)
 */
public interface IIabService {

    /**
     * Checks if in-app billing service is initialized.
     *
     * @return true if Iab is initialized, false otherwise
     */
    public boolean isIabServiceInitialized();

    /**
     * Consumes the given purchase. In order to consume a product, the product must be owned, and
     * upon consumption completion, the user will no longer own the product.
     * This method may block, do not call from UI thread. For that see {@link #consumeAsync}.
     *
     * @param purchase the PurchaseInfo that represents the item to consume.
     * @throws IabException if there is a problem during consumption.
     */
    public void consume(IabPurchase purchase) throws IabException;

    /**
     * Works like {@link #consume}, but is asynchronous. Performs the consumption in the background
     * and notifies the given listener upon completion of consumption.
     * This method is safe to call from a UI thread.
     *
     * @param purchase the purchase to be consumed
     * @param consumeListener the listener to notify when the consumption is finished.
     */
    public void consumeAsync(IabPurchase purchase,
                             final IabCallbacks.OnConsumeListener consumeListener);

    /**
     * Initiates the UI flow for an in-app purchase.
     * Call this method to initiate an in-app purchase which will bring up the Market screen.
     * The calling activity will be paused while the user interacts with the Market.
     * This method MUST be called from the UI thread of the Activity.
     *
     * @param sku the sku of the item to purchase.
     * @param purchaseListener the listener to notify when the purchase process finishes
     * @param extraData extra data (developer payload), which will be returned with the purchase
     *                  data when the purchase completes.
     */
    public void launchPurchaseFlow(String sku,
                                   final IabCallbacks.OnPurchaseListener purchaseListener,
                                   String extraData);

    /**
     * Restores transactions asynchronously. This operation will get all previously purchased
     * non-consumables and invoke the given callback.
     *
     * @param restorePurchasesListener the listener to notify when the query operation completes.
     */
    public void restorePurchasesAsync(IabCallbacks.OnRestorePurchasesListener restorePurchasesListener);

    /**
     * Fetches all details for the given skus. The details is what the developer provided on
     * the developer console.
     *
     * @param fetchSkusDetailsListener the listener to notify when the query operation completes.
     */
    public void fetchSkusDetailsAsync(List<String> skus, IabCallbacks.OnFetchSkusDetailsListener fetchSkusDetailsListener);

    /**
     * Initializes in-app billing service and notifies the given <code>initListener</code> upon
     * completion.
     *
     * @param initListener the listener to notify when the <code>initializeBillingService</code>
     *                     process completes.
     */
    public void initializeBillingService(IabCallbacks.IabInitListener initListener);

    /**
     * Starts in-app billing service in background and notifies the given <code>initListener</code>
     * upon completion.
     *
     * @param initListener the listener to notify when the <code>startIabServiceInBg</code> process
     *                     completes.
     */
    public void startIabServiceInBg(IabCallbacks.IabInitListener initListener);

    /**
     * Stops in-app billing service in background and notifies the given <code>initListener</code>
     * upon completion.
     *
     * @param initListener the listener to notify when the <code>stopIabServiceInBg</code> process
     *                     completes.
     */
    public void stopIabServiceInBg(IabCallbacks.IabInitListener initListener);

}
