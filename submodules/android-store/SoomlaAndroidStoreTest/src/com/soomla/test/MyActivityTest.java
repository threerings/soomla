package com.soomla.test;

import android.content.Context;
import android.content.SharedPreferences;
import com.soomla.store.*;
import com.soomla.store.data.ObscuredSharedPreferences;
import com.soomla.store.data.StoreInfo;
import com.xtremelabs.robolectric.Robolectric;
import com.xtremelabs.robolectric.RobolectricTestRunner;
import com.xtremelabs.robolectric.shadows.ShadowLog;
import org.junit.Test;
import org.junit.runner.RunWith;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.junit.Assert.assertThat;

@RunWith(RobolectricTestRunner.class)
public class MyActivityTest {

    @Test
    public void shouldHaveHappySmiles() throws Exception {
        System.setProperty("robolectric.logging", "stdout");

        ShadowLog.stream = System.out;
        Robolectric.bindShadowClass(ShadowLog.class);

        String appName = new MyActivity().getResources().getString(R.string.app_name);
        assertThat(appName,  equalTo("SoomlaAndroidStoreTest"));

        SoomlaApp.setExternalContext(Robolectric.getShadowApplication().getApplicationContext());

        IStoreAssets storeAssets = new MuffinRushAssets();
        StoreController.getInstance().initialize(storeAssets, "abcd", "SOOMLA_RULES");
        StoreController.getInstance().setTestMode(true);
        SharedPreferences prefs = new ObscuredSharedPreferences(SoomlaApp.getAppContext().getSharedPreferences(StoreConfig.PREFS_NAME, Context.MODE_PRIVATE));
        assertThat(prefs.getString(StoreConfig.CUSTOM_SEC, ""), equalTo("SOOMLA_RULES"));
        assertThat(prefs.getString(StoreConfig.PUBLIC_KEY, ""), equalTo("abcd"));
        assertThat(prefs.getInt("SA_VER_NEW", -1), equalTo(storeAssets.getVersion()));

        assertThat(StoreInfo.getCategories().size(), equalTo(6));
        assertThat(StoreInfo.getCurrencies().size(), equalTo(1));
        assertThat(StoreInfo.getGoods().size(), equalTo(25));
        assertThat(StoreInfo.getCurrencyPacks().size(), equalTo(4));

        StoreInventory.giveVirtualItem(MuffinRushAssets.MUFFIN_CURRENCY_ITEM_ID, 10000);
        assertThat(StoreInventory.getVirtualItemBalance(MuffinRushAssets.MUFFIN_CURRENCY_ITEM_ID), equalTo(10000));

        StoreInventory.buy(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId());
        assertThat(StoreInventory.getVirtualItemBalance(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId()), equalTo(1));
        assertThat(StoreInventory.getVirtualItemBalance(MuffinRushAssets.MUFFIN_CURRENCY_ITEM_ID), equalTo(9775));

        StoreInventory.buy(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId());
        assertThat(StoreInventory.getVirtualItemBalance(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId()), equalTo(2));
        assertThat(StoreInventory.getVirtualItemBalance(MuffinRushAssets.MUFFIN_CURRENCY_ITEM_ID), equalTo(9550));

        StoreInventory.upgradeVirtualGood(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId());
        assertThat(StoreInventory.getGoodCurrentUpgrade(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId()), equalTo(MuffinRushAssets.MC_UPGRADE1.getItemId()));
        StoreInventory.upgradeVirtualGood(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId());
        assertThat(StoreInventory.getGoodCurrentUpgrade(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId()), equalTo(MuffinRushAssets.MC_UPGRADE2.getItemId()));
        StoreInventory.upgradeVirtualGood(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId());
        assertThat(StoreInventory.getGoodCurrentUpgrade(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId()), equalTo(MuffinRushAssets.MC_UPGRADE3.getItemId()));
        StoreInventory.upgradeVirtualGood(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId());
        assertThat(StoreInventory.getGoodCurrentUpgrade(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId()), equalTo(MuffinRushAssets.MC_UPGRADE4.getItemId()));
        StoreInventory.upgradeVirtualGood(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId());
        assertThat(StoreInventory.getGoodCurrentUpgrade(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId()), equalTo(MuffinRushAssets.MC_UPGRADE5.getItemId()));
        StoreInventory.upgradeVirtualGood(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId());
        assertThat(StoreInventory.getGoodCurrentUpgrade(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId()), equalTo(MuffinRushAssets.MC_UPGRADE6.getItemId()));
        StoreInventory.upgradeVirtualGood(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId());
        assertThat(StoreInventory.getGoodCurrentUpgrade(MuffinRushAssets.MUFFINCAKE_GOOD.getItemId()), equalTo(MuffinRushAssets.MC_UPGRADE6.getItemId()));
    }
}