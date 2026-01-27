# Compair

A mobile application designed to allow users to compair auto parts and appliances from reputable Jamaican dealers.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

GENERAL NOTES WHILE BUILDING THE APP


RIVERPOD NOTES

Use dart run build_runner build watch --delete-conflicting-outputs for 'auto' tracking riverpod changes. So it keeps running and 
tracking changes!

' dart run build_runner build watch --delete-conflicting-outputs ' for Just building riverpod stuff.

If you are trying to login, and all you get is a spinning indicator, it is likely that you have not put in the correct ip address for it to connect

Added this line in the android/app/src/main/AndroidManifest.xml android manifest file: android:enableOnBackInvokedCallback="true"


//TODOs:
-Create Logic for businesses to register on the register page. Eg, request to be a business
by pressing a button or a slider? Send the flag for backend, then do it manually as an admin?
Or on clicking Register, you give the option as a regular user or as a business! (Might be better to seperate logic)
Or, just let it check the list of registered businesses on frontend to see if it is true, but ensure to follow up with email to verify business

-Create new splash screens (Remember that there are 2 of them). For uniqueness

-Why does the category state extend equatable? 

- TODO: Make sure that the colors are changed to hex values before backend upload, but I think that was done on backend. Please check to ensure.

- TODO: Add a compare feature for HARDWARE Stores. That may be a major breakthrough along with autoparts and furniture. (Very Important)

IMPORTANT FEATURES TO ADD!
- Create a feature on the mobile app for only admins to set a company as a business or remove their privileges as a business!!!!!!! So handle seeing their isBusiness status, and toggling the value to send to backend from the frontend!

- Only the OWNER of the APP, can add or remove admins. So set the owner tag for only one person. YOU! How, figure it out. Or just hard code it in the database G.

Since I am not using the client, do I still need the:
const CategoryUploadRemoteDataSourceImplementation(this._client);
final http.Client _client; ?

In the category_upload_remote_datasource? research it!


Replace the beginning app splash screen

How can I make the compare button and then the logo jump? On the Top of the product image? Or where?

Fix up the email that they get from us OTP stuff

extra is sent to the GoRouter through the 'categories section' and 'compare_view' (for compare view, where the _related products is called in the top method.).

TOP PRIORITY
-------------
Work on fetching Appliances-Furniture vs. autoparts. ✅
    - A pop up message on every app turn on reminding them that they can shop autopart OR furniture. So on app turn on ask, and an option to stop asking for 10 - 14 days. also for the other IF you allow persisting states.

Also, work on tutorials on app install that tells them about comparing, switching to furniture/hardware etc. Tutorial would be awesome with an option to redo the tutorial.
Bugs:
    - The type does not persist after you navigate to somewhere. Probably navigating from wishlist to somewhere else. Probably, not sure tho.

Check if you have to buy lottie to continue using them?

FIX: Add the address to the profile view so that they can change it as well.

FIX THE PAGINATEDPRODUCTSVIEW for the proper assertions. refer to line 24-27. Make updates to add in the parish assersions.

Add an icon for the FIRST 10 COMPANIES TO SIGN UP FOR THE APP. OUR UNIQUE TOUCH

IF THE TOKEN IS UNAUTHORIZED OR REVOKED, THEN TAKE THEM BACK TO THE LOGIN PAGE. CHECK IT, BY LOGGING IN ON POSTMAN AND SEE WHAT IT DOES, IF IT DOES NOT TAKE YOU BACK TO THE LOGIN PAGE, AND JUST INFINATE LOADS, TEHN JUST IMPLEMENT IT.

ALL BUSINESSES MUST have a profile picture, no removal of profile pictures.

In the backend add the address fields of the user. ORRRRRRRRRRRRRRRRRRR Just make BUSINESSES add their full info. DO IT FOR USERS SO THAT THEY CAN GET CUSTOM ITEMS. YEAAAAAAAAAAAAAAAAA

