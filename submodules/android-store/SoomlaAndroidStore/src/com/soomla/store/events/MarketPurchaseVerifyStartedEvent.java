package com.soomla.store.events;

import com.soomla.events.SoomlaEvent;
import com.soomla.store.domain.PurchasableVirtualItem;

/**
 * This event is fired when a Market purchase is ready to be verified.
 */
public class MarketPurchaseVerifyStartedEvent extends SoomlaEvent
{
    public MarketPurchaseVerifyStartedEvent(String transactionId, String receipt, String signature) {
        this(transactionId, receipt, signature, null);
    }

    public MarketPurchaseVerifyStartedEvent(String transactionId, String receipt, String signature, Object sender) {
        super(sender);
        _transactionId = transactionId;
        _receipt = receipt;
        _signature = signature;
    }

    public String getTransactionId()
    {
        return _transactionId;
    }

    public String getReceipt()
    {
        return _receipt;
    }

    public String getSignature()
    {
        return _signature;
    }

    private String _transactionId;
    private String _receipt;
    private String _signature;
}
