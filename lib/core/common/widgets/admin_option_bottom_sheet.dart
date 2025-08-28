import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminOptionBottomSheet extends StatelessWidget {
  const AdminOptionBottomSheet({
    super.key,
    this.onUploadCategory,
    this.onUploadProduct,
  });

  final Function()? onUploadProduct;
  final Function()? onUploadCategory;

  @override
  Widget build(BuildContext context) {//TODO: Clean up the modal sheet. Make it more pretty. Otherwise it works well and is fine. TeHe ^p^
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(
              Icons.shopping_bag_outlined,
              color: Colours.classicAdaptiveTextColour(context),
            ),
            title: Text(
              'Upload Product',
              style:
                  TextStyle(color: Colours.classicAdaptiveTextColour(context)),
            ),
            onTap: () {
              Navigator.pop(context); // close the sheet
              if (onUploadProduct != null) {
                onUploadProduct!();
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.category,
              color: Colours.classicAdaptiveTextColour(context),
            ),
            title: Text(
              'Upload Category',
              style: TextStyle(
                color: Colours.classicAdaptiveTextColour(context),
              ),
            ),
            onTap: () {
              Navigator.pop(context); // close the sheet
              if (onUploadCategory != null) {
                onUploadCategory!();
              }
            },
          ),
        ],
      ),
    );
  }
}
