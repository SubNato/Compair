import 'package:compair_hub/core/common/widgets/rounded_button.dart';
import 'package:compair_hub/core/extensions/context_extensions.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/extensions/widget_extensions.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/src/cart/data/models/cart_product_model.dart';
import 'package:compair_hub/src/cart/domain/entities/cart_product.dart';
import 'package:compair_hub/src/cart/presentation/app/adapter/cart_provider.dart';
import 'package:compair_hub/src/cart/presentation/app/cart_product_notifier/cart_product_notifier.dart';
import 'package:compair_hub/src/cart/presentation/views/checkout_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutButton extends ConsumerStatefulWidget {
  const CheckoutButton({required this.products, required this.quantityNotifier, super.key});

  final List<CartProduct> products;
  final ValueNotifier<Map<String, int>> quantityNotifier;

  @override
  ConsumerState createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends ConsumerState<CheckoutButton> {
  final cartAdapterFamilyKey = GlobalKey();
  final quantityUpdateNotifier = ValueNotifier<int?>(null);

  @override
  void initState() {
    super.initState();
    ref.listenManual(
      cartAdapterProvider(cartAdapterFamilyKey),
          (previous, next) {
        if (next case CheckoutInitiated(:final stripeCheckoutSessionUrl)) {
          debugPrint('-------------INITIATING CHECKOUT-----------------');
          CoreUtils.postFrameCall(
                () async {
              if (defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS) {
                context.push(CheckoutView.path,
                    extra: stripeCheckoutSessionUrl);
              } else {
                if (!await launchUrl(Uri.parse(stripeCheckoutSessionUrl))) {
                  debugPrint('ERROR: Could not launch Stripe checkout url');
                  if (!mounted) return;
                  CoreUtils.showSnackBar(
                    context,
                    message: 'Error Occurred, '
                        'Please try again.\nIf issue persists, contact support.',
                  );
                }
              }
            },
          );
        } else if (next case CartError(:final message)) {
          CoreUtils.showSnackBar(context, message: message);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProductNotifier = ref.watch(cartProductNotifierProvider);
    final cartAdapter = ref.watch(cartAdapterProvider(cartAdapterFamilyKey));

    return ValueListenableBuilder<Map<String, int>>(
      valueListenable: widget.quantityNotifier,
      builder: (context, quantities, _) {
        final selectedProducts = widget.products.where(
              (product) => cartProductNotifier.contains(product.id),
        );

        double total = 0;
        final productsToUse = selectedProducts.isEmpty
            ? widget.products
            : selectedProducts;

        for (final product in productsToUse) {
          final updatedQuantity =
              quantities[product.id] ?? product.quantity;
          total += product.productPrice * updatedQuantity;
        }

        return Padding(
          padding: const EdgeInsets.all(20).copyWith(bottom: 40),
          child: RoundedButton(
            height: 50,
            onPressed: () {
              ref
                  .read(cartAdapterProvider(cartAdapterFamilyKey).notifier)
                  .initiateCheckout(
                theme: context.isDarkMode ? 'dark' : 'light',
                cartItems: productsToUse.map((p) {
                  final updatedQuantity =
                      quantities[p.id] ?? p.quantity;
                  return (p as CartProductModel).copyWith(quantity: updatedQuantity);
                }).toList(),
              );
            },
            text: 'Checkout (\$${total.toStringAsFixed(2)})',
            textStyle: TextStyles.buttonTextHeadingSemiBold
                .copyWith(fontSize: 16)
                .white,
          ).loading(cartAdapter is InitiatingCheckout),
        );
      },
    );
  }



/* @override
  Widget build(BuildContext context) {
    final cartProductNotifier = ref.watch(cartProductNotifierProvider);
    final cartAdapter = ref.watch(cartAdapterProvider(cartAdapterFamilyKey));
    //final productQuantityAdapter = ref.watch(provider)

    // return ValueListenableBuilder<Map<String, int>>(
    //   valueListenable: widget.quantityNotifier,
    //   builder: (context, quantities, _) {
    //     final selectedProducts = widget.products.where(
    //         (product) => cartProductNotifier.contains(product.id),
    //     );
    //   }
    // );

    final selectedProducts = widget.products.where(
          (product) => cartProductNotifier.contains(product.id),
    );
    double total = 0;
    if (cartProductNotifier.isEmpty) {
      total = widget.products.fold<double>(
        0,
            (value, product) => value + (product.productPrice * product.quantity),
      );
    } else {
      total = selectedProducts.fold<double>(
        0,
            (value, product) => value + (product.productPrice * quantityUpdateNotifier ? quantityUpdateNotifier.value!: product.quantity),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20).copyWith(bottom: 40),
      child: RoundedButton(
        height: 50,
        onPressed: () {
          ref
              .read(cartAdapterProvider(cartAdapterFamilyKey).notifier)
              .initiateCheckout(
            theme: context.isDarkMode ? 'dark' : 'light',
            cartItems: selectedProducts.isEmpty
                ? widget.products
                : selectedProducts.toList(),
          );
        },
        text: 'Checkout (\$${total.toStringAsFixed(2)})',
        textStyle: TextStyles.buttonTextHeadingSemiBold
            .copyWith(
          fontSize: 16,
        )
            .white,
      ).loading(cartAdapter is InitiatingCheckout),
    );
  }*/
}


/*
import 'package:compair_hub/core/common/widgets/rounded_button.dart';
import 'package:compair_hub/core/extensions/context_extensions.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/extensions/widget_extensions.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/src/cart/domain/entities/cart_product.dart';
import 'package:compair_hub/src/cart/presentation/app/adapter/cart_provider.dart';
import 'package:compair_hub/src/cart/presentation/app/cart_product_notifier/cart_product_notifier.dart';
import 'package:compair_hub/src/cart/presentation/views/checkout_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutButton extends ConsumerStatefulWidget {
  const CheckoutButton({required this.products, this.familyKey, super.key});

  final List<CartProduct> products;
  final GlobalKey? familyKey;

  @override
  ConsumerState createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends ConsumerState<CheckoutButton> {
  //final cartAdapterFamilyKey = GlobalKey();
  late final GlobalKey cartAdapterFamilyKey;

  @override
  void initState() {
    super.initState();

    cartAdapterFamilyKey = widget.familyKey ?? GlobalKey();

    ref.listenManual(
      cartAdapterProvider(cartAdapterFamilyKey),
      (previous, next) {
        if (next case CheckoutInitiated(:final stripeCheckoutSessionUrl)) {
          debugPrint('-------------INITIATING CHECKOUT-----------------');
          CoreUtils.postFrameCall(
            () async {
              if (defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS) {
                context.push(CheckoutView.path,
                    extra: stripeCheckoutSessionUrl);
              } else {
                if (!await launchUrl(Uri.parse(stripeCheckoutSessionUrl))) {
                  debugPrint('ERROR: Could not launch Stripe checkout url');
                  if (!mounted) return;
                  CoreUtils.showSnackBar(
                    context,
                    message: 'Error Occurred, '
                        'Please try again.\nIf issue persists, contact support.',
                  );
                }
              }
            },
          );
        } else if (next case CartError(:final message)) {
          CoreUtils.showSnackBar(context, message: message);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProductNotifier = ref.watch(cartProductNotifierProvider);
    final cartAdapter = ref.watch(cartAdapterProvider(cartAdapterFamilyKey));

    List<CartProduct> currentCart = [];
    if(cartAdapter case CartFetched(:final cart) || CartQuantityUpdate(:final cart)) {
      currentCart = cart;
    } else {
      currentCart = widget.products;
    }

    final selectedProducts = currentCart.where(
        (product) => cartProductNotifier.contains(product.id),
    );
    // widget.products.where(
    //   (product) => cartProductNotifier.contains(product.id),
    // );

    double total = 0;
    if (cartProductNotifier.isEmpty) {
      total = currentCart.fold<double>(//widget.products.fold<double>(
        0,
        (value, product) => value + (product.productPrice * product.quantity),
      );
    } else {
      total = selectedProducts.fold<double>(
        0,
        (value, product) => value + (product.productPrice * product.quantity),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20).copyWith(bottom: 40),
      child: RoundedButton(
        height: 50,
        onPressed: () {
          ref
              .read(cartAdapterProvider(cartAdapterFamilyKey).notifier)
              .initiateCheckout(
                theme: context.isDarkMode ? 'dark' : 'light',
                cartItems: selectedProducts.isEmpty
                    ? currentCart//widget.products
                    : selectedProducts.toList(),
              );
        },
        text: 'Checkout (\$${total.toStringAsFixed(2)})',
        textStyle: TextStyles.buttonTextHeadingSemiBold
            .copyWith(
              fontSize: 16,
            )
            .white,
      ).loading(cartAdapter is InitiatingCheckout),
    );
  }
}
*/