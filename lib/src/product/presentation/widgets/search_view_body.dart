import 'package:compair_hub/core/common/widgets/classic_product_tile.dart';
import 'package:compair_hub/core/common/widgets/empty_data.dart';
import 'package:compair_hub/core/extensions/context_extensions.dart';
import 'package:compair_hub/core/res/media.dart';
import 'package:compair_hub/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class SearchViewBody extends ConsumerWidget {
  const SearchViewBody({
    required this.productAdapterFamilyKey,
    super.key,
  });

  final GlobalKey productAdapterFamilyKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAdapter = ref.watch(
      productAdapterProvider(productAdapterFamilyKey),
    );
    if (productAdapter is Searching) {
      return Center(child: Lottie.asset(Media.searching));
    } else if (productAdapter case ProductsFetched(:final products)) {
      if (products.isEmpty) {
        return const Center(child: EmptyData('No Products Found'));
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SingleChildScrollView(
          child: Center(
            child: Wrap(
              runSpacing: 10,
              runAlignment: WrapAlignment.center,
              spacing: 10,
              children: products.map(ClassicProductTile.new).toList(),
            ),
          ),
        ),
      );
    } else if (productAdapter is ProductError) {
      return const EmptyData('No Products Found');
    }
    return Center(
      child: Lottie.asset(
        context.isDarkMode ? Media.search : Media.searchLight,
      ),
    );
  }
}
