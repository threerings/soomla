/*
 * Copyright (C) 2012 Soomla Inc.
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

package com.soomla.test;

import com.soomla.store.IStoreAssets;
import com.soomla.store.domain.*;
import com.soomla.store.domain.virtualCurrencies.*;
import com.soomla.store.domain.virtualGoods.*;
import com.soomla.store.purchaseTypes.*;

import java.util.ArrayList;
import java.util.Arrays;

public class MuffinRushAssets implements IStoreAssets{

    @Override
    public int getVersion ()
    {
        return 0;
    }

    @Override
    public VirtualCurrency[] getCurrencies ()
    {
        return new VirtualCurrency[] { MUFFIN_CURRENCY };
    }

    @Override
    public VirtualGood[] getGoods ()
    {
        return new VirtualGood[] {
                CHOCLATECAKE_GOOD, CREAMCUP_GOOD, MUFFINCAKE_GOOD, PAVLOVA_GOOD,
                JERRY_GOOD, GEORGE_GOOD, KRAMER_GOOD, ELAINE_GOOD,
                MC_UPGRADE1, MC_UPGRADE2, MC_UPGRADE3, MC_UPGRADE4, MC_UPGRADE5, MC_UPGRADE6,
                PAV_UPGRADE1, PAV_UPGRADE2, PAV_UPGRADE3, PAV_UPGRADE4, PAV_UPGRADE5, PAV_UPGRADE6,
                MARRIAGE_GOOD,
                TWENTY_CAKES_PACK, FIFTY_CAKES_PACK, HUNDRED_CAKES_PACK, TWOHUNDRED_CAKES_PACK
        };
    }

    @Override
    public VirtualCurrencyPack[] getCurrencyPacks ()
    {
        return new VirtualCurrencyPack[] { TENMUFF_PACK, FIFTYMUFF_PACK, FOURHUNDMUFF_PACK, THOUSANDMUFF_PACK };
    }

    @Override
    public VirtualCategory[] getCategories ()
    {
        return new VirtualCategory[] {
                MUFFINS, MC_UPGRADES, PAV_UPGRADES, CHARACTERS, LIFETIME_THINGS, GOOD_PACKS
        };
    }

    @Override
    public NonConsumableItem[] getNonConsumableItems ()
    {
        return new NonConsumableItem[] {
                NO_ADS_NONCONS
        };
    }

    /** Static Final members **/
    public static final String MUFFIN_CURRENCY_ITEM_ID      = "currency_muffin";
    public static final String TENMUFF_PACK_PRODUCT_ID      = "android.test.refunded";
    public static final String FIFTYMUFF_PACK_PRODUCT_ID    = "android.test.canceled";
    public static final String FOURHUNDMUFF_PACK_PRODUCT_ID = "android.test.purchased";
    public static final String THOUSANDMUFF_PACK_PRODUCT_ID = "android.test.item_unavailable";
    public static final String NO_ADDS_NONCONS_PRODUCT_ID   = "my.game.no_ads";

    public static final String MUFFINCAKE_GOOD_ITEM_ID = "muffin_cake";
    public static final String PAVLOVA_GOOD_ITEM_ID = "pavlova";
    public static final String CHOCLATECAKE_GOOD_ITEM_ID = "chocolate_cake";
    public static final String CREAMCUP_GOOD_ITEM_ID = "muffin_cake";

    public static final String MUFFINCAKE_ITEM_ID   = "fruit_cake";
    public static final String PAVLOVA_ITEM_ID   = "pavlova";
    public static final String CHOCLATECAKE_ITEM_ID   = "chocolate_cake";
    public static final String CREAMCUP_ITEM_ID   = "cream_cup";

    /** Virtual Currencies **/
    public static final VirtualCurrency MUFFIN_CURRENCY = new VirtualCurrency(
            "Muffins",
            "",
            MUFFIN_CURRENCY_ITEM_ID
    );

    /** Virtual Currency Packs **/

    public static final VirtualCurrencyPack TENMUFF_PACK = new VirtualCurrencyPack(
            "10 Muffins",                                   // name
            "Test refund of an item",                       // description
            "muffins_10",                                   // item id
            10,                                             // number of currencies in the pack
            MUFFIN_CURRENCY_ITEM_ID,                                // the currency associated with this pack
            new PurchaseWithMarket(TENMUFF_PACK_PRODUCT_ID, 0.99));

    public static final VirtualCurrencyPack FIFTYMUFF_PACK = new VirtualCurrencyPack(
            "50 Muffins",                                   // name
            "Test cancellation of an item",                 // description
            "muffins_50",                                   // item id
            50,                                             // number of currencies in the pack
            MUFFIN_CURRENCY_ITEM_ID,                        // the currency associated with this pack
            new PurchaseWithMarket(FIFTYMUFF_PACK_PRODUCT_ID, 1.99));

    public static final VirtualCurrencyPack FOURHUNDMUFF_PACK = new VirtualCurrencyPack(
            "400 Muffins",                                  // name
            "Test purchase of an item",                     // description
            "muffins_400",                                  // item id
            400,                                            // number of currencies in the pack
            MUFFIN_CURRENCY_ITEM_ID,                        // the currency associated with this pack
            new PurchaseWithMarket(FOURHUNDMUFF_PACK_PRODUCT_ID, 4.99));

    public static final VirtualCurrencyPack THOUSANDMUFF_PACK = new VirtualCurrencyPack(
            "1000 Muffins",                                 // name
            "Test item unavailable",                        // description
            "muffins_1000",                                 // item id
            1000,                                           // number of currencies in the pack
            MUFFIN_CURRENCY_ITEM_ID,                        // the currency associated with this pack
            new PurchaseWithMarket(THOUSANDMUFF_PACK_PRODUCT_ID, 8.99));

    /** Virtual Goods **/

    // SingleUseVGs

    public static final VirtualGood MUFFINCAKE_GOOD = new SingleUseVG(
            "Muffin Cake",                                       // name
            "Customers buy a double portion on each purchase of this cake", // description
            "muffin_cake",                                       // item id
            new PurchaseWithVirtualItem(MUFFIN_CURRENCY_ITEM_ID, 225)); // the way this virtual good is purchased

    public static final VirtualGood PAVLOVA_GOOD = new SingleUseVG(
            "Pavlova",                                          // name
            "Gives customers a sugar rush and they call their friends",    // description
            "pavlova",                                          // item id
            new PurchaseWithVirtualItem(MUFFIN_CURRENCY_ITEM_ID, 175)); // the way this virtual good is purchased

    public static final VirtualGood CHOCLATECAKE_GOOD = new SingleUseVG(
            "Chocolate Cake",                                   // name
            "A classic cake to maximize customer satisfaction", // description
            "chocolate_cake",                                   // item id
            new PurchaseWithVirtualItem(MUFFIN_CURRENCY_ITEM_ID, 250)); // the way this virtual good is purchased


    public static final VirtualGood CREAMCUP_GOOD = new SingleUseVG(
            "Cream Cup",                                        // name
            "Increase bakery reputation with this original pastry",   // description
            "cream_cup",                                        // item id
            new PurchaseWithVirtualItem(MUFFIN_CURRENCY_ITEM_ID, 50));  // the way this virtual good is purchased


    // UpgradeVGs

    public static VirtualGood MC_UPGRADE1 = new UpgradeVG (MUFFINCAKE_GOOD_ITEM_ID, "", "mc2", "Level 1", "Muffin Cake Level 1", "mc1", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 50));
    public static VirtualGood MC_UPGRADE2 = new UpgradeVG (MUFFINCAKE_GOOD_ITEM_ID, "mc1", "mc3", "Level 2", "Muffin Cake Level 2", "mc2", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 250));
    public static VirtualGood MC_UPGRADE3 = new UpgradeVG (MUFFINCAKE_GOOD_ITEM_ID, "mc2", "mc4", "Level 3", "Muffin Cake Level 3", "mc3", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 500));
    public static VirtualGood MC_UPGRADE4 = new UpgradeVG (MUFFINCAKE_GOOD_ITEM_ID, "mc3", "mc5", "Level 4", "Muffin Cake Level 4", "mc4", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 1000));
    public static VirtualGood MC_UPGRADE5 = new UpgradeVG (MUFFINCAKE_GOOD_ITEM_ID, "mc4", "mc6", "Level 5", "Muffin Cake Level 5", "mc5", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 1250));
    public static VirtualGood MC_UPGRADE6 = new UpgradeVG (MUFFINCAKE_GOOD_ITEM_ID, "mc5", "", "Level 6", "Muffin Cake Level 6", "mc6", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 1500));

    public static VirtualGood PAV_UPGRADE1 = new UpgradeVG (PAVLOVA_ITEM_ID, "", "pav2", "Level 1", "Pavlova Level 1", "pav1", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 150));
    public static VirtualGood PAV_UPGRADE2 = new UpgradeVG (PAVLOVA_ITEM_ID, "pav1", "pav3", "Level 2", "Pavlova Level 2", "pav2", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 350));
    public static VirtualGood PAV_UPGRADE3 = new UpgradeVG (PAVLOVA_ITEM_ID, "pav2", "pav4", "Level 3", "Pavlova Level 3", "pav3", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 700));
    public static VirtualGood PAV_UPGRADE4 = new UpgradeVG (PAVLOVA_ITEM_ID, "pav3", "pav5", "Level 4", "Pavlova Level 4", "pav4", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 1200));
    public static VirtualGood PAV_UPGRADE5 = new UpgradeVG (PAVLOVA_ITEM_ID, "pav4", "pav6", "Level 5", "Pavlova Level 5", "pav5", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 1850));
    public static VirtualGood PAV_UPGRADE6 = new UpgradeVG (PAVLOVA_ITEM_ID, "pav5", "", "Level 6", "Pavlova Level 6", "pav6", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 2500));


    // EquippableVGs

    public static VirtualGood JERRY_GOOD = new EquippableVG (EquippableVG.EquippingModel.CATEGORY, "Jerry", "Your friend Jerry", "jerry_character", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 250));
    public static VirtualGood GEORGE_GOOD = new EquippableVG (EquippableVG.EquippingModel.CATEGORY, "George", "The best muffin eater in the north", "george_character", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 350));
    public static VirtualGood KRAMER_GOOD = new EquippableVG (EquippableVG.EquippingModel.CATEGORY, "Kramer", "Knows how to get muffins", "kramer_character", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 450));
    public static VirtualGood ELAINE_GOOD = new EquippableVG (EquippableVG.EquippingModel.CATEGORY, "Elaine", "Kicks muffins like superman", "elaine_character", new PurchaseWithVirtualItem (MUFFIN_CURRENCY_ITEM_ID, 1000));


    // LifetimeVGs

    public static VirtualGood MARRIAGE_GOOD = new LifetimeVG("Marriage", "This is a LIFETIME thing.", "marriage_lt", new PurchaseWithMarket("marriage_lifetime", 9.99));


    // SingleUsePackVG

    public static VirtualGood TWENTY_CAKES_PACK = new SingleUsePackVG(CHOCLATECAKE_GOOD_ITEM_ID, 20, "20 chocolate cakes", "A pack of 20 chocolate cakes", "sup_20_cc", new PurchaseWithVirtualItem(MUFFIN_CURRENCY_ITEM_ID, 34));
    public static VirtualGood FIFTY_CAKES_PACK = new SingleUsePackVG(CHOCLATECAKE_GOOD_ITEM_ID, 50, "50 chocolate cakes", "A pack of 50 chocolate cakes", "sup_50_cc", new PurchaseWithVirtualItem(MUFFIN_CURRENCY_ITEM_ID, 340));
    public static VirtualGood HUNDRED_CAKES_PACK = new SingleUsePackVG(CHOCLATECAKE_GOOD_ITEM_ID, 100, "100 chocolate cakes", "A pack of 100 chocolate cakes", "sup_100_cc", new PurchaseWithVirtualItem(MUFFIN_CURRENCY_ITEM_ID, 3410));
    public static VirtualGood TWOHUNDRED_CAKES_PACK = new SingleUsePackVG(CHOCLATECAKE_GOOD_ITEM_ID, 200, "200 chocolate cakes", "A pack of 200 chocolate cakes", "sup_200_cc", new PurchaseWithVirtualItem(MUFFIN_CURRENCY_ITEM_ID, 4000));


    // Non Consumables

    public static NonConsumableItem NO_ADS_NONCONS = new NonConsumableItem("No Ads", "No more ads", "no_ads", new PurchaseWithMarket(new GoogleMarketItem(NO_ADDS_NONCONS_PRODUCT_ID, GoogleMarketItem.Managed.MANAGED, 1.99)));


    /** Virtual Categories **/

    public static VirtualCategory MUFFINS = new VirtualCategory ("Muffins", new ArrayList<String>(
        Arrays.asList(MUFFINCAKE_GOOD_ITEM_ID, CHOCLATECAKE_GOOD_ITEM_ID, PAVLOVA_GOOD_ITEM_ID, CREAMCUP_GOOD_ITEM_ID)
    ));

    public static VirtualCategory MC_UPGRADES = new VirtualCategory ("Muffin Cake Upgrades", new ArrayList<String>(
        Arrays.asList(MC_UPGRADE1.getItemId(), MC_UPGRADE2.getItemId(), MC_UPGRADE3.getItemId(), MC_UPGRADE4.getItemId(), MC_UPGRADE5.getItemId(), MC_UPGRADE6.getItemId())
    ));

    public static VirtualCategory PAV_UPGRADES = new VirtualCategory ("Pavlova Upgrades", new ArrayList<String>(
            Arrays.asList(PAV_UPGRADE1.getItemId(), PAV_UPGRADE2.getItemId(), PAV_UPGRADE3.getItemId(), PAV_UPGRADE4.getItemId(), PAV_UPGRADE5.getItemId(), PAV_UPGRADE6.getItemId())
    ));

    public static VirtualCategory CHARACTERS = new VirtualCategory ("Characters", new ArrayList<String>(
            Arrays.asList(JERRY_GOOD.getItemId(), GEORGE_GOOD.getItemId(), KRAMER_GOOD.getItemId(), ELAINE_GOOD.getItemId())
    ));

    public static VirtualCategory LIFETIME_THINGS = new VirtualCategory ("Lifetime things", new ArrayList<String>(
            Arrays.asList(MARRIAGE_GOOD.getItemId())
    ));

    public static VirtualCategory GOOD_PACKS = new VirtualCategory ("Packs of Chocolate Cakes", new ArrayList<String>(
            Arrays.asList(TWENTY_CAKES_PACK.getItemId(), FIFTY_CAKES_PACK.getItemId(), HUNDRED_CAKES_PACK.getItemId(), TWOHUNDRED_CAKES_PACK.getItemId())
    ));
}

