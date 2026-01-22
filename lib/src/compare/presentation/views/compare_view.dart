import 'package:compair_hub/core/common/widgets/compair_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:compair_hub/core/extensions/context_extensions.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/presentation/app/adapter/product_adapter.dart';

//Top to bottom
class CompareView extends ConsumerStatefulWidget {
  const CompareView({
    super.key,
    required this.currentProduct,
  });

  final Product currentProduct;

  @override
  ConsumerState<CompareView> createState() => _CompareViewState();
}

class _CompareViewState extends ConsumerState<CompareView>
    with TickerProviderStateMixin {
  final productAdapterFamilyKey = GlobalKey();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();

    // Fetch related products
    CoreUtils.postFrameCall(() {
      ref
          .read(productAdapterProvider(productAdapterFamilyKey).notifier)
          .searchByCategory(
            query: '',
            categoryId: widget.currentProduct.category.id,
            page: 1,
          );
    });

    ref.listenManual(
      productAdapterProvider(productAdapterFamilyKey),
      (previous, next) {
        if (next case ProductError(:final message)) {
          CoreUtils.showSnackBar(context, message: message);
        }
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _closeModal() async {
    await _animationController.reverse();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final relatedProductsState = ref.watch(
      productAdapterProvider(productAdapterFamilyKey),
    );

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Container(
          color: Colors.black.withOpacity(0.5 * _fadeAnimation.value),
          child: Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                margin: const EdgeInsets.all(20),
                height: context.height * 0.9,
                decoration: BoxDecoration(
                  color: CoreUtils.adaptiveColour(
                    context,
                    lightModeColour: Colours.lightThemeWhiteColour,
                    darkModeColour: Colours.darkThemeDarkNavBarColour,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colours.lightThemePrimaryColour.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: _closeModal,
                            icon: const Icon(Icons.close),
                            style: IconButton.styleFrom(
                              iconSize: 30,
                              foregroundColor: Colours.lightThemePrimaryColour,
                            ),
                          ),
                          const Gap(5),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CompairLogo(
                                  style: TextStyles.headingSemiBold.copyWith(
                                    color: CoreUtils.adaptiveColour(
                                      context,
                                      lightModeColour:
                                          Colours.lightThemePrimaryColour,
                                      darkModeColour:
                                          Colours.lightThemePrimaryTint,
                                    ),
                                  ),
                                ),
                                // Text(
                                //   'Compare Products',
                                //   style: TextStyles.headingMedium3
                                //       .adaptiveColour(context),
                                //   overflow: TextOverflow.fade,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content - Changed to Column layout (top/bottom)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Current Product (Top Section)
                            Expanded(
                              flex: 2, // More space for current product
                              child: _CurrentProductCard(
                                product: widget.currentProduct,
                              ),
                            ),

                            const Gap(16),

                            // Horizontal Divider
                            Container(
                              width: double.infinity,
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colours.lightThemePrimaryColour
                                        .withOpacity(0.1),
                                    Colours.lightThemePrimaryColour
                                        .withOpacity(0.3),
                                    Colours.lightThemePrimaryColour
                                        .withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),

                            const Gap(16),

                            // Related Products (Bottom Section)
                            Expanded(
                              flex: 2, // Less space for related products list
                              child: _RelatedProductsList(
                                relatedProductsState: relatedProductsState,
                                currentProductId: widget.currentProduct.id,
                                onProductTap: (product) {
                                  Navigator.of(context).pop();
                                  context.push(
                                      '/products/${product.id}',
                                    extra: {'fromCompare': true},
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CurrentProductCard extends StatelessWidget {
  const _CurrentProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colours.lightThemePrimaryColour.withOpacity(0.05),
            Colours.lightThemePrimaryColour.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colours.lightThemePrimaryColour.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with badge and favorite
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.keyboard_double_arrow_down_outlined,
                color: Colours.lightThemePrimaryColour.withOpacity(0.7),
                size: 24,
              ),
              const Gap(8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colours.lightThemePrimaryColour,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'CURRENT PRODUCT',
                  style: TextStyles.paragraphSubTextRegular2.white,
                ),
              ),
            ],
          ),

          const Gap(10),

          // Main content in vertical layout for better space utilization
          Expanded(
            child: Column(
              children: [
                // Product Image (larger)
                Expanded(
                  flex: 2,
                  child: AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      //height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: context.isDarkMode
                            ? Colors.grey[850]
                            : const Color(0xfff0f0f0),
                        image: DecorationImage(
                          image: NetworkImage(product.image),
                          fit: BoxFit.contain,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Gap(1),

                // Product Info
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        product.name,
                        style: TextStyles.headingMedium4
                            .adaptiveColour(context)
                            .copyWith(
                              fontSize: 19,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                      ),
                      const Gap(1),
                      //it was here
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colours.lightThemeYellowColour,
                            size: 20,
                          ),
                          const Gap(6),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: TextStyles.headingMedium4
                                .adaptiveColour(context).copyWith(fontSize: 15),
                          ),
                          const Gap(15),
                          Flexible(
                            child: Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.headingMedium.copyWith(
                                fontSize: 20,
                                color: Colours.lightThemePrimaryColour,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //const Gap(16),
                      // Category badge
                      // Container(
                      //   padding: const EdgeInsets.symmetric(
                      //     horizontal: 12,
                      //     vertical: 6,
                      //   ),
                      //   decoration: BoxDecoration(
                      //     color: Colours.lightThemePrimaryColour.withOpacity(0.1),
                      //     borderRadius: BorderRadius.circular(20),
                      //     border: Border.all(
                      //       color: Colours.lightThemePrimaryColour.withOpacity(0.3),
                      //     ),
                      //   ),
                      //   child: Text(
                      //     product.category.name ?? 'Uncategorized',
                      //     style: TextStyles.paragraphSubTextRegular3.copyWith(
                      //       color: Colours.lightThemePrimaryColour,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RelatedProductsList extends StatelessWidget {
  const _RelatedProductsList({
    required this.relatedProductsState,
    required this.currentProductId,
    required this.onProductTap,
  });

  final dynamic relatedProductsState;
  final String currentProductId;
  final Function(Product) onProductTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.compare_arrows,
              color: Colours.lightThemePrimaryColour.withOpacity(0.7),
              size: 24,
            ),
            const Gap(8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colours.lightThemeSecondaryColour,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'SIMILAR PRODUCTS',
                style: TextStyles.paragraphSubTextRegular2.white,
              ),
            ),
            const Gap(5),
          ],
        ),
        const Gap(16),

        // Products list
        Expanded(
          child: Builder(
            builder: (context) {
              if (relatedProductsState is FetchingProduct) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colours.lightThemePrimaryColour,
                  ),
                );
              } else if (relatedProductsState
                  case ProductsFetched(:final products)) {
                final filteredProducts = products
                    .where((product) => product.id != currentProductId)
                    .toList()
                    ..shuffle();

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const Gap(16),
                        Text(
                          'No Similar Products Found',
                          style: TextStyles.paragraphRegular.grey,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),
                  );
                }

                // Use horizontal scrolling for better space utilization
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: filteredProducts.map((product) {
                      final isLast = product == filteredProducts.last;
                      return Padding(
                        padding: EdgeInsets.only(
                          right: isLast ? 0 : 16,
                        ),
                        child: SizedBox(
                          width: 280, // Fixed width for horizontal scrolling
                          child: _RelatedProductItem(
                            product: product,
                            onTap: () => onProductTap(product),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}

class _RelatedProductItem extends StatelessWidget {
  const _RelatedProductItem({
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CoreUtils.adaptiveColour(
              context,
              lightModeColour: Colours.lightThemeWhiteColour,
              darkModeColour: Colours.darkThemeDarkSharpColour,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product Image
              Expanded(
                flex: 3,
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: Container(
                    //width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: context.isDarkMode
                          ? Colors.grey[850]
                          : const Color(0xfff0f0f0),
                      image: DecorationImage(
                        image: NetworkImage(product.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              const Gap(12),

              // Product Info
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(5),
                        Text(
                          product.name,
                          style:
                              TextStyles.headingMedium4.adaptiveColour(context),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ],
                    ),

                    // Rating and action
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colours.lightThemeYellowColour,
                          size: 14,
                        ),
                        const Gap(4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: TextStyles.paragraphSubTextRegular2.grey.copyWith(fontSize: 15),
                        ),
                        const Gap(15),
                        Flexible(
                          child: Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.headingMedium3.copyWith(
                              color: Colours.lightThemePrimaryColour,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
