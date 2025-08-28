import 'package:compair_hub/src/upload/category/presentation/widgets/category_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryTypeSelector extends StatefulWidget {
  const CategoryTypeSelector({
    super.key,
    required this.onChanged,
    });

  final Function(CategoryType) onChanged;

  @override
  State<CategoryTypeSelector> createState() => _CategoryTypeSelectorState();
}

class _CategoryTypeSelectorState extends State<CategoryTypeSelector> {
  late CategoryType _type;
  CategoryType selectedCategory =CategoryType.autoPart;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<CategoryType>(
        value: selectedCategory,
        items: CategoryType.values.map((category) {
          return DropdownMenuItem(
              value: category,
              child: Text(category.Label),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedCategory = value;
            });
            widget.onChanged(value); //Call back function sending data back to parent widget
          }
        }
    );
  }
}
