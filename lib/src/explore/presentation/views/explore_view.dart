import 'package:compair_hub/core/common/widgets/app_bar_bottom.dart';
import 'package:compair_hub/core/common/widgets/menu_icon.dart';
import 'package:compair_hub/core/common/widgets/search_button.dart';
import 'package:compair_hub/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:compair_hub/src/product/presentation/app/category_notifier/category_notifier.dart';
import 'package:compair_hub/src/product/presentation/widgets/category_selector.dart';
import 'package:compair_hub/src/product/presentation/widgets/paginated_product_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  static const path = '/explore';

  @override
  ConsumerState<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final productAdapterFamilyKey = GlobalKey();
  final categoryFamilyKey = GlobalKey();

  Future<void> getProducts(
      int page,
      ) async {
    final category = ref.watch(categoryNotifierProvider(categoryFamilyKey));
    final productAdapterNotifier =
    ref.read(productAdapterProvider(productAdapterFamilyKey).notifier);
    if (category.name?.toLowerCase() == 'all') {
      return productAdapterNotifier.getProducts(page);
    }
    return productAdapterNotifier.getProductsByCategory(
      page: page,
      categoryId: category.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        leading: const MenuIcon(),
        bottom: const AppBarBottom(),
        actions: const [SearchButton(padding: EdgeInsets.only(right: 10))],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 30),
              child: CategorySelector(
                categoryNotifierFamilyKey: categoryFamilyKey,
              ),
            ),
            const Gap(20),
            Expanded(
              child: PaginatedProductGridView(
                productAdapterFamilyKey: productAdapterFamilyKey,
                categoryFamilyKey: categoryFamilyKey,
                fetchRequest: getProducts,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
