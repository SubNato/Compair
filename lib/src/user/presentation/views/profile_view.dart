import 'dart:io';

import 'package:compair_hub/core/common/app/riverpod/current_user_provider.dart';
import 'package:compair_hub/core/common/widgets/app_bar_bottom.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/src/user/presentation/adapter/auth_user_provider.dart';
import 'package:compair_hub/src/user/presentation/widgets/profile_form.dart';
import 'package:compair_hub/src/user/presentation/widgets/profile_picture.dart';
import 'package:compair_hub/src/user/presentation/widgets/update_user_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  static const path = '/profile';

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final nameFocusNode = FocusNode();
  final nameNotifier = ValueNotifier('');
  final changeNotifier = ValueNotifier(false);
  final updateContainer = <String, dynamic>{};
  final authUserAdapterFamilyKey = GlobalKey();

  /// Whether this page is locked for editing
  final lockNotifier = ValueNotifier(true);

  //For the profile picture state
  final ImagePicker _picker = ImagePicker();
  File? _selectedProfileImage;
  bool _profilePictureRemoved = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual(
      authUserProvider(authUserAdapterFamilyKey),
          (previous, next) {
        if (next case AuthUserError(:final message)) {
          CoreUtils.showSnackBar(context, message: message);
        } else if (next is UserUpdated) {
          //clear temporary image state after a successful updated profile picture
          setState(() {
            _selectedProfileImage = null;
            _profilePictureRemoved = false;
          });
          CoreUtils.showSnackBar(context, message: 'Update Successful');
        }
      },
    );
  }


  Future<void> _pickProfileImage() async {
    if (lockNotifier.value) return; // Safety check

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedProfileImage = File(image.path);
          _profilePictureRemoved = false;
        });

        // Mark as changed and add to update container
        changeNotifier.value = true;
        updateContainer['profilePicture'] = _selectedProfileImage;
      }
    } catch (e) {
      CoreUtils.showSnackBar(
        context,
        message: 'Failed to pick image',
      );
    }
  }

  void _removeProfilePicture() {
    if (lockNotifier.value) return; // Safety check

    setState(() {
      _selectedProfileImage = null;
      _profilePictureRemoved = true;
    });

    // Mark as changed and signal removal
    changeNotifier.value = true;
    updateContainer['profilePicture'] = 'REMOVE'; // Special marker for removal
  }

  void _resetProfilePictureState() {
    // Reset state when locking without saving
    if (_selectedProfileImage != null || _profilePictureRemoved) {
      setState(() {
        _selectedProfileImage = null;
        _profilePictureRemoved = false;
      });
      updateContainer.remove('profilePicture');

      // Check if there are other changes
      if (updateContainer.isEmpty) {
        changeNotifier.value = false;
      }
    }
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    nameNotifier.dispose();
    changeNotifier.dispose();
    lockNotifier.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        bottom: const AppBarBottom(),
        actions: [
          ValueListenableBuilder(
            valueListenable: lockNotifier,
            builder: (_, isLocked, __) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: () {
                    lockNotifier.value = !lockNotifier.value;
                    if (!lockNotifier.value) {
                      nameFocusNode.requestFocus();
                    } else {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (changeNotifier
                          .value) { //If locking without saving the profilePicture change
                        _resetProfilePictureState();
                      }
                    }
                    final message = lockNotifier.value
                        ? 'Profile Locked'
                        : 'Profile Unlocked';
                    CoreUtils.showSnackBar(context, message: message);
                  },
                  icon: Icon(isLocked ? IconlyBroken.edit : IconlyBroken.lock),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder(
                  valueListenable: nameNotifier,
                  builder: (_, nameFromController, __) {
                    final name =
                    lockNotifier.value && nameFromController.isEmpty
                        ? currentUser!.name
                        : nameFromController;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ValueListenableBuilder(








                            valueListenable: lockNotifier, builder: (_,
                            isLocked, __) {
                          return ProfilePictureWidget(
                            name: name,
                            isAdmin: currentUser!.isAdmin,
                            isBusiness: currentUser!.isBusiness,
                            currentProfilePictureUrl: _profilePictureRemoved
                                ? null
                                : currentUser?.profilePicture,
                            selectedImage: _selectedProfileImage,
                            isLocked: isLocked,
                            onImagePicked: _pickProfileImage,
                            onImageRemoved: _removeProfilePicture,);
                        },),
                        // CircleAvatar(
                        //   radius: 50,
                        //   backgroundColor: Colours.lightThemePrimaryColour,
                        //   child: Center(
                        //     child: Text(
                        //       name.initials,
                        //       textAlign: TextAlign.center,
                        //       style: TextStyles.headingMedium.white,
                        //     ),
                        //   ),
                        // ),
                        const Gap(15),
                        Center(
                          child: Text(
                            name,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.headingMedium
                                .adaptiveColour(context),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const Gap(20),
                Expanded(
                  flex: 2,
                  child: ValueListenableBuilder(
                    valueListenable: lockNotifier,
                    builder: (_, isLocked, __) {
                      return AbsorbPointer(
                        absorbing: isLocked,
                        child: ProfileForm(
                          nameFocusNode: nameFocusNode,
                          nameNotifier: nameNotifier,
                          changeNotifier: changeNotifier,
                          updateContainer: updateContainer,
                        ),
                      );
                    },
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: changeNotifier,
                  builder: (_, versionConflict, __) {
                    if (versionConflict) {
                      return UpdateUserButton(
                        updateData: updateContainer,
                        changeNotifier: changeNotifier,
                        authUserAdapterFamilyKey: authUserAdapterFamilyKey,
                        onPressed: () => lockNotifier.value = true,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
