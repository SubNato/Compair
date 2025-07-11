import 'package:compair_hub/src/home/presentation/sections/categories_section.dart';
import 'package:compair_hub/src/home/presentation/sections/home_app_bar.dart';
import 'package:compair_hub/src/home/presentation/sections/products_section.dart';
import 'package:compair_hub/src/home/presentation/sections/search_section.dart';
import 'package:compair_hub/src/home/presentation/widgets/promo_banner.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const path = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Gap(40),
            SearchSection(
              onTap: () {
                // TODO(Search): Push to search screen
              },
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
                      // TODO(Products): Push to Popular Products View
                    },
                  ),
                  const Gap(20),
                  ProductsSection.newArrivals(
                    onViewAll: () {
                      // TODO(Products): Push to New Arrivals Products View
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