Look into the logic for the users purchasing goods. How'd they get it, verified payments etc.

Put in safety measures, so that they can't spam stuff. (??? Meaning what Ralph)

Add a different checkout system for users like PayAveta etc.

Admin features for Allowing someone to be a business or not.

Adding the logic on the registration page for checking if someone wants to be considered as a business. (manual by admin or automatically by server side logic? )

Changing the UI Ads and Posters on first time screen.

Request a category feature?

Look into is the CRON Job on backend actually being used? You added the delete product image instantly, which may have bypassed it. (Really important!)

#### **_BUGS FOUND ON MOBILE TESTING:_**

Fix the 500 error message. Like instead of :ERROR 500: IT'S......." Remove the 500?

FIX: I think when you switch to the wishlist from home, then switch back to home, if you are in furniture, then it just goes to the default autopart without the user doing it. Check if it still happens then fix it.

FIX: What is the default for the images when they cannot be displayed for whatever reason on frontend.

FIX: Refactor edit product view and make it cleaner by removing some of the functions and placing them in widgets and then calling them back in the product edit view page.

FIX: Take out all of the print statements in wishlist.

FIX: For long term, Add an endpoint that actually shuffles teh products for real randomness, or that shuffles more of one product when a business pays for them to be recommended more.

Recheck the logic for popular and new products.

FIX: To let it seem more unique, under both popular and new arrivals, put a down arrow respectfully that when pressed takes the user to a full page view that displays the products respectfully. So that it have a better UI. And on last product, when they slide up for 2 seconds, takes them back to the home page.

LOOK INTO: Adding a functionality for the search FILTERS. Like in search filters section, add a search filter that filters by parish (already have that), category (already have that), price range slider, sorting options (price high to low newest etc.)

To safely refer to a widget's ancestor in its dispose() method, save a reference to the ancestor by calling dependOnInheritedWidgetOfExactType() in the widget's didChangeDependencies() method.


### Sales Ideas:

THIS IS NOT A PARTNERSHIP!!!!!!!!!!
It is simply me telling them about a business idea that will benefit us!
Pitch the idea of them telling businesses about compair. So then, businesses would come to them to manage that source of 
social media. Coming to them, they could go to them and pitch it.

Long stretch but it will work.






Error: The following assertion was thrown during a scheduler callback:
ref.listen can only be used within the build method of a ConsumerWidget
'package:flutter_riverpod/src/consumer.dart':
Failed assertion: line 600 pos 7: 'debugDoingBuild'














CODING NOTES:

Easily expandable to include hardware stuff as well. Do it!!!!!


Implemented, but nothing is being sent in as the type when there is already a global value. Check on that ✅




In ALL things, pray about it. For the right features to add. The right ways to add then. The right time to get things done. 

God will work it out for our good :)








































**Completed aspects of compare by personal notes:** 

Display all images for them to choose which to remove? (product edit view) ✅

So now when you try to upload a new image from the edit product screen, it is sent as an octet when it is an actual jpg or jpeg etc. Needs to be fixed
Everything else works tho when uploading. ✅

Display all of the that specific vendor's product or just leave it be? So that they don't just shop them and give competition a chance? Naaaah do it! YES! DID IT 😁✅

Let businesses see their own products with the option of deleting them. ✅
(Create a new product details page dedicated to the editing of a SPECIFIC PRODUCT. So when the tile is clicked, send the tag and check IF it is coming from the profile view, then show that one.) ✅

Implement a vendor profile display so that users can see who is selling what. And list all of their products in their profile section. ✅

Upgraded search view to include a search by parish feature. Additionally, immediate search when a category or parish is selected. ✅

Implement a profile picture upload for BUSINESSES AND ADMINS OR SUPER ADMIN ONLY. (Works, but please implement a feature to remove the profile picture without replacing it. Literally remove it) ✅

Very important -> Remember to implement a filter by parish feature ✅

