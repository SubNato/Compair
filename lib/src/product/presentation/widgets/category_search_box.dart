import 'dart:async';

import 'package:compair_hub/core/common/widgets/vertical_label_field.dart';
import 'package:compair_hub/src/product/domain/entities/category.dart';
import 'package:compair_hub/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:compair_hub/src/upload/product/presentation/app/category/category_adapter.dart';
import 'package:compair_hub/src/upload/product/presentation/widgets/category_glider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class CategorySearchBox extends ConsumerStatefulWidget {
  const CategorySearchBox(
      {super.key,
      required this.selectedCategoryId,
      required this.onSelected,
      required this.tag});

  final Function(ProductCategory) onSelected;
  final bool tag;
  final String selectedCategoryId;

  @override
  ConsumerState<CategorySearchBox> createState() => _CategorySearchBoxState();
}

class _CategorySearchBoxState extends ConsumerState<CategorySearchBox> {
  final productAdapterFamilyKey = GlobalKey();

  final controller = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;
  String _previousSelectedId = '';

  //String selectedCategoryId = '';

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    _debounce?.cancel();

    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();

    if (value.isEmpty) {
      setState(() {
        //Force rebuild so that base cats show
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref
          .read(productAdapterProvider(productAdapterFamilyKey).notifier)
          .searchCategories(query: value);
    });
  }

  List<ProductCategory> _reorder(
    List<ProductCategory> list,
    String selectedId,
  ) {
    if (selectedId.isEmpty) return list;

    final index = list.indexWhere((category) => category.id == selectedId);

    if (index == -1) return list;

    final selected = list[index];
    final others = [...list]..removeAt(index);

    return [selected, ...others];
  }

  //Allows smooth scroll for the category list back to start position (position 0)
  void _scrollToStart() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool tag = widget.tag;
    final searchState =
        ref.watch(productAdapterProvider(productAdapterFamilyKey));
    final catState = ref.watch(categoryAdapterProvider);

    List<ProductCategory> displayCategories = [];

    //For Search Results
    if (controller.text.isEmpty && catState is CategoryLoaded) {
      displayCategories = catState.categories;
    } else if (searchState is CategoriesSearched) {
      displayCategories = searchState.categories;
    }

    displayCategories = _reorder(displayCategories, widget.selectedCategoryId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VerticalLabelField(
          label: tag ? "Search Category" : "Category",
          controller: controller,
          hintText: "Search for category by name",
          keyboardType: TextInputType.text,
          onChanged: _onChanged,
          defaultValidation: false,
          prefixIcon: const Icon(Icons.search),
        ),
        const Gap(4),
        if (searchState is SearchingCategories) const LinearProgressIndicator(),
        const Gap(3),
        if (displayCategories.isNotEmpty)
          CategoryGlider(
            categories: displayCategories,
            selectedCategoryId: widget.selectedCategoryId,
            scrollController: _scrollController,
            onSelectCategory: (id) {
              final selected =
                  displayCategories.firstWhere((category) => category.id == id);

              // setState(() {
              //   selectedCategoryId = id;
              // });

              //Only scroll if the category has changed
              if (id !=_previousSelectedId) {
                _previousSelectedId = id;
                _scrollToStart();
              }

              widget.onSelected(selected);
              controller.clear();
              setState(() {});
            },
          ),
        /*ListView.builder(
          shrinkWrap: true,
            itemCount: displayCategories.length,
            itemBuilder: (_, i) {
              final cat = displayCategories[i];
              return ListTile(
                title: Text(cat.name ?? ''),
                onTap: () {
                  widget.onSelected(cat);
                  controller.clear();
                },
              );
            },
        ),*/
      ],
    );
  }
}
