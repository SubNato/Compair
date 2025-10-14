import 'package:compair_hub/core/common/app/riverpod/current_user_provider.dart';
import 'package:compair_hub/core/common/widgets/bottom_sheet.dart';
import 'package:compair_hub/src/home/presentation/sections/categories_section.dart';
import 'package:compair_hub/src/home/presentation/sections/home_app_bar.dart';
import 'package:compair_hub/src/home/presentation/sections/products_section.dart';
import 'package:compair_hub/src/home/presentation/sections/search_section.dart';
import 'package:compair_hub/src/home/presentation/widgets/promo_banner.dart';
import 'package:compair_hub/src/product/presentation/views/all_new_arrivals_view.dart';
import 'package:compair_hub/src/product/presentation/views/all_popular_products_view.dart';
import 'package:compair_hub/src/product/presentation/views/search_view.dart';
import 'package:compair_hub/core/common/widgets/custom_floating_action_button.dart';
import 'package:compair_hub/src/upload/category/presentation/views/category_upload_view.dart';
import 'package:compair_hub/src/upload/product/presentation/views/upload_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Gap(40),
                  SearchSection(
                    readOnly: true,
                    onTap: () => context.push(SearchView.path),
                  ),
                  const Gap(20),
                  Expanded(
                    child: ListView(
                      children: [
                        const PromoBanner(),
                        const Gap(20),
                        const CategoriesSection(),
                        const Gap(20),
                        ProductsSection.popular(
                          onViewAll: () {
                            context.go(
                              '${HomeView.path}/${AllPopularProductsView.path}',
                            );
                          },
                        ),
                        const Gap(20),
                        ProductsSection.newArrivals(
                          onViewAll: () {
                            context.go(
                              '${HomeView.path}/${AllNewArrivalsView.path}',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if(currentUser!.isBusiness || currentUser!.isAdmin) Padding(
              padding: const EdgeInsets.fromLTRB(0.0,0.0,0.00,10.0),
              child: Align(
                // height: 60,
                // bottom: 200,
                alignment: Alignment.bottomCenter,
                child: CustomFloatingActionButton( //TODO: Fix all buttons in ALL upload sections. Let them switch colors when go into dark mode.
                  onPressed: () {
                    currentUser.isAdmin ? showAdminOptions(
                    context: context,
                      onUploadProduct: () => context.push(UploadView.path),
                      onUploadCategory: () => context.push(CategoryUploadView.path),
                    ) : context.push(UploadView.path);
                  },
                  icon: const Icon(Icons.add),
                ),
              ),
            ), //Height = 10 as a custom figure
          ],
      ),
    );
  }
}
