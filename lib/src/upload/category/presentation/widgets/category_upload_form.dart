import 'dart:io';

import 'package:compair_hub/core/common/widgets/vertical_label_field.dart';
import 'package:compair_hub/core/extensions/image_extension.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/src/upload/category/presentation/app/adapter/category_upload_adapter.dart';
import 'package:compair_hub/src/upload/category/presentation/widgets/category_type.dart';
import 'package:compair_hub/src/upload/category/presentation/widgets/category_type_selector.dart';
import 'package:compair_hub/src/upload/product/presentation/app/adapter/upload_adapter.dart';
import 'package:compair_hub/src/upload/product/presentation/app/category/category_adapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

class CategoryUploadForm extends ConsumerStatefulWidget {
  const CategoryUploadForm({super.key});

  @override
  ConsumerState<CategoryUploadForm> createState() => _CategoryUploadFormState();
}

class _CategoryUploadFormState extends ConsumerState<CategoryUploadForm> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final colorController = TextEditingController();

  String? type;
  File? image;

  final picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    CoreUtils.postFrameCall(() {
      ref.read(categoryAdapterProvider.notifier).fetchCategories();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    colorController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        image = File(picked.path);
      });
    }
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    final catUploadNotifier =
        ref.read(categoryUploadAdapterProvider().notifier);

    http.MultipartFile? imageFile;
    final mimeType = image!.path.imageMimeType;

    if (mimeType != null) {
      imageFile = await http.MultipartFile.fromPath(
        'image',
        image!.path,
        contentType: mimeType,
      );
    } else {
      debugPrint('Unsupported main image type detected: ${image!.path}');
      CoreUtils.postFrameCall(() {
        CoreUtils.showSnackBar(context, message: 'Invalid Image Type!');
      });
    }

    catUploadNotifier.categoryUpload(
      name: nameController.text.trim(),
      image: imageFile!,
      color: colorController.text.trim(),
      type: type!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(UploadAdapterProvider());

    ref.listen(categoryUploadAdapterProvider(), (prev, next) {
      if (next is CategoryUploaded) {
        CoreUtils.postFrameCall(() {
          CoreUtils.showSnackBar(context, message: 'Upload Successful!');
          Navigator.pop(context);
        });
      } else if (next is CategoryUploadError) {
        CoreUtils.postFrameCall(() {
          CoreUtils.showSnackBar(context, message: next.message);
        });
      }
    });

    if (CategoryState is CategoryLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Form(
        key: formKey,
        child: Column(
          children: [
            VerticalLabelField(
              label: 'Name',
              controller: nameController,
              keyboardType: TextInputType.name,
              hintText: 'Enter Category Name',
            ),
            const Gap(20),
            VerticalLabelField(
              label: 'Color',
              controller: colorController,
              keyboardType: TextInputType.text,
              hintText: 'Enter Category Color',
              defaultValidation: false,
            ),
            const Gap(20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Category Type',
                style: TextStyles.headingMedium4.adaptiveColour(context),
              ),
            ),
            const Gap(20),
            CategoryTypeSelector(onChanged: (category) {
              print("Changed value: ${category.apiValue}");
              setState(() {
                type = category.apiValue;
              });
            }),
            const Gap(30),
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: Icon(image == null ? IconlyBroken.image : IconlyBold.image, color: Colours.classicAdaptiveTextColour(context),),
              label: Text(
                image == null ? 'Pick Category Image' : 'Change Category Image',
                style: TextStyle(
                    color: Colours.classicAdaptiveTextColour(context),
                ),
              ),
            ),
            if (image != null) ...[
              const SizedBox(height: 8),
              Image.file(
                image!,
                height: 100,
              ),
              const SizedBox(
                height: 8,
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    image = null;
                  });
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Remove Image'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
            const Gap(20),
            ElevatedButton.icon(
              //TODO: Pop everything and return to home screen. The dashboard drawer gets in the way of the snackbar
              onPressed: () {
                print('Upload Cat Button was pressed');
                if (nameController.text.isEmpty ||
                    type == null ||
                    image == null) {
                  CoreUtils.postFrameCall(() {
                    CoreUtils.showSnackBar(context,
                        message: 'Please fill in required fields!');
                  });
                } else {
                  state is CategoryUploadLoading ? null : submitForm();
                }
              },
              label: Text(
                'Upload',
                style: TextStyle(
                    color: Colours.classicAdaptiveTextColour(context),
                ),
              ),
              icon: Icon(
                image == null ? IconlyBroken.image_2 : IconlyBold.image_2,
                color: Colours.classicAdaptiveTextColour(context),
              ),
            ),
          ],
        ));
  }
}
