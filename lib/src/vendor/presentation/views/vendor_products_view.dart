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
  });

  final User vendor;

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
      appBar: AppBar(//Optional 's ?
        title: const Text('Vendor\'s Catalogue'),//Text('${widget.vendor.name}\'s Products'), //User's name might be too long for the app bar?
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
                  CircleAvatar(  //TODO: Change the circle icon here to dealer profile picture
                    radius: 30,
                    backgroundColor: Colours.lightThemePrimaryColour,
                    child: Text(
                      widget.vendor.name.isNotEmpty
                          ? widget.vendor.name[0].toUpperCase()
                          : 'V',
                      style: TextStyles.headingMedium.white.copyWith(fontSize: 24),
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

            const Gap(10),

            // Products Grid
            Expanded(
              child: PaginatedProductGridView(
                key: ValueKey('vendor-${widget.vendor.id}-$productType'),
                productAdapterFamilyKey: productAdapterFamilyKey,
                fetchRequest: getProducts,
                categorized: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}