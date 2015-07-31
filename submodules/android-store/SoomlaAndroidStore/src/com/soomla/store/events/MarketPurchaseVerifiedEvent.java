package com.soomla.store.events;

import com.soomla.events.SoomlaEvent;

/**
 * This event is fired when a market purchase has been verified.
 */
public class MarketPurchaseVerifiedEvent extends SoomlaEvent
{
    public MarketPurchaseVerifiedEvent(String transactionId, boolean success)
    {
        this(transactionId, success, null);
    }

    public MarketPurchaseVerifiedEvent(String transactionId, boolean success, Object sender)
    {
        super(sender);
        _transactionId = transactionId;
        _success = success;
    }

    public String getTransactionId()
    {
        return _transactionId;
    }

    public boolean getSuccess()
    {
        return _success;
    }

    private boolean _success;

    private String _transactionId;
}
