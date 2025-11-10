import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/utils/enums/product_type.dart';
import 'package:compair_hub/src/product/presentation/app/provider/product_type_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductToggle extends ConsumerWidget {
  const ProductToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(productTypeNotifierProvider);

    return SegmentedButton<ProductType>(
        segments: const [
          ButtonSegment(
              value: ProductType.autoPart,
            icon: Icon(Icons.directions_car),
          ),
          ButtonSegment(
              value: ProductType.furnitureAppliance,
            icon: Icon(Icons.chair),
          ),
        ],
        selected: {selectedType},
      onSelectionChanged: (Set<ProductType> selection) {
          //Updating the selected product type
        ref.read(productTypeNotifierProvider.notifier)
          .setType(selection.first);
      },

      style: ButtonStyle(
        iconSize: WidgetStateProperty.resolveWith((states) {
          if(states.contains(WidgetState.selected)) {
            return 20; // Larger icon when selected
          }
          return 18; // Smaller when not selected
        }),
        /*padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        )*/

        // Change the background of the selected vs unselected buttons.
        /*backgroundColor: WidgetStateProperty.resolveWith((states) {
          if(states.contains(WidgetState.selected)) {
            return Colors.deepPurple.withOpacity(0.2);//Selected button color
          }
          return Colors.grey.shade200;//Unselected button color
        }),*/

        // Changes the color of the selected vs. unselected Button icon colors.
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if(states.contains(WidgetState.selected)) {
            return Colours.lightThemePrimaryColour; //Selected Icon/text color
          }
          return Colours.lightThemeSecondaryColour; // Unselected icon/text color
        }),
      ),

    );
  }
}