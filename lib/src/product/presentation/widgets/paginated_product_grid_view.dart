import 'package:compair_hub/core/common/widgets/classic_product_tile.dart';
import 'package:compair_hub/core/common/widgets/empty_data.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/constants/network_constants.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:compair_hub/src/product/presentation/app/category_notifier/category_notifier.dart';
import 'package:compair_hub/src/product/presentation/app/parish_notifier/parish_notifier.dart';
import 'package:compair_hub/src/product/presentation/views/product_edit_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PaginatedProductGridView extends ConsumerStatefulWidget {
  const PaginatedProductGridView({
    required this.productAdapterFamilyKey,
    this.parishFamilyKey,
    this.categoryFamilyKey,
    required this.fetchRequest,
    this.categorized = true,
    this.isEditMode = false,
    super.key,
  }) : assert(
          !categorized || (categorized && categoryFamilyKey != null),
          'Category family key cannot be null in a "Categorized" products view',
        );

  final GlobalKey productAdapterFamilyKey;
  final GlobalKey? categoryFamilyKey;
  final GlobalKey? parishFamilyKey;
  final ValueChanged<int> fetchRequest;
  final bool categorized;
  final bool isEditMode;

  @override
  ConsumerState<PaginatedProductGridView> createState() =>
      _PaginatedProductGridView();
}

class _PaginatedProductGridView
    extends ConsumerState<PaginatedProductGridView> {
  final pageController = PagingController<int, Product>(firstPageKey: 1);
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    pageController.addPageRequestListener((pageKey) {
      currentPage = pageKey;
      CoreUtils.postFrameCall(() => widget.fetchRequest(pageKey));
    });

    ref.listenManual(
      productAdapterProvider(widget.productAdapterFamilyKey),
      (previous, next) {
        if (next is ProductError) {
          pageController.error = next.message;
          // redundant
          CoreUtils.showSnackBar(
            context,
            message: '${next.message}\nPULL TO REFRESH',
          );
        } else if (next is ProductsFetched) {
          final products = next.products;
          final isLastPage = products.length < NetworkConstants.pageSize;
          if (isLastPage) {
            pageController.appendLastPage(products);
          } else {
            final nextPage = currentPage + 1;
            pageController.appendPage(products, nextPage);
          }
        }
      },
    );

    ref.listenManual(
      categoryNotifierProvider(widget.categoryFamilyKey),
      (previous, next) {
        pageController.refresh();
      },
    );

    if (widget.parishFamilyKey != null) {
      ref.listenManual(parishNotifierProvider(widget.parishFamilyKey),
          (prev, next) {
        pageController.refresh();
      });
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _handleProductTap(Product product) {
    if (widget.isEditMode) {
      print('Clicked ');
      //Navigate to edit page
      context.push(
        ProductEditView.path,
        extra: product,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final category =
        ref.watch(categoryNotifierProvider(widget.categoryFamilyKey));

    return RefreshIndicator.adaptive(
      onRefresh: () => Future.sync(
        () => pageController.refresh(),
      ),
      child: PagedMasonryGridView<int, Product>.count(
        pagingController: pageController,
        crossAxisCount: 2,
        builderDelegate: PagedChildBuilderDelegate<Product>(
          itemBuilder: (context, product, index) => Stack(
            children: [
              // If it is not in edit mode (coming from profileView page) then Let ClassicProductTile handle navigation
              if (!widget.isEditMode)
                Center(
                  child: ClassicProductTile(product),
                )
              else
                // If it is coming from the ProfileView Page (Is in edit mode), then Wrap with our GestureDetector and disable inner one (Classic Product Tile gesture detecture)
                InkWell( //Inkwell works better with scrollable views than a regular gesture detecture.
                  onTap: () => _handleProductTap(product),
                  child: Center(
                    child: IgnorePointer(
                      // Prevents ClassicProductTile's GestureDetector from firing. Just in case, as we added a fail safe in the handle product tap method
                      child: ClassicProductTile(
                        product,
                        isEditMode: widget.isEditMode,
                      ),
                    ),
                  ),
                ),

              //Edit Overlay
              if (widget.isEditMode)
                Positioned(
                  top: 5,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colours.lightThemePrimaryColour,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          firstPageProgressIndicatorBuilder: (_) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colours.lightThemePrimaryColour,
              ),
            );
          },
          newPageProgressIndicatorBuilder: (_) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colours.lightThemePrimaryColour,
              ),
            );
          },
          noItemsFoundIndicatorBuilder: (_) {
            final categorySelected =
                widget.categorized && category.name?.toLowerCase() != 'all';
            return Center(
              child: EmptyData(
                categorySelected
                    ? 'No products found for this category'
                    : 'No products found',
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            );
          },
          firstPageErrorIndicatorBuilder: (context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Something went wrong. Please try again.',
                    style: TextStyles.paragraphSubTextRegular2
                        .adaptiveColour(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => pageController.refresh(),
                    child: Text(
                      'Retry',
                      style: TextStyles.paragraphSubTextRegular2
                          .adaptiveColour(context),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
