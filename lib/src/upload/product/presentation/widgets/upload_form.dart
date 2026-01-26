import 'dart:io';

import 'package:compair_hub/core/common/widgets/vertical_label_field.dart';
import 'package:compair_hub/core/extensions/image_extension.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/core/utils/enums/product_type.dart';
import 'package:compair_hub/core/utils/product_type_selector.dart';
import 'package:compair_hub/src/product/domain/entities/category.dart';
import 'package:compair_hub/src/product/presentation/widgets/category_search_box.dart';
import 'package:compair_hub/src/upload/product/presentation/app/adapter/upload_adapter.dart';
import 'package:compair_hub/src/upload/product/presentation/app/category/category_adapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

class UploadForm extends ConsumerStatefulWidget {
  const UploadForm({super.key});

  @override
  ConsumerState<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends ConsumerState<UploadForm> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final brandController = TextEditingController();
  final categoryController = TextEditingController();
  final countInStockController = TextEditingController();
  final modelController = TextEditingController();

  final sizesController = TextEditingController();
  final colorsController = TextEditingController();
  final imagesController = TextEditingController();

  String? genderAgeCategory;
  String? type;
  File? mainImage;
  String selectedCategoryId = '';

  List<File> additionalImages = [];

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
    descriptionController.dispose();
    priceController.dispose();
    brandController.dispose();
    categoryController.dispose();
    countInStockController.dispose();
    modelController.dispose();
    sizesController.dispose();
    colorsController.dispose();
    imagesController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        mainImage = File(picked.path);
      });
    }
  }

  Future<void> pickMultipleImages() async {
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages.isNotEmpty) {
      setState(() {
        additionalImages
            .addAll(pickedImages.map((pickedFile) => File(pickedFile.path)));
      });
    }
  }

  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    final uploadNotifier = ref.read(uploadAdapterProvider().notifier);
    final uploadState = ref.watch(uploadAdapterProvider());

    //One image
    http.MultipartFile? mainImageFile;
    final mimeType = mainImage!.path.imageMimeType;

    if (mimeType != null) {
      mainImageFile = await http.MultipartFile.fromPath(
        'image',
        mainImage!.path,
        contentType: mimeType,
      );
    } else {
      debugPrint('Unsupported main image type detected: ${mainImage!.path}');
      CoreUtils.postFrameCall(() {
        CoreUtils.showSnackBar(context, message: 'Invalid Image Type!');
      });
    }

    //Multiple Images
    List<http.MultipartFile> imageFiles = [];
    for (var image in additionalImages) {
      final mimeType = image.path.imageMimeType;

      if (mimeType != null) {
        final multipartFile = await http.MultipartFile.fromPath(
          'images',
          image.path,
          contentType: mimeType,
        );
        imageFiles.add(multipartFile);
      } else {
        debugPrint('Unsupported image type: ${image.path}');
        // Optional: Show a snackbar or error message here
      }
    }

    uploadNotifier.upload(
      name: nameController.text.trim(),
      description: descriptionController.text.trim(),
      price: double.tryParse(priceController.text.trim()) ?? 0.0,
      brand: brandController.text.trim(),
      image: mainImageFile!,
      //mainImage?.path ?? '',
      //TODO: Check how backend wants it. To be changed
      category: selectedCategoryId,
      countInStock: int.tryParse(countInStockController.text.trim()) ?? 0,
      model: modelController.text
          .trim()
          .isEmpty
          ? null
          : modelController.text.trim(),
      //sizes: sizesController.text.split(',').map((e) => e.trim()).toList(),
      colors: colorsController.text
          .split(',')
          .map((e) => e.trim())
          .where((color) => color.isNotEmpty)
          .toList(),
      images: imageFiles,
      genderAgeCategory: genderAgeCategory,
      type: type,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(uploadAdapterProvider());
    final categoryState = ref.watch(categoryAdapterProvider);

    List<ProductCategory> categories = [];
    ref.listen(uploadAdapterProvider(), (prev, next) {
      if (next is Uploaded) {
        CoreUtils.postFrameCall(() {
          CoreUtils.showSnackBar(context, message: 'Upload Successful!');
          Navigator.pop(context); //?
        });
      } else if (next is UploadError) {
        CoreUtils.postFrameCall(() {
          CoreUtils.showSnackBar(context, message: 'Upload Error!');
        });
      }
    });

    if (categoryState is CategoryLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (categoryState is CategoryError) {
      return const Center(
        child: Text("It's not your fault, its ours"),
      );
    }
    if (categoryState is CategoryLoaded) {
      categories = categoryState.categories;
    }

    return Form(
      key: formKey,
      child: Column(
        children: [
          VerticalLabelField(
            label: 'Name',
            controller: nameController,
            keyboardType: TextInputType.name,
            hintText: 'Enter Product Name',
          ),
          const Gap(20),
          VerticalLabelField(
            label: 'Description',
            controller: descriptionController,
            keyboardType: TextInputType.text,
            hintText: 'Enter Product Description',
          ),
          const Gap(20),
          VerticalLabelField(
            label: 'Price',
            controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hintText: 'Enter Product Price',
          ),
          const Gap(20),
          VerticalLabelField(
            label: 'Brand',
            controller: brandController,
            keyboardType: TextInputType.text,
            hintText: 'Enter Product Brand',
          ),
          const Gap(10),
          /*Align(
            //Since we just want Alignment.
            alignment: Alignment.centerLeft,
            child: Text(
              'Category',
              style: TextStyles.headingMedium4.adaptiveColour(context),
            ),
          ),*/
          const Gap(10),
          CategorySearchBox(
              selectedCategoryId: selectedCategoryId,
              tag: false,
              onSelected: (newCategory) {
                setState(() {
                  selectedCategoryId = newCategory.id;
                });
              }),
          const Gap(30),
          VerticalLabelField(
            label: 'Count In Stock',
            controller: countInStockController,
            keyboardType: TextInputType.number,
            hintText: 'Enter Amount of Product in Stock',
          ),
          const Gap(20),
          VerticalLabelField(
            label: 'Model',
            controller: modelController,
            keyboardType: TextInputType.text,
            hintText: 'Enter Product Model (Optional)',
            defaultValidation: false,
          ),
          const Gap(20),
          // VerticalLabelField( //TODO: Take it out? Parts don't have sizes
          //   label: 'Size',
          //   controller: sizesController,
          //
          // ),
          // const Gap(20),
          VerticalLabelField(
            label: 'Colors (Separate them by commas please)',
            controller: colorsController,
            keyboardType: TextInputType.text,
            hintText: 'Enter Product Colors (Optional)',
            defaultValidation: false,
          ),
          const Gap(20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Select Product Type',
              style: TextStyles.headingMedium4.adaptiveColour(context),
            ),
          ),
          const Gap(20),
          ProductTypeSelector(onChanged: (product) {
            print("Changed value: ${product?.apiValue}");
            setState(() {
              type = product?.apiValue;
            });
          }),
          const Gap(20),
          // VerticalLabelField( //TODO, Image picker to select multiple photos! if neeeded
          //   label: 'Images',
          //   controller: imagesController,
          //   keyboardType: TextInputType.text,
          //   hintText: 'Enter Image url(Optional)',
          // ),
          // const Gap(20),
          // DropdownButtonFormField<String>(
          //   value: genderAgeCategory,
          //   onChanged: (val) => setState(() => genderAgeCategory = val),
          //   decoration: const InputDecoration(labelText: 'Gender/ Age Category'),
          //   items: const [
          //     DropdownMenuItem(value: 'men', child: Text('Men')),
          //     DropdownMenuItem(value: 'women', child: Text('Women')),
          //     DropdownMenuItem(value: 'unisex', child: Text('Unisex')),
          //     DropdownMenuItem(value: 'kids', child: Text('Kids')),
          //   ],
          // ),
          // const Gap(20),
          ElevatedButton.icon(
            onPressed: pickImage,
            icon: Icon(
              mainImage == null ? IconlyBroken.image : IconlyBold.image,
              color: Colours.classicAdaptiveTextColour(context),
            ),
            label: Text(
              mainImage == null ? 'Pick Product Image' : 'Change Image',
              style: TextStyle(
                color: Colours.classicAdaptiveTextColour(context),
              ),
            ),
          ),

          if (mainImage != null) ...[
            const SizedBox(height: 8),
            Image.file(mainImage!, height: 100),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                setState(() => mainImage = null);
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Remove Image'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
          /*if(mainImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Image.file(mainImage!, height: 100),
                ),*/
          const Gap(20),
          //When there is already a main image, then choose multiple images.
          mainImage != null
              ? ElevatedButton.icon(
            onPressed: () {
              pickMultipleImages();
            },
            label: Text(
              'Select More Images',
              style: TextStyle(
                color: Colours.classicAdaptiveTextColour(context),
              ),
            ),
            icon: Icon(
              additionalImages == null
                  ? IconlyBroken.image_2
                  : IconlyBold.image_2,
              color: Colours.classicAdaptiveTextColour(context),
            ),
          )
              : const SizedBox.shrink(),
          const Gap(10),
          additionalImages != null
              ? Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(additionalImages.length, (index) {
              final imageFile = additionalImages[index];
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(imageFile,
                        width: 100, height: 100, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => additionalImages.removeAt(index));
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            }),
          )
              : const SizedBox.shrink(),
          const Gap(20),
          if (additionalImages.length > 10)
            Text(
              'Only 10 More Images can be selected. ${additionalImages
                  .length} Selected',
              style: const TextStyle(color: Colors.red),
            ),
          ElevatedButton.icon(
            onPressed: () {
              if (nameController.text.isEmpty ||
                  descriptionController.text.isEmpty ||
                  priceController.text.isEmpty ||
                  brandController.text.isEmpty ||
                  mainImage == null ||
                  selectedCategoryId.isEmpty ||
                  countInStockController.text.isEmpty ||
                  type == null) {
                CoreUtils.postFrameCall(() {
                  CoreUtils.showSnackBar(context,
                      message: 'Please fill in required fields!');
                });
              } else if (additionalImages.length > 10) {
                CoreUtils.postFrameCall(() {
                  CoreUtils.showSnackBar(context,
                      message: 'Chose Only 10 Additional Images.');
                });
              } else {
                print("Submit form button pressed");
                state is UploadLoading ? null : submitForm();
              }
            },
            icon: Icon(
              mainImage == null ? IconlyBroken.upload : IconlyBold.upload,
              color: Colours.classicAdaptiveTextColour(context),
            ),
            label: state is UploadLoading
                ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  backgroundColor: Colours.lightThemeStockColour,
                ))
                : Text(
              'Upload',
              style: TextStyle(
                color: Colours.classicAdaptiveTextColour(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
