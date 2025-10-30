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

-Fix the Register screen to accept the parish as well to send to the database ✅

-Create Logic for businesses to register on the register page. Eg, request to be a business
by pressing a button or a slider? Send the flag for backend, then do it manually as an admin?
Or on clicking Register, you give the option as a regular user or as a business! (Might be better to seperate logic)
Or, just let it check the list of registered businesses on frontend to see if it is true, but ensure to follow up with email to verify business

-Create new splash screens (Remember that there are 2 of them). For uniqueness

-Fix the gap on the screens between the appbar and scaffold. 
    FIX: IT IS ACTUALLY THE STYLE, CHANGEABLE IN "app_bar_bottom class" line 18.

-Fix the errors popping up on login and screen changes
changed as String map['_id'] as String to as String? ?? map['_id'] as String ✅

-Create the comparing feature(Which si the main selling part of the app)

-Create the uploads page 
    So every upload must be tied to a category. Keep that in mind. 
    These are the fields for it: const productSchema = Schema({
    name: { type: String, required: true },
    description: { type: String, required: true },
    price: { type: Number, required: true },
    brand: { type: String, required: true },
    model: { type: String },
    rating: { type: Number, default: 0.0 },
    colors: [{ type: String }],
    image: { type: String, required: true },
    images: [{type: String}],
    reviews: [{ type: Schema.Types.ObjectId, ref: 'Review' }],
    numberofReviews: { type: Number, default: 0 },
    sizes: [{type: String}],
    category: { type: Schema.Types.ObjectId, ref: 'Category', required: true },
    genderAgeCategory: { type: String, enum: ['men', 'women', 'unisex', 'kids'] },
    countInStock: { type: Number, required: true, min: 0, max: 255 },
    dateAdded: { type: Date, default: Date.now },
    owner: { type: Schema.Types.ObjectId, ref: 'User', required: true}

-Create an uploads preview page
- Plug in the categories in the categories section of the uploads page. so they pick one from backend.

-Why does the category state extend equatable?

- TODO: Make sure that the colors are changed to hex values before backend upload, but I think
- that was done on backend. Please check to ensure.


- Remember your router.main.dart files
- NEXTjs learn it for web apps. React Native. Laravel/ PHP for work
- Fix the upload banner (Not going into dark mode)) ✅
- The text color is not changing with the dark mode, in category upload ✅
res issue with cron_job ✅

Cat upload and product upload, fully functional!


- Fix adding to a wishlist. Error received:
  I/flutter (20827): {"type":"TypeError","message":"Cannot read properties of undefined (reading 'find')"}
  I/flutter (20827): #0      debugPrintStack (package:flutter/src/foundation/assertions.dart:1204:29)
  I/flutter (20827): #1      WishlistRemoteDataSrcImpl.addToWishlist (package:compair_hub/src/wishlist/data/datasources/wishlist_remote_data_src.dart:97:9)
  I/flutter (20827): <asynchronous suspension>
  I/flutter (20827): #2      WishlistRepoImpl.addToWishlist (package:compair_hub/src/wishlist/data/repos/wishlist_repo_impl.dart:30:7)
  I/flutter (20827): <asynchronous suspension>
  I/flutter (20827): #3      UserWishlist.addToWishlist (package:compair_hub/src/wishlist/presentation/app/adapter/wishlist_provider.dart:41:20)
  I/flutter (20827): <asynchronous suspension>



- Fix the updating product amount in My Cart (Reference error, cart is not defined). Error message received:
  I/flutter (17299): <asynchronous suspension>
  I/flutter (17299): #3      CartAdapter.getCartProduct (package:compair_hub/src/cart/presentation/app/adapter/cart_provider.dart:114:20)
  I/flutter (17299): <asynchronous suspension>
  I/flutter (17299): {"type":"ReferenceError","message":"cart is not defined"}
  I/flutter (17299): #0      debugPrintStack (package:flutter/src/foundation/assertions.dart:1204:29)
  I/flutter (17299): #1      CartRemoteDataSrcImpl.getCartProduct (package:compair_hub/src/cart/data/datasources/cart_remote_data_src.dart:154:9)
  I/flutter (17299): <asynchronous suspension>
  I/flutter (17299): #2      CartRepoImpl.getCartProduct (package:compair_hub/src/cart/data/repos/cart_repo_impl.dart:40:22)

- Entering the wishlist section: Error received:
  I/flutter (20827): {"type":"TypeError","message":"user.wishlist is not iterable"}
  I/flutter (20827): #0      debugPrintStack (package:flutter/src/foundation/assertions.dart:1204:29)
  I/flutter (20827): #1      WishlistRemoteDataSrcImpl.getWishlist (package:compair_hub/src/wishlist/data/datasources/wishlist_remote_data_src.dart:51:9)
  I/flutter (20827): <asynchronous suspension>
  I/flutter (20827): #2      WishlistRepoImpl.getWishlist (package:compair_hub/src/wishlist/data/repos/wishlist_repo_impl.dart:17:22)
  I/flutter (20827): <asynchronous suspension>
  I/flutter (20827): #3      UserWishlist.getWishlist (package:compair_hub/src/wishlist/presentation/app/adapter/wishlist_provider.dart:29:20)
  I/flutter (20827): <asynchronous suspension>


IMPORTANT FEATURES TO ADD!
- Create the "COMPAIR FUNCTION" in the product details view section! ✅
- Create new controllers and routes in order to get either FURNITURE/APPLIANCES OR AUTOPARTS on APP OPENING, so that users can choose which to shop on the app!
- Create a feature on the mobile app for only admins to set a company as a business or remove their privileges as a business!!!!!!! So handle seeing their isBusiness status, and toggling the value to send to backend from the frontend!
The backend implementation is ready. Route with middleware: router.patch('/users/:id/business', verifyAdminUser, usersController.setBusiness);

- Only the OWNER of the APP, can add or remove admins. So set the owner tag for only one person. YOU! How, figure it out. Or just hard code it in the database G.
- handled

Since I am not using the client, do I still need the:
const CategoryUploadRemoteDataSourceImplementation(this._client);
final http.Client _client; ?

In the category_upload_remote_datasource? research it!


2 seperate logos for compairing the autoparts vs. furniture/appliance.

Not getting the products under the Car Guys Unite Category section ✅

Add a button to surround retry in the categories on the home page above pop. products when something goes wrong ✅
(maybe shut off server to get the error again)

No required fields and yet it says to fill in required fields. (Check all form instances)

Replace the beginning app splash screen

Add a home button to the STACK (products preview page) IF they have opened like tons of compairs, else, let it be just the back button ✅
Name is not label 

When you log on from a different IP from what the pictures were uploaded from, then the photos don't show. Why?

How can I make the compare button and then the logo jump? On the Top of the product image? Or where?

Already added to cart, then show something else like a green tick button. ✅

Recurring error when trying to update the amount of something in a cart ✅

Adding a product to the cart that is already there. 1 product more than 1 times. 1 product like 10 times. (FIXED BY CHANGING THE BUTTON WHEN THE PRODUCT IS ALREADY IN THE CART) ✅

Fix up the email that they get from us OTP stuff

Checkout not working, crashes the server!!!!!!!!!!!!!

When searching for a category by the list of category user the search bar, does not work.




TOP PRIORITY
-------------
Work on fetching Appliances-Furniture vs. autoparts. ⬅️
    - Backend completely implemented for this feature. It works by using a query for the type on the products table in the database.
    - So just send a query for finding a autopart vs furniture-appliance!
    - Get it done next 

Admin features for Allowing someone to be a business or not.

Adding the logic on the registration page for checking if someone wants to be considered as a business. (manual by admin or automatically by server side logic? )

Changing the UI Ads and Posters on first time screen.
