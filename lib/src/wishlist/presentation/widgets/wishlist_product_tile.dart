import 'package:compair_hub/core/common/singletons/cache.dart';
import 'package:compair_hub/core/common/widgets/bottom_sheet_card.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/extensions/widget_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/src/cart/data/models/cart_product_model.dart';
import 'package:compair_hub/src/cart/presentation/app/adapter/cart_provider.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:compair_hub/src/user/presentation/adapter/auth_user_provider.dart';
import 'package:compair_hub/src/wishlist/domain/entities/wishlist_product.dart';
import 'package:compair_hub/src/wishlist/presentation/app/adapter/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class WishlistProductTile extends ConsumerStatefulWidget {
  const WishlistProductTile(
    this.wishlistProduct, {
    required this.mainPageFamilyKey,
    super.key,
  });

  final WishlistProduct wishlistProduct;
  final GlobalKey mainPageFamilyKey;

  @override
  ConsumerState createState() => _WishlistProductTileState();
}

class _WishlistProductTileState extends ConsumerState<WishlistProductTile> {
  late WishlistProduct product;
  final wishlistAdapterFamilyKey = GlobalKey();
  final productAdapterFamilyKey = GlobalKey();
  final cartAdapterFamilyKey = GlobalKey();

  /// The main product this wishlist product was formed from
  Product? originalProduct;

  void removeFromWishlist() {
    ref
        .read(userWishlistProvider(wishlistAdapterFamilyKey).notifier)
        .removeFromWishlist(
          userId: Cache.instance.userId!,
          productId: product.productId,
        );
  }

  Future<void> addToCart() async {
    final router = GoRouter.of(context);
    if (product.productExists && !product.productOutOfStock) {
      if (originalProduct == null ||
          originalProduct!.colours.isNotEmpty ||
          originalProduct!.sizes.isNotEmpty) {
        final result = await showModalBottomSheet<bool>(
          context: context,
          backgroundColor: Colors.transparent,
          elevation: 0,
          isDismissible: false,
          builder: (_) {
            return const BottomSheetCard(
              title: 'You can only add this product to cart from the '
                  "product's page",
              positiveButtonText: 'Go',
              negativeButtonText: 'Cancel',
              positiveButtonColour: Colours.lightThemeSecondaryColour,
            );
          },
        );
        if (result ?? false) {
          goToProductPage(router);
        }
      } else {
        ref.read(cartAdapterProvider(cartAdapterFamilyKey).notifier).addToCart(
              userId: Cache.instance.userId!,
              cartProduct: const CartProductModel.empty().copyWith(
                productId: product.productId,
                quantity: 1,
              ),
            );
      }
    } else if (!product.productExists) {
      CoreUtils.showSnackBar(
        context,
        backgroundColour: Colors.red,
        message: 'Remove this product from your wishlist.'
            '\nIt no longer exists',
      );
    }
  }

  void goToProductPage(GoRouter router) {
    router.push('/products/${product.productId}');
  }

  @override
  void initState() {
    super.initState();

    product = widget.wishlistProduct;
    if (product.productExists && !product.productOutOfStock) {
      CoreUtils.postFrameCall(() {
        ref
            .read(productAdapterProvider(productAdapterFamilyKey).notifier)
            .getProduct(product.productId);
      });
    }
    ref.listenManual(
      productAdapterProvider(productAdapterFamilyKey),
      (previous, next) {
        if (next case ProductFetched(:final product)) {
          originalProduct = product;
        }
      },
    );

    ref.listenManual(
      userWishlistProvider(wishlistAdapterFamilyKey),
      (previous, next) {
        if (next case WishlistError(:final message)) {
          CoreUtils.showSnackBar(
            context,
            message: '$message\nPULL TO REFRESH',
          );
        } else if (next is RemovedFromWishlist) {
          CoreUtils.postFrameCall(
            () {
              ref
                  .read(userWishlistProvider(widget.mainPageFamilyKey).notifier)
                  .getWishlist(Cache.instance.userId!);
              ref
                  .read(authUserProvider(GlobalKey()).notifier)
                  .getUserById(Cache.instance.userId!);
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistAdapter = ref.watch(
      userWishlistProvider(wishlistAdapterFamilyKey),
    );

    final productAdapter = ref.watch(
      productAdapterProvider(productAdapterFamilyKey),
    );
    final cartAdapter = ref.watch(
      cartAdapterProvider(cartAdapterFamilyKey),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          foregroundDecoration: !product.productExists
              ? const BoxDecoration(
                  color: Colors.grey,
                  backgroundBlendMode: BlendMode.saturation,
                )
              : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: CoreUtils.adaptiveColour(
              context,
              lightModeColour: Colours.lightThemeWhiteColour,
              darkModeColour: Colours.darkThemeDarkSharpColour,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: product.productExists
                    ? () => goToProductPage(GoRouter.of(context))
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xfff0f0f0),
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(product.productImage),
                        ),
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.headingMedium4
                                .adaptiveColour(context),
                          ),
                          const Gap(5),
                          Text(
                            '\$${product.productPrice.toStringAsFixed(2)}',
                            style: TextStyles.headingMedium4
                                .adaptiveColour(context),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colours.lightThemeSecondaryColour,
                    ),
                    onPressed: removeFromWishlist,
                    child: const Text(
                      'Remove',
                      style: TextStyles.headingMedium4,
                    ),
                  ).loading(
                    wishlistAdapter is RemovingFromWishlist &&
                        product.productExists,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: product.productOutOfStock
                          ? Colors.grey
                          : Colours.lightThemeSecondaryColour,
                      foregroundColor: Colours.lightThemeWhiteColour,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: addToCart,
                    child: Text(
                      product.productOutOfStock
                          ? 'OUT OF STOCK'
                          : 'ADD TO CART',
                    ),
                  ).loading(
                    productAdapter is FetchingProduct ||
                        cartAdapter is AddingToCart,
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!product.productExists) ...[
          const Gap(10),
          Text(
            'Product no longer exists. Delete it to free up your wishlist.',
            style: TextStyles.paragraphSubTextRegular2.adaptiveColour(context),
          ),
          const Gap(10),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colours.lightThemeSecondaryColour,
              foregroundColor: Colours.lightThemeWhiteColour,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: removeFromWishlist,
            child: const Text('REMOVE'),
          ).loading(wishlistAdapter is RemovingFromWishlist),
        ],
      ],
    );
  }
}
