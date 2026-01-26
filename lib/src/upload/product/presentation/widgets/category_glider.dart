import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/src/product/domain/entities/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryGlider extends StatelessWidget {
  const CategoryGlider({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelectCategory,
    this.scrollController,
  });

  final List<ProductCategory> categories;
  final String selectedCategoryId;
  final ValueChanged<String> onSelectCategory;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.transparent,
              Colors.black,
              Colors.black,
              Colors.transparent,
            ],
            stops: [0.0, 0.05, 0.95, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn, // Keeps overlapping parts
        child: ListView.separated(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final category = categories[index];
            return ChoiceChip(
              label: Text(category.name!),
              selected: selectedCategoryId == category.id,
              selectedColor: Colours.lightThemePrimaryColour,
              onSelected: (_) => onSelectCategory(category.id),
            );
          },
        ),
      ),
    );
  }
}
