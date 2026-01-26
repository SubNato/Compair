import 'package:compair_hub/core/common/entities/user.dart';
import 'package:compair_hub/core/common/widgets/app_bar_bottom.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:compair_hub/src/product/presentation/app/provider/product_type_notifier.dart';
import 'package:compair_hub/src/product/presentation/widgets/paginated_product_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class VendorProductsView extends ConsumerStatefulWidget {
  const VendorProductsView({
    super.key,
    required this.vendor,
    this.isEditMode = false,
  });

  final User vendor;
  final bool isEditMode;

  static const path = '/vendorProducts';

  @override
  ConsumerState<VendorProductsView> createState() => _VendorProductsViewState();
}

class _VendorProductsViewState extends ConsumerState<VendorProductsView> {
  final productAdapterFamilyKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // If product type changes, trigger a refresh
    ref.listenManual(productTypeNotifierProvider, (previous, next) {
      if (previous != next) {
        setState(() {});
      }
    });
  }

  Future<void> getProducts(int page) async {
    final productAdapterNotifier =
        ref.read(productAdapterProvider(productAdapterFamilyKey).notifier);

    return productAdapterNotifier.getProducts(
      page,
      owner: widget.vendor.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productType = ref.watch(productTypeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        //Optional 's ?
        title: const Text('Vendor\'s Catalogue'),
        //Text('${widget.vendor.name}\'s Products'), //User's name might be too long for the app bar?
        bottom: const AppBarBottom(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vendor Info Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colours.lightThemePrimaryColour.withOpacity(0.05),
                border: Border(
                  bottom: BorderSide(
                    color: Colours.lightThemePrimaryColour.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  (widget.vendor.profilePicture != null)
                      ? CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(widget.vendor.profilePicture!),
                          backgroundColor: Colours.lightThemePrimaryColour,
                          onBackgroundImageError: (exception, stackTrace) {
                            debugPrint('Failed to load profile picture');
                          }, // Shows only if image fails to load
                        )
                      : CircleAvatar(
                          radius: 30,
                          backgroundColor: Colours.lightThemePrimaryColour,
                          child: Text(
                            widget.vendor.name.isNotEmpty
                                ? widget.vendor.name[0].toUpperCase()
                                : 'V',
                            style: TextStyles.headingMedium.white
                                .copyWith(fontSize: 24),
                          ),
                        ),
                  const Gap(15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.vendor.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.headingBold
                              .adaptiveColour(context)
                              .copyWith(fontSize: 18),
                        ),
                        const Gap(4),
                        Text(
                          'All Products',
                          style: TextStyles.paragraphSubTextRegular2
                              .adaptiveColour(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //When the edit mode flag is true, then show
            if (widget.isEditMode)
              Padding(
                padding: const EdgeInsets.only(top: 10.0,left: 20.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colours.lightThemePrimaryColour.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colours.lightThemePrimaryColour,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colours.lightThemePrimaryColour,
                      ),
                      const Gap(4),
                      Text(
                        'Tap product to edit or view details',
                        style: TextStyles.paragraphSubTextRegular2.copyWith(
                          color: Colours.lightThemePrimaryColour,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const Gap(10),

            // Products Grid
            Expanded(
              child: PaginatedProductGridView(
                key: ValueKey('vendor-${widget.vendor.id}-$productType'),
                productAdapterFamilyKey: productAdapterFamilyKey,
                fetchRequest: getProducts,
                categorized: false,
                isEditMode: widget.isEditMode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
