
**iOS-store Documentation Conventions**
=====================


##Order of Code 
**.h files:**


1. SOOMLA Copyright message 
2. Imports
3. typedefs (if needed)
4. @interface declaration with instance variables
5. @property declarations
6. Constructors
7. Public methods
8. @end declaration

**.m files:**


1. SOOMLA Copyright message 
2. Imports
3. @implementation declaration
4. @synthesize declaration
5. Constructor implementation
6. Public method implementations
7. @property implementations
8. Private method implementations
9. @end declaration



##SOOMLA's Copyright Message


SOOMLA is licensed under the Apache License. This copyright message must be included in every file at the top.

```
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

```

##General Guidelines

- Documentation should mostly be written in the header file (.h), and should NOT be repeated in the implementation (.m) file. 
- A doc comment must precede a class, method declaration, constructor, or field.
- For private methods, documentation comments are optional - if the method is non-trivial and complex, you should document it, otherwise leave it with no comments.
- Do not write documentation for trivial getter and setter methods.
- Do not write documentation for trivial fields.
- A doc comment is made up of two parts: a description and @tags.
- Insert a blank line between the description and the list of @tags.
- The first line of a comment MUST begin with the begin-comment delimiter ( /**).
- The last line of a comment MUST end with the end-comment delimiter ( */).
- Each line in between the begin-comment delimiter and end-comment delimiter should NOT begin with an asterisk (*). See examples below.
- Limit any doc-comment lines to 80 characters.


##Use of Markdown

**Use markdown for formatting. This will be used by AppleDoc.**

- `@param [param] [description]` - describe what value this parameter should be.
- `@return [description]` - describe the return value of the method.
- `@see [reference]` - reference related method.
- `@warning [description]` - describe warnings the user should be aware of.
- `@exception [name] [description]` - describe in what situations the exception will be thrown.
- When referring to source code, wrap the code in backtick quotes: \`someCode\`. Appledoc will convert this to `someCode`. 
- When referring to a known class, category, or protocol, there is no need for special tags. Appledoc will automatically identify them and turn them into links. 
- Any valid URL address starting with http://, https://, ftp://, file:// or mailto: will be automatically converted to a link in HTML.

For more information about AppleDoc conventions see https://github.com/tomaz/appledoc/blob/master/CommentsFormattingStyle.markdown.

##Description and Tags

**Classes and Interfaces**

- If this is an abstract class write 'ABSTRACT.' before the description. The description should follow on the next line.

    ```
    /**
     ABSTRACT.
     This class ...
     */
    @interface MyClass : NSObject { 
        ... 
    }
    ```

- State the purpose of this class or interface.
- Include possible 'Real Game Examples' to make the purpose clearer.
- Include any important notes or warnings the user should know.
- Declare the inheritance path like so: Inheritance: Class > Superclass > …
    - Do not declare an inheritance path that consists of only one level.

Example:

```
/**
 SingleUse virtual goods are the most common type of VirtualGood.
 
 The SingleUseVG's characteristics are:
  1. Can be purchased an unlimited number of times.
  2. Has a balance that is saved in the database. Its balance goes up when you "give" it or
      "buy" it. The balance goes down when you "take" it.
 
 Real Game Examples: 'Hat', 'Sword', 'Muffin'
 
 NOTE: In case you want this item to be available for purchase in the App Store, 
 you'll need to define the app store item in iTunes Connect.
(https://itunesconnect.apple.com)
 
 Inheritance: SingleUseVG > VirtualGood > PurchasableVirtualItem > VirtualItem
 */
@interface SingleUseVG : VirtualGood {
    ...
}
```
<br>
**Methods**

- If the method is a constructor, write “Constructor” as the first line, continue the rest of the description on the next line.
- The description must begin with a 3rd person descriptive verb.
    - CORRECT: “Checks…”, “Converts…”, “Retrieves...”, etc.. 
    - INCORRECT: “Check”, “This method does…” 
    - The description of the method cannot begin with “Returns…”
- Include possible examples to make the purpose of the method clearer.
- Include any important notes or warnings the user should know.
- Overriding methods - if the overriding method’s description is exactly the same as its parent method’s description, write: “see parent”. Otherwise, write a description.
- In iOS-store there are many methods that have two forms - one receives a flag parameter (for triggering an event), and the other does not. Only the latter should be documented, not both.

Example:
```
/**
 Retrieves the upgrade level of the virtual good with the given `goodItemId`.
 
 For Example:
 Let's say there's a strength attribute to one of the characters in your game 
 and you provide your users with the ability to upgrade that strength on a
 scale of 1-3.
 This is what you've created:
  1. SingleUseVG for "strength"
  2. UpgradeVG for strength 'level 1'
  3. UpgradeVG for strength 'level 2'
  4. UpgradeVG for strength 'level 3'
 In the example, this function will retrieve the upgrade level for "strength" 
 (1, 2, or 3).
 
 @param goodItemId id of the virtual good whose upgrade level we want to know. 
 The `goodItemId` can be of any `VirtualGood`.
 @return upgrade level
 @exception VirtualItemNotFoundException if the item is not found.
 */
+ (int)goodUpgradeLevel:(NSString*)goodItemId;
```

<br>
**Fields**

For non-trivial fields, write a clear description of the variable. Many fields have names that completely explain their purpose - for these there is no need to write comments.

- If the description fits on the same line as the code, insert it following the code.
- If the comment fits on one line, add a comment above the line of code.
- Otherwise, if the comment is longer than one line, use the regular commenting conventions.

    Note: Single-line comments should begin with three slashes (`///`).

Examples:
```
static NSString* TAG = @"SOOMLA equippingModel"; /// used for Log error messages

/// TAG is used for Log error messages ... more-text more-text more-text more-text...
static NSString* TAG = @"SOOMLA equippingModel";

/**
 TAG is used for Log error messages ... more-text more-text more-text more-text
 more-text more-text more-text more-text more-text more-text more-text more-text...
 */
static NSString* TAG = @"SOOMLA equippingModel";
```



    