Protect the upload on the backend. If you are not a business nor admin, no user uploads. ✅

The drawer change option does not work on the explore page for the category selector slider. ✅

Fix the wishlist crashing issue. ✅

Fix add to cart from wishlist. ✅

Fix the 'In Cart!' button when the product is already in the cart so that they cannot add it more than once to cart. ✅

The type does not persist after you navigate to wishlist and back to home. Anytime you go to wishlist and navigate to anywhere else it happens. ✅

Work on fetching Appliances-Furniture vs. autoparts. ✅
- Backend completely implemented for this feature. It works by using a query for the type on the products table in the database. ✅
- So just send a query for finding a autopart vs furniture-appliance! ✅
- Get it done next ✅
- Add a physical button to toggle product types. ✅
- Add type to the UPLOADS of a category and a product. ️✅
- Add the type to the categories search in Explore View. ✅
- Add the type of the returned products in the Explore View. ✅

When searching for a category by the list of category user the search bar, does not work. WORKS ✅

Feature idea, when you hit the compare logo, it changes the products from autoparts to furniture/appliances and viceversa. ✅
And it additionally switches the colors. From blue 'com' and orange 'pare', to orange 'com' and blue 'pare' ✅

Already added to cart, then show something else like a green tick button. ✅

Recurring error when trying to update the amount of something in a cart ✅

Adding a product to the cart that is already there. 1 product more than 1 times. 1 product like 10 times. (FIXED BY CHANGING THE BUTTON WHEN THE PRODUCT IS ALREADY IN THE CART) ✅

Add a home button to the STACK (products preview page) IF they have opened like tons of compairs, else, let it be just the back button ✅

Not getting the products under the Car Guys Unite Category section ✅

Add a button to surround retry in the categories on the home page above pop. products when something goes wrong ✅

Create the "COMPAIR FUNCTION" in the product details view section! ✅

- Fix the upload banner (Not going into dark mode)) ✅
- The text color is not changing with the dark mode, in category upload ✅

res issue with cron_job ✅

changed as String map['_id'] as String to as String? ?? map['_id'] as String ✅

Fix the Register screen to accept the parish as well to send to the database ✅

FIX: Categories coming in as null for editing products. FIXED!!!!!!! ✅

Search for a specific Category seeing as though there can be many at once. ✅

Click the category tab and when they do, it switches to the category. ✅

FIX: For the Category in the vendor edit view, sometimes throws a null check operator error red. FIX that. FIXED!!!!! By replacing the old category display with a new searchable category widget, that allows the user to search for a category instead of scrolling through all of them manually. ✅

FIX: Counter for Current Images in edit product view. ✅

FIX: Randomize the returned Compare products ✅

FIX: Fix the search category, all categories aren't showed immediately unless you search and then when you select, you cannot immediately save. ✅

FIX: I selected the category in upload view but it did not select the id to send, still sets as null ✅

FIX: If there is a required field, tell them with a snackbar. ✅

FIX: Let after selection, it jumps to the front with the user if they manually selected it. ✅

FIX: Allow the user to navigate to the cart in the product DETAIL view. ✅

FIX: How the text looks on the current product compare view. ✅

-Fix the gap on the screens between the appbar and scaffold.
FIX: IT IS ACTUALLY THE STYLE, CHANGEABLE IN "app_bar_bottom class" line 18. ✅

-Fix the errors popping up on login and screen changes ✅

-Create the comparing feature(Which is the main selling part of the app) ✅

-Create the uploads page
So every upload must be tied to a category. Keep that in mind. ✅

- Plug in the categories in the categories section of the uploads page. so they pick one from backend. ✅

Cat upload and product upload, fully functional! ✅

