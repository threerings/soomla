**android-store Documentation Conventions**
=====================


##Order of Code


 1. SOOMLA Copyright message
 2. Imports
 3. Constructors
 4. Public methods
 5. Setters and Getters
 6. Protected methods
 7. Private methods
 8. All class members



##SOOMLA's Copyright Message


SOOMLA is licensed under the Apache License. This copyright message must be included in every file at the top before the package declaration.

```
/* Copyright (C) 2012 Soomla Inc.
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
 package ...

```

##General Guidelines


 - A doc comment must precede a class, public/protected method declaration, constructor, or field.
 - For private methods, documentation comments are optional - if the method is non-trivial and complex, you should document it, otherwise leave it with no comments.
 - Do not write documentation for trivial getter and setter methods.
     - Insert: `/** Setters and Getters **/` before the entire group of setters and getters, following 2 blank lines, and followed by 1 blank line.
 - Do not write documentation for trivial fields.
     - Insert: `/** Private Members **/` before the entire list of fields, following 2 blank lines, and followed by 1 blank line.
 - A doc comment is made up of two parts: a description and @tags 
 - If @tag descriptions do not fit on one line, the next lines should be indented at least 4 spaces.
 - Insert a blank line between the description and the list of tags.
 - The first line of a comment contains the begin-comment delimiter ( /**).
 - The last line of a comment contains the end-comment delimiter ( */).
 - Each line in between the begin-comment delimiter and end-comment delimiter should start with * .
 - Limit any doc-comment lines to 80 characters.


##Special Tags

This will be used by Javadoc.

 - `@param [param] [description]`: Describe what value this parameter should receive.
 - `@return [description]`: Describe the return value of the method.
 - `@see [reference]`: Give a reference related to the method.
 - `@throws [name] [description]`: Describe in what situations the exception will be thrown.
 - When referring to source code, wrap the code in code tags like so: `<code>someCode</code>`. Javadoc will convert this to `someCode`. 
 - When referring to a known class or method use `{@link [reference]}`.
 - To insert a link to an external URL use: `<a href="http://google.com">http://google.com</a>`.

For more information about Javadoc conventions see http://www.oracle.com/technetwork/java/javase/documentation/index-137868.html#tag.


##Description and Examples

> In the following examples, the order is important!
<br>

**Classes and Interfaces**

 - State the purpose of this class or interface.
 - Include possible 'Real Game Examples' to make the purpose clearer.
 - Include any important notes or warnings the user should know.
 - Declare the inheritance path like so: 
 `Inheritance: Class > Superclass > ...`
     - Do not declare an inheritance path that consists of only one level.
     - Use `{@link [reference]}` to make the superclasses available as links (see example below).

Example:
```
/**
* Single use virtual goods are the most common type of <code>VirtualGood</code>.
 *
 * The <code>SingleUseVG</code>'s characteristics are:
 *  1. Can be purchased an unlimited number of times.
 *  2. Has a balance that is saved in the database. Its balance goes up when you "give" it or
 *     "buy" it. The balance goes down when you "take" or (unfriendly) "refund" it.
 *
 * Real Game Examples: 'Hat', 'Sword', 'Muffin'
 *
 * NOTE: In case you want this item to be available for purchase with real money
 * you will need to define the item in the market (Google Play, Amazon App Store, etc...).
 *
 * Inheritance: {@link com.soomla.store.domain.virtualGoods.SingleUseVG} >
 * {@link com.soomla.store.domain.virtualGoods.VirtualGood} >
 * {@link com.soomla.store.domain.PurchasableVirtualItem} >
 * {@link com.soomla.store.domain.VirtualItem}
 */
public class SingleUseVG extends VirtualGood {
    ...
}
```


<br>
**Methods**

 - The description should clearly state the purpose of the method.
 - If this is a constructor, write “Constructor” as the first line, continue the rest of the description on the next line.
 - The description must begin with a 3rd person descriptive verb
     - CORRECT: “Checks…”, “Converts…”, “Retrieves...”, etc.. 
     - INCORRECT: “Check”, “This method does…” 
     - The description of the method cannot begin with “Returns…”
 - The description should be a complete sentence that ends with a period.
 - Include possible examples to make the purpose of the method clearer.
 - Include any important notes or warnings the user should know.
 - Insert a blank line between the description and the @tags (`@param`, `@return`, `@throws`, etc...).
 - Overriding Methods: 
     - If the overriding method’s description is exactly the same as its parent method’s description use the `{@inheritDoc}` tag. Otherwise, write a description.
     - Insert @override after the end-delimiter of the comment, and right before the method code.
```     
   /**
     * {@inheritDoc}
     */
    @Override
    public JSONObject toJSONObject() {
        return super.toJSONObject();
    }
```
- Referring to a Method in a Comment: 
     - When referring to a method or constructor that has multiple forms, and you mean to refer to a specific form, use parentheses and argument types. For example, SOOMLA’s `VirtualItem` has two `give` methods: `give(int amount)` and `give(int amount, boolean notify)`. 
     - If referring to both forms of the method, omit the parentheses altogether.
CORRECT: “The `give` method enables you to give your user something for free.” 
INCORRECT: “The `give()` method enables you to give your user something for free.” 

Example:
```
/**
  * Gives your user the given amount of the virtual item with the given itemId.
  * For example, when your user plays your game for the first time you GIVE him 1000 gems.
  *
  * NOTE: This action is different than buy -
  * You use <code>give(int amount)</code> to give your user something for free.
  * You use <code>buy()</code> to give your user something and you get something in return.
  *
  * @param itemId id of the virtual item to be given
  * @param amount amount of the item to be given
  * @throws VirtualItemNotFoundException if item with given itemId is not found
  */
  public static void giveVirtualItem(String itemId, int amount)
            throws VirtualItemNotFoundException  {
    ...
  }
```
<br>
**Class Members**

- If the description fits on the same line as the code, insert it following the code.
- If the comment fits on one line, add a comment above the line of code. 
- Otherwise, if the comment is longer than one line, use the regular commenting conventions.

Example:
```
private static final String TAG = "SOOMLA VirtualItem"; //used for Log error messages

// TAG is used for Log error ...messages more-text more-text more-text more-text...
private static final String TAG = "SOOMLA VirtualItem"; 

/** 
 * TAG is used for Log error messages ...more-text more-text more-text more-text more-text 
 * more-text more-text more-text more-text more-text...
 */
private static final String TAG = "SOOMLA VirtualItem"; 

```

 

     



 

 


   
