import 'package:compair_hub/core/common/widgets/admin_option_bottom_sheet.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:flutter/material.dart';

Future<void> showAdminOptions({
  required BuildContext context,
  required VoidCallback onUploadProduct,
  required VoidCallback onUploadCategory,
}) {
  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) =>
        AdminOptionBottomSheet(
          onUploadProduct: onUploadProduct,
          onUploadCategory: onUploadCategory,
        ),
    backgroundColor: CoreUtils.adaptiveColour(
      context,
      lightModeColour: Colours.lightThemeWhiteColour,
      darkModeColour: Colours.darkThemeDarkNavBarColour,
    ),
  );
}
