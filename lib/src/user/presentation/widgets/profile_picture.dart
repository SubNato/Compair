import 'dart:io';

import 'package:compair_hub/core/extensions/string_extensions.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class ProfilePictureWidget extends StatelessWidget {
  const ProfilePictureWidget({
    required this.name,
    required this.currentProfilePictureUrl,
    required this.selectedImage,
    required this.isLocked,
    required this.onImagePicked,
    required this.onImageRemoved,
    this.isAdmin,
    this.isBusiness,
    super.key,
  });

  final String name;
  final bool? isAdmin;
  final bool? isBusiness;
  final String? currentProfilePictureUrl;
  final File? selectedImage;
  final bool isLocked;
  final VoidCallback onImagePicked;
  final VoidCallback onImageRemoved;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Avatar
        _buildAvatar(),

        // Camera/Edit Button (only when unlocked)
        if (!isLocked && (isBusiness! || isAdmin!)) _buildEditButton(),

        // Remove Button (only when unlocked and has picture)
        if (!isLocked && _hasPicture) _buildRemoveButton(),
      ],
    );
  }

  Widget _buildAvatar() {
    // Priority 1: Show newly selected image
    if (selectedImage != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(selectedImage!),
      );
    }

    // Priority 2: Show existing profile picture from server
    if (currentProfilePictureUrl != null &&
        currentProfilePictureUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(currentProfilePictureUrl!),
        backgroundColor: Colours.lightThemePrimaryColour,
        onBackgroundImageError: (exception, stackTrace) {
          debugPrint('Failed to load profile picture');
        },
        child: Container(), // Shows only if image fails to load
      );
    }

    // Priority 3: Default to initials
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colours.lightThemePrimaryColour,
      child: Center(
        child: Text(
          name.initials,
          textAlign: TextAlign.center,
          style: TextStyles.headingMedium.white,
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: onImagePicked,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colours.lightThemePrimaryColour,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            IconlyBold.camera,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildRemoveButton() {
    return Positioned(
      top: 0,
      right: 0,
      child: GestureDetector(
        onTap: onImageRemoved,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.close,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  bool get _hasPicture {
    return selectedImage != null ||
        (currentProfilePictureUrl != null &&
            currentProfilePictureUrl!.isNotEmpty);
  }
}