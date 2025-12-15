import 'package:compair_hub/core/common/entities/user.dart';
import 'package:compair_hub/core/common/widgets/app_bar_bottom.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/extensions/string_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:compair_hub/src/product/presentation/app/provider/product_type_notifier.dart';
import 'package:compair_hub/src/vendor/presentation/views/vendor_products_view.dart';
import 'package:compair_hub/src/vendor/presentation/widgets/vendor_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class VendorView extends ConsumerStatefulWidget {
  const VendorView({super.key, required this.vendor});

  final User? vendor;

  static const path = '/vendor';

  @override
  ConsumerState<VendorView> createState() => _VendorViewState();
}

class _VendorViewState extends ConsumerState<VendorView> {
  final productAdapterFamilyKey = GlobalKey();
  final categoryFamilyKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    //If product type changes, trigger a refresh
    ref.listenManual(productTypeNotifierProvider, (previous, next) {
      if (previous != next) {
        setState(() {});
      }
    });
  }

  Future<void> getProducts(
    int page,
  ) async {
    final productAdapterNotifier =
        ref.read(productAdapterProvider(productAdapterFamilyKey).notifier);

    return productAdapterNotifier.getProducts(
      page,
      owner: widget.vendor?.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productType = ref.watch(productTypeNotifierProvider);
    final isAutoPart = productType.queryParam.toLowerCase() == 'autopart';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Details'),
        bottom: const AppBarBottom(),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(left: 20, right: 20.0, top: 0.0, bottom: 0.0, ) ,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 10),
            ),
            const Gap(5),
            //Vendor Avatar. Currently only initials. TODO: Implement a vendor avatar on the backend.
            Center(
              child: (widget.vendor?.profilePicture != null) ? CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.vendor!.profilePicture!),
                backgroundColor: Colours.lightThemePrimaryColour,
                onBackgroundImageError: (exception, stackTrace) {
                  debugPrint('Failed to load profile picture: $exception');
                },
                child: Container(), // Shows only if image fails to load
              ) : CircleAvatar(
                  radius: 50,
                  backgroundColor: Colours.lightThemePrimaryColour,
                  child: Center(
                    child: Text(
                      widget.vendor!.name.initials,
                      textAlign: TextAlign.center,
                      style: TextStyles.headingMedium.white,
                    ),
                  ),
                ),
              // child: CircleAvatar(
              //   radius: 50,
              //   backgroundColor: Colours.lightThemePrimaryColour,
              //   child: Center(
              //     child: Text(
              //       widget.vendor!.name.initials,
              //       textAlign: TextAlign.center,
              //       style: TextStyles.headingMedium.white,
              //     ),
              //   ),
              // ),
            ),

            const Gap(20),

            Text(
                  'Company: ',
                  style: TextStyles.headingBold.copyWith(fontSize: 17, color: isAutoPart ? Colours.lightThemePrimaryColour : Colours.lightThemeSecondaryColour),
                ),

            //Vendor Name
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                widget.vendor!.name,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.headingMedium.adaptiveColour(context).copyWith(fontSize: 25),
              ),
            ),

            const Gap(8),

            Text(
              'E-mail Address: ',
              style: TextStyles.headingBold.copyWith(fontSize: 17, color: isAutoPart ? Colours.lightThemeSecondaryColour : Colours.lightThemePrimaryColour),
            ),

            //Vendor email
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                widget.vendor!.email!,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.headingMedium.adaptiveColour(context).copyWith(fontSize: 20),
              ),
            ),

            const Gap(8),

            Text(
              'Phone number: ',
              style: TextStyles.headingBold.copyWith(fontSize: 17, color: isAutoPart ? Colours.lightThemePrimaryColour : Colours.lightThemeSecondaryColour),
            ),

            //Vendor Phone
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                widget.vendor!.phone!,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.headingMedium.adaptiveColour(context).copyWith(fontSize: 25),
              ),
            ),

            const Gap(8),

            Text(
              'Company Address: ',
              style: TextStyles.headingBold.copyWith(fontSize: 17, color: isAutoPart ? Colours.lightThemeSecondaryColour : Colours.lightThemePrimaryColour),
            ),

            //Vendor Address
            if (widget.vendor!.address != null)
              addressView(widget.vendor!, context),

            const Gap(5),

            //Display for ALL of an vendor's their products here
            Text(
                'Vendor\'s Complete Catalogue: ',
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.headingBold.copyWith(fontSize: 20, color: isAutoPart ? Colours.lightThemePrimaryColour : Colours.lightThemeSecondaryColour),
              ),

            GestureDetector(
              onTap: () => context.push(VendorProductsView.path, extra: widget.vendor),
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colours.lightThemePrimaryColour.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colours.lightThemePrimaryColour.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'View All Products',
                          style: TextStyles.headingBold.copyWith(
                            fontSize: 18,
                            color: Colours.lightThemePrimaryColour,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          'Browse complete product catalog',
                          style: TextStyles.paragraphSubTextRegular2.adaptiveColour(context),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colours.lightThemePrimaryColour,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            // Expanded(
            //   child: PaginatedProductGridView(
            //     productAdapterFamilyKey: productAdapterFamilyKey,
            //     fetchRequest: getProducts,
            //     categorized: false,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

//Circle avatar for a vendor avatar from teh backend:

/*CircleAvatar(
                radius: 50,
                backgroundColor: Colours.lightThemePrimaryColour.withOpacity(0.1),
                backgroundImage: seller.profilePic != null &&
                    seller.profilePic!.isNotEmpty
                    ? NetworkImage(seller.profilePic!)
                    : null,
                child: seller.profilePic == null || seller.profilePic!.isEmpty
                    ? Text(
                        seller.name.isNotEmpty
                            ? seller.name[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colours.lightThemePrimaryColour,
                        ),
                      )
                    : null,
              ),
            ),
            */