- Fix adding to a wishlist. Error received: ✅
  I/flutter (20827): {"type":"TypeError","message":"Cannot read properties of undefined (reading 'find')"}
  I/flutter (20827): #0      debugPrintStack (package:flutter/src/foundation/assertions.dart:1204:29)
  I/flutter (20827): #1      WishlistRemoteDataSrcImpl.addToWishlist (package:compair_hub/src/wishlist/data/datasources/wishlist_remote_data_src.dart:97:9)
  I/flutter (20827): <asynchronous suspension>
  I/flutter (20827): #2      WishlistRepoImpl.addToWishlist (package:compair_hub/src/wishlist/data/repos/wishlist_repo_impl.dart:30:7)
  I/flutter (20827): <asynchronous suspension>
  I/flutter (20827): #3      UserWishlist.addToWishlist (package:compair_hub/src/wishlist/presentation/app/adapter/wishlist_provider.dart:41:20)
  I/flutter (20827): <asynchronous suspension>

- Fix the updating product amount in My Cart (Reference error, cart is not defined). Error message received: ✅
  I/flutter (17299): <asynchronous suspension>
  I/flutter (17299): #3      CartAdapter.getCartProduct (package:compair_hub/src/cart/presentation/app/adapter/cart_provider.dart:114:20)
  I/flutter (17299): <asynchronous suspension>
  I/flutter (17299): {"type":"ReferenceError","message":"cart is not defined"}
  I/flutter (17299): #0      debugPrintStack (package:flutter/src/foundation/assertions.dart:1204:29)
  I/flutter (17299): #1      CartRemoteDataSrcImpl.getCartProduct (package:compair_hub/src/cart/data/datasources/cart_remote_data_src.dart:154:9)
  I/flutter (17299): <asynchronous suspension>
  I/flutter (17299): #2      CartRepoImpl.getCartProduct (package:compair_hub/src/cart/data/repos/cart_repo_impl.dart:40:22)

- Entering the wishlist section: Error received: ✅
  I/flutter (20827): {"type":"TypeError","message":"user.wishlist is not iterable"}
  I/flutter (20827): #0      debugPrintStack (package:flutter/src/foundation/assertions.dart:1204:29)
  I/flutter (20827): #1      WishlistRemoteDataSrcImpl.getWishlist (package:compair_hub/src/wishlist/data/datasources/wishlist_remote_data_src.dart:51:9)
  I/flutter (20827): <asynchronous suspension>
  I/flutter (20827): #2      WishlistRepoImpl.getWishlist (package:compair_hub/src/wishlist/data/repos/wishlist_repo_impl.dart:17:22)
  I/flutter (20827): <asynchronous suspension>
  I/flutter (20827): #3      UserWishlist.getWishlist (package:compair_hub/src/wishlist/presentation/app/adapter/wishlist_provider.dart:29:20)
  I/flutter (20827): <asynchronous suspension>

- Create new controllers and routes in order to get either FURNITURE/APPLIANCES OR AUTOPARTS on APP OPENING, so that users can choose which to shop on the app! ✅

Logic for users seeing the company that is selling it. ✅

Improve the logic to check if the product is in the cart. It is running many times. ✅

The multipart thing supports uploads while file does not. That might cause an issue. Used Multipart for image uploads. ✅

Fix user changing name, pixel overflow. ✅

Fix compare feature, bottom pixel overflow by 14 pixels. for both current and similar products. ✅

Fix compare the yellow lines are on all of the words and numbers at current, and only the label similar products at the bottom. ✅
No need for a fix, it is a developer thing to show what the words are on for designing purposes

FIX: Let the comparing products be randomized, and not the same products everytime. ✅

FIX: Add a tooltip on the user profile name view for long names. Helps the user to be able to view their full business name. ✅

FIX: Add a tooltip on the dashboard drawer for the user's name for long names. Helps the user to be able to view their full business name. ✅

FIX: Wrap compare product's name (current and similar products) with a tooltip. ✅

Fix the business name on dashboard drawer. Pixel overflow. ✅

Fix the remove from cart. Pixel overflow. ✅
