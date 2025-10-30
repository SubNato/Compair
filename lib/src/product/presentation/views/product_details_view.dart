import 'package:carousel_slider/carousel_slider.dart';
import 'package:compair_hub/core/common/singletons/cache.dart';
import 'package:compair_hub/core/common/widgets/app_bar_bottom.dart';
import 'package:compair_hub/core/common/widgets/custom_floating_action_button.dart';
import 'package:compair_hub/core/common/widgets/expandable_text.dart';
import 'package:compair_hub/core/common/widgets/favourite_icon.dart';
import 'package:compair_hub/core/common/widgets/rounded_button.dart';
import 'package:compair_hub/core/extensions/context_extensions.dart';
import 'package:compair_hub/core/extensions/int_extensions.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/extensions/widget_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/src/cart/data/models/cart_product_model.dart';
import 'package:compair_hub/src/cart/domain/entities/cart_product.dart';
import 'package:compair_hub/src/cart/presentation/app/adapter/cart_provider.dart';
import 'package:compair_hub/src/compare/presentation/utils/compare_tracker.dart';
import 'package:compair_hub/src/compare/presentation/views/compare_view.dart';
import 'package:compair_hub/src/home/presentation/widgets/reactive_cart_icon.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/features/review/presentation/widgets/reviews_preview.dart';
import 'package:compair_hub/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:compair_hub/src/product/presentation/widgets/colour_palette.dart';
import 'package:compair_hub/src/product/presentation/widgets/size_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ProductDetailsView extends ConsumerStatefulWidget {
  const ProductDetailsView(this.productId,
      {super.key, this.fromCompare = false});

  final String productId;
  final bool fromCompare;

  @override
  ConsumerState<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends ConsumerState<ProductDetailsView> {
  final productAdapterFamilyKey = GlobalKey();
  final cartAdapterFamilyKey = GlobalKey();

  String? selectedSize;
  Color? selectedColour;

  @override
  void initState() {
    super.initState();

    if (widget.fromCompare) {
      CompareTracker.increment();
    } else {
      CompareTracker.reset();
    }

    CoreUtils.postFrameCall(() {
      final userId = Cache.instance.userId!;
      ref
          .read(productAdapterProvider(productAdapterFamilyKey).notifier)
          .getProduct(widget.productId);
      ref
          .read(cartAdapterProvider(cartAdapterFamilyKey).notifier)
          .getCart(userId);
    });

    ref.listenManual(
      productAdapterProvider(productAdapterFamilyKey),
      (previous, next) {
        if (next case ProductError(:final message)) {
          CoreUtils.showSnackBar(context, message: message);
          CoreUtils.postFrameCall(() {
            // This is done because the network_utils.dart calls pop when
            // there's 401 token revocation. If that happens while someone is
            // opening this page, it'll already have popped and this pop will
            // throw a "nothing to pop" error.
            if (context.canPop()) context.pop();
          });
        }
      },
    );

    ref.listenManual(
      cartAdapterProvider(cartAdapterFamilyKey),
      (previous, next) {
        if (next case CartError(:final message)) {
          CoreUtils.showSnackBar(context, message: message);
        }
        if (next is AddedToCart) {
          CoreUtils.showSnackBar(
            context,
            message: 'Product added to cart',
            backgroundColour: Colors.green,
          );
        }
        if (next is AddedToCart) {
          CoreUtils.showSnackBar(context,
              message: 'Product added to Cart', backgroundColour: Colors.green);
          ref
              .read(cartAdapterProvider(cartAdapterFamilyKey).notifier)
              .getCart(Cache.instance.userId!);
        }
      },
    );
  }

  //Modal for compare function
  void _showCompareModal(Product product) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Compare Products',
      pageBuilder: (context, animation, secondaryAnimation) {
        return CompareView(currentProduct: product);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(
      productAdapterProvider(productAdapterFamilyKey),
    );
    final cartState = ref.watch(cartAdapterProvider(cartAdapterFamilyKey));
    List<CartProduct> cartItems = [];

    if (cartState is CartFetched) {
      cartItems = cartState.cart;
    }

    bool isInCart = cartItems.any((item) => item.productId == widget.productId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        bottom: const AppBarBottom(),
        actions: [
          if (productState is ProductFetched)
            FavouriteIcon(productId: productState.product.id),
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: ReactiveCartIcon(),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        if (productState is FetchingProduct) {
          return const Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Colours.lightThemePrimaryColour,
            ),
          );
        } else if (productState case ProductFetched(:final product)) {
          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Builder(builder: (context) {
                          var images = product.images;
                          if (images.isEmpty) images = [product.image];
                          return CarouselSlider(
                            options: CarouselOptions(
                              height: context.height * .4,
                              autoPlay: images.length > 1,
                              viewportFraction: 1,
                              enlargeCenterPage: true,
                            ),
                            items: images.map((image) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: context.width,
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff0f0f0),
                                      image: DecorationImage(
                                        image: NetworkImage(image),
                                        // fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.all(20).copyWith(bottom: 2),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      product.name,
                                      style: TextStyles.headingMedium4
                                          .adaptiveColour(context),
                                    ),
                                  ),
                                  const Gap(10),
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: TextStyles.headingMedium1.orange,
                                  ),
                                ],
                              ),
                              const Gap(5),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    color: Colours.lightThemeYellowColour,
                                    size: 11,
                                  ),
                                  const Gap(3),
                                  Text(
                                    product.rating.toStringAsFixed(1),
                                    style: TextStyles.paragraphSubTextRegular2
                                        .adaptiveColour(context),
                                  ),
                                  Text(
                                    ' ('
                                    '${product.numberOfReviews.pluralizeReviews}'
                                    ')',
                                    style: const TextStyle(
                                      color:
                                          Colours.lightThemeSecondaryTextColour,
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(15),
                            ],
                          ),
                        ),
                        Divider(
                          color: CoreUtils.adaptiveColour(
                            context,
                            darkModeColour: Colours.darkThemeDarkSharpColour,
                            lightModeColour: Colors.white,
                          ),
                        ),
                        const Gap(10),
                        Padding(
                          padding: const EdgeInsets.all(20).copyWith(top: 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (product.colours.isNotEmpty)
                                ColourPalette(
                                  colours: product.colours,
                                  canScroll: true,
                                  radius: 15,
                                  spacing: 10,
                                  padding: const EdgeInsets.all(5),
                                  onSelect: (colour) {
                                    selectedColour = colour;
                                  },
                                ),
                              if (product.sizes.isNotEmpty) ...[
                                const Gap(15),
                                SizePicker(
                                  sizes: product.sizes,
                                  radius: 28,
                                  canScroll: true,
                                  spacing: 8,
                                  onSelect: (size) {
                                    selectedSize = size;
                                  },
                                ),
                              ],
                              const Gap(20),
                              Text(
                                'Description',
                                style: TextStyles.headingMedium3
                                    .adaptiveColour(context),
                              ),
                              const Gap(5),
                              ExpandableText(
                                context,
                                text: product.description,
                                style: TextStyles.paragraphRegular.grey,
                              ),
                              const Gap(20),
                              ReviewsPreview(product: product),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // //Check teh user's cart products to check to see if
                  // // that product is already in the cart then
                  // //display the appropriate button
                  //
                  // final cartProductState = ref.watch(cartAdapterProvider(cartAdapterFamilyKey));
                  //
                  // bool isInCart = false;
                  // if(cartProductState is CartFetched) {
                  // isInCart = cartProductState.cart.any((CartProduct) => CartProduct.id == productState.product.id);
                  // }

                  //Add to Cart button
                  Padding(
                    //Wrap an icon infront of it
                    padding: const EdgeInsets.all(20).copyWith(bottom: 40),
                    child: isInCart
                        ? RoundedButton(
                            height: 50,
                            onPressed: null,
                            backgroundColour: Colors.green.withOpacity(0.8),
                            text: 'Already In Cart',
                            textStyle: TextStyles.buttonTextHeadingSemiBold
                                .copyWith(fontSize: 16)
                                .white,
                            cart: true,
                          )
                        : RoundedButton(
                            height: 50,
                            onPressed: () {
                              if (product.colours.isNotEmpty &&
                                  selectedColour == null) {
                                CoreUtils.showSnackBar(
                                  context,
                                  message: 'Pick a colour',
                                  backgroundColour: Colors.red.withOpacity(.8),
                                );
                                return;
                              } else if (product.sizes.isNotEmpty &&
                                  selectedSize == null) {
                                CoreUtils.showSnackBar(
                                  context,
                                  message: 'Pick a size',
                                  backgroundColour: Colors.red.withOpacity(.8),
                                );
                                return;
                              }
                              ref
                                  .read(
                                    cartAdapterProvider(cartAdapterFamilyKey)
                                        .notifier,
                                  )
                                  .addToCart(
                                    userId: Cache.instance.userId!,
                                    cartProduct:
                                        const CartProductModel.empty().copyWith(
                                      productId: product.id,
                                      quantity: 1,
                                      selectedSize: selectedSize,
                                      selectedColour: selectedColour,
                                    ),
                                  );
                            },
                            text: 'Add to Cart',
                            textStyle: TextStyles.buttonTextHeadingSemiBold
                                .copyWith(fontSize: 16)
                                .white,
                          ).loading(cartState is AddingToCart),
                  ),
                ],
              ),
              //Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                //children: [
                  Positioned(
                    bottom: 105,
                    right: /*(widget.fromCompare && CompareTracker.count >= 3)
                        ? 90
                        :*/ 0,
                    left: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        //Align(
                          //alignment: Alignment.center,
                          /*child:*/ CustomFloatingActionButton(
                            //height: 110,
                            heroTag: 'compare_fab_${widget.productId}',
                            onPressed: () {
                              print(
                                  "+++++++++++++++++++++++ UPLOAD button alone was pressed G++++++++++++++++++++++");
                              _showCompareModal(product);
                            },
                            icon: const Icon(Icons.compare_arrows_outlined),
                            cart: isInCart ? true : false,
                          ),
                        //),
                        const Gap(15),
                        if (widget.fromCompare && CompareTracker.count >= 3)
                          AnimatedOpacity(
                            opacity:
                                widget.fromCompare && CompareTracker.count >= 3
                                    ? 1
                                    : 0,
                            duration: const Duration(milliseconds: 800),
                            child: CustomFloatingActionButton(
                              height: 10,
                              heroTag: 'home_fab_${widget.productId}',
                              //unique key for buttons
                              onPressed: () {
                                print(
                                    "+++++++++++++++++++++++ Home button alone was pressed G++++++++++++++++++++++");
                                CompareTracker.reset();
                                context.go('/home');
                              },
                              icon: const Icon(
                                Icons.home,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                //],
              //),

              //Home button for compare view
              // if (widget.fromCompare && CompareTracker.count >= 3)
              //   Positioned(
              //     bottom: 120,
              //     right: 20,
              //     left: widget.fromCompare ? 90 : 0,
              //     child: AnimatedOpacity(
              //       opacity:
              //           widget.fromCompare && CompareTracker.count >= 3 ? 1 : 0,
              //       duration: const Duration(milliseconds: 800),
              //       child: CustomFloatingActionButton(
              //         height: 10,
              //         heroTag: 'home_fab_${widget.productId}',
              //         //unique key for buttons
              //         onPressed: () {
              //           print(
              //               "+++++++++++++++++++++++ Home button alone was pressed G++++++++++++++++++++++");
              //           CompareTracker.reset();
              //           context.go('/home');
              //         },
              //         icon: const Icon(
              //           Icons.home,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   )
            ],
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}

// The compare button:
/*Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: CustomFloatingActionButton(
                    onPressed: () => _showCompareModal(product),
                    icon: const Icon(Icons.compare_arrows_outlined),
                  ),
                ),
              ),*/
