package com.soomla.store.events;

import com.soomla.events.SoomlaEvent;

/**
 * This event is fired when there is a request to refresh the receipt data.
 */
public class RefreshTransactionReceiptEvent extends SoomlaEvent
{
    public RefreshTransactionReceiptEvent(String transactionId)
    {
        this(transactionId, null);
    }

    public RefreshTransactionReceiptEvent(String transactionId, Object sender)
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
