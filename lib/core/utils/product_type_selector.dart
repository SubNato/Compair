import 'package:compair_hub/core/utils/enums/product_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductTypeSelector extends StatefulWidget {
  const ProductTypeSelector({
    super.key,
    required this.onChanged,
    });

  final Function(ProductType?) onChanged; // Nullable to handle no selection.

  @override
  State<ProductTypeSelector> createState() => _ProductTypeSelectorState();
}

class _ProductTypeSelectorState extends State<ProductTypeSelector> {
  late ProductType _type;
  ProductType? selectedCategory; // Start with nothing selected.

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ProductType>(
        hint: const Text('Select Product Type'), // Show when nothing is selected. User Hint text.
        value: selectedCategory,
        items: ProductType.values.map((category) {
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
