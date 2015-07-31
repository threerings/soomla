package com.soomla.store.events;

import com.soomla.events.SoomlaEvent;

/**
 * This event is fired when a market purchase verification has encountered an error.
 */
public class MarketPurchaseVerifyErrorEvent extends SoomlaEvent
{
    public MarketPurchaseVerifyErrorEvent(String transactionId)
    {
        this(transactionId, null);
    }

    public MarketPurchaseVerifyErrorEvent(String transactionId, Object sender)
    {
        super(sender);
        _transactionId = transactionId;
    }

    public String getTransactionId()
    {
        return _transactionId;
    }

    private String _transactionId;
}
