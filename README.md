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
- Fix the upload banner (Not going into dark mode))
- The text color is not changing with the dark mode, in category upload
res issue with cron_job ✅
    handled

Since I am not using the client, do I still need the:
const CategoryUploadRemoteDataSourceImplementation(this._client);
final http.Client _client;

In the category_upload_remote_datasource? research it!

