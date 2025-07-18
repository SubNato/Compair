import 'package:compair_hub/core/common/widgets/app_bar_bottom.dart';
import 'package:compair_hub/core/common/widgets/search_button.dart';
import 'package:compair_hub/src/product/domain/entities/category.dart';
import 'package:compair_hub/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:compair_hub/src/product/presentation/widgets/paginated_product_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategorizedProductsView extends ConsumerStatefulWidget {
  const CategorizedProductsView(this.category, {super.key});

  final ProductCategory category;

  @override
  ConsumerState createState() => _CategorizedProductsViewState();
}

class _CategorizedProductsViewState
    extends ConsumerState<CategorizedProductsView> {
  final familyKey = GlobalKey();

  Future<void> getProducts(int page) async {
    return ref
        .read(productAdapterProvider(familyKey).notifier)
        .getProductsByCategory(
          categoryId: widget.category.id,
          page: page,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name!),
        bottom: const AppBarBottom(),
        actions: const [SearchButton(padding: EdgeInsets.only(right: 10))],
      ),
      body: SafeArea(
        child: PaginatedProductGridView(
          productAdapterFamilyKey: familyKey,
          fetchRequest: getProducts,
          categorized: false,
        ),
      ),
    );
  }
}
