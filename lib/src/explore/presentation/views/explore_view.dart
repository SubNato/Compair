import 'package:compair_hub/core/common/widgets/app_bar_bottom.dart';
import 'package:compair_hub/core/common/widgets/menu_icon.dart';
import 'package:compair_hub/core/common/widgets/search_button.dart';
import 'package:compair_hub/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:compair_hub/src/product/presentation/app/category_notifier/category_notifier.dart';
import 'package:compair_hub/src/product/presentation/app/provider/product_type_notifier.dart';
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

  @override
  void initState() {
    super.initState();

    ref.listenManual(productTypeNotifierProvider,
        (previous, next) {
      if(previous != next) {
        //When the product type changes, trigger the refresh
        setState(() {

        });
      }
    });
  }

  Future<void> getProducts(
      int page,
      ) async {
    final category = ref.watch(categoryNotifierProvider(categoryFamilyKey));
    final productAdapterNotifier =
    ref.read(productAdapterProvider(productAdapterFamilyKey).notifier);
    final productType = ref.watch(productTypeNotifierProvider);

    if (category.name?.toLowerCase() == 'all') {
      return productAdapterNotifier.getProducts(page, type: productType.queryParam);
    }
    return productAdapterNotifier.getProductsByCategory(
      page: page,
      categoryId: category.id,
      type: productType.queryParam,
    );
  }

  @override
  Widget build(BuildContext context) {
    //Watch the product type to ensure rebuild when the type changes
    final productType = ref.watch(productTypeNotifierProvider);
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
                key: ValueKey('category-$productType'),
                categoryNotifierFamilyKey: categoryFamilyKey,
              ),
            ),
            const Gap(20),
            Expanded(
              child: PaginatedProductGridView(
                //The product Type is the key that forces the rebuild whenever the type changes
                key: ValueKey(productType),
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
