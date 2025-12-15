import 'dart:io';

import 'package:compair_hub/core/common/widgets/app_bar_bottom.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/presentation/app/adapter/product_adapter.dart';
import 'package:compair_hub/src/product/presentation/app/category_notifier/category_notifier.dart';
import 'package:compair_hub/src/product/presentation/widgets/category_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

class ProductEditView extends ConsumerStatefulWidget {
  const ProductEditView({
    super.key,
    required this.product,
  });

  final Product product;

  static const path = '/product-edit';

  @override
  ConsumerState<ProductEditView> createState() => _ProductEditViewState();
}

class _ProductEditViewState extends ConsumerState<ProductEditView> {
  //Input Controllers
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  late final TextEditingController brandController;
  late final TextEditingController modelController;
  late final TextEditingController stockController;

  //FocusNode
  final nameFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  final brandFocusNode = FocusNode();
  final modelFocusNode = FocusNode();
  final stockFocusNode = FocusNode();

  //State Notifier
  final lockNotifier = ValueNotifier(true);
  final changeNotifier = ValueNotifier(false);
  final updateContainer = <String, dynamic>{};

  //Image Handling
  final ImagePicker _picker = ImagePicker();
  File? _selectedMainImage;
  final List<File> _newGalleryImages = [];
  final List<String> _imagesToDelete = [];
  final Map<String, String> _localImagePaths = {}; //Temporary images

  //Keys
  final productAdapterFamilyKey = GlobalKey();
  final categoryFamilyKey = GlobalKey();

  //Product Type
  String? _selectedProductType;
  String? _selectedGenderAgeCategory;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current values
    nameController = TextEditingController(text: widget.product.name);
    descriptionController =
        TextEditingController(text: widget.product.description);
    priceController =
        TextEditingController(text: widget.product.price.toString());
    brandController = TextEditingController(text: widget.product.brand);
    modelController = TextEditingController(text: widget.product.model);
    stockController =
        TextEditingController(text: widget.product.countInStock.toString());

    _selectedProductType = widget.product.type;
    _selectedGenderAgeCategory = widget.product.genderAgeCategory;

    // Listen to adapter state changes
    ref.listenManual(
      productAdapterProvider(productAdapterFamilyKey),
      (previous, next) {
        if (next is ProductError) {
          CoreUtils.showSnackBar(context, message: next.message);
        } else if (next is ProductUpdated) {
          CoreUtils.showSnackBar(context,
              message: 'Product updated successfully');
          // Lock after successful update
          lockNotifier.value = true;
          changeNotifier.value = false;
          updateContainer.clear();
          _clearTempImageState();
          // Optionally pop back
          // context.pop();
        } else if (next is ProductDeleted) {
          CoreUtils.showSnackBar(context,
              message: 'Product deleted successfully');
          context.pop(); // Go back after deletion
        }
      },
    );

    // Listen to category changes
    ref.listenManual(
      categoryNotifierProvider(categoryFamilyKey),
      (previous, next) {
        if (previous != next && next.id != widget.product.category.id) {
          updateContainer['category'] = next.id;
          changeNotifier.value = true;
        }
      },
    );

    // Add listeners to text controllers
    nameController.addListener(_onNameChanged);
    descriptionController.addListener(_onDescriptionChanged);
    priceController.addListener(_onPriceChanged);
    brandController.addListener(_onBrandChanged);
    modelController.addListener(_onModelChanged);
    stockController.addListener(_onStockChanged);
  }

  void _onNameChanged() {
    if (nameController.text != widget.product.name) {
      updateContainer['name'] = nameController.text;
      changeNotifier.value = true;
    } else {
      updateContainer.remove('name');
      _checkIfChangesExist();
    }
  }

  void _onDescriptionChanged() {
    if (descriptionController.text != widget.product.description) {
      updateContainer['description'] = descriptionController.text;
      changeNotifier.value = true;
    } else {
      updateContainer.remove('description');
      _checkIfChangesExist();
    }
  }

  void _onPriceChanged() {
    final price = double.tryParse(priceController.text);
    if (price != null && price != widget.product.price) {
      updateContainer['price'] = price;
      changeNotifier.value = true;
    } else {
      updateContainer.remove('price');
      _checkIfChangesExist();
    }
  }

  void _onBrandChanged() {
    if (brandController.text != widget.product.brand) {
      updateContainer['brand'] = brandController.text;
      changeNotifier.value = true;
    } else {
      updateContainer.remove('brand');
      _checkIfChangesExist();
    }
  }

  void _onModelChanged() {
    if (modelController.text != widget.product.model) {
      updateContainer['model'] = modelController.text;
      changeNotifier.value = true;
    } else {
      updateContainer.remove('model');
      _checkIfChangesExist();
    }
  }

  void _onStockChanged() {
    final stock = int.tryParse(stockController.text);
    if (stock != null && stock != widget.product.countInStock) {
      updateContainer['countInStock'] = stock;
      changeNotifier.value = true;
    } else {
      updateContainer.remove('countInStock');
      _checkIfChangesExist();
    }
  }

  void _checkIfChangesExist() {
    if (updateContainer.isEmpty &&
        _newGalleryImages.isEmpty &&
        _imagesToDelete.isEmpty &&
        _selectedMainImage == null) {
      changeNotifier.value = false;
    }
  }

  void _clearTempImageState() {
    setState(() {
      _selectedMainImage = null;
      _newGalleryImages.clear();
      _imagesToDelete.clear();
      _localImagePaths.clear();
    });
  }

  Future<void> _pickMainImage() async {
    if (lockNotifier.value) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedMainImage = File(image.path);
        });
        updateContainer['image'] = _selectedMainImage;
        changeNotifier.value = true;
      }
    } catch (e) {
      CoreUtils.showSnackBar(context, message: 'Failed to pick image');
    }
  }

  Future<void> _pickGalleryImages() async {
    if (lockNotifier.value) return;

    final remainingSlots = 10 -
        (widget.product.images.length -
            _imagesToDelete.length +
            _newGalleryImages.length);

    if (remainingSlots <= 0) {
      CoreUtils.showSnackBar(
        context,
        message: 'Maximum 10 images allowed. Delete some images first.',
      );
      return;
    }

    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        final imagesToAdd = images.take(remainingSlots).toList();

        setState(() {
          _newGalleryImages
              .addAll(imagesToAdd.map((xFile) => File(xFile.path)));
        });

        updateContainer['images'] = _newGalleryImages;
        changeNotifier.value = true;

        if (images.length > remainingSlots) {
          CoreUtils.showSnackBar(
            context,
            message: 'Only $remainingSlots images added due to 10 image limit',
          );
        }
      }
    } catch (e) {
      CoreUtils.showSnackBar(context, message: 'Failed to pick images');
    }
  }

  void _removeGalleryImage(String imageUrl) {
    if (lockNotifier.value) return;

    setState(() {
      _imagesToDelete.add(imageUrl);
    });
    changeNotifier.value = true;
  }

  void _removeNewImage(int index) {
    if (lockNotifier.value) return;

    setState(() {
      _newGalleryImages.removeAt(index);
    });

    if (_newGalleryImages.isEmpty) {
      updateContainer.remove('images');
    } else {
      updateContainer['images'] = _newGalleryImages;
    }

    _checkIfChangesExist();
  }

  void _undoRemoveImage(String imageUrl) {
    if (lockNotifier.value) return;

    setState(() {
      _imagesToDelete.remove(imageUrl);
    });

    _checkIfChangesExist();
  }

  Future<void> _saveChanges() async {
    // Validate required fields
    if (nameController.text.trim().isEmpty) {
      CoreUtils.showSnackBar(context, message: 'Product name is required');
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      CoreUtils.showSnackBar(context, message: 'Description is required');
      return;
    }
    if (priceController.text.trim().isEmpty) {
      CoreUtils.showSnackBar(context, message: 'Price is required');
      return;
    }
    if (brandController.text.trim().isEmpty) {
      CoreUtils.showSnackBar(context, message: 'Brand is required');
      return;
    }
    if (stockController.text.trim().isEmpty) {
      CoreUtils.showSnackBar(context, message: 'Stock count is required');
      return;
    }

    final price = double.tryParse(priceController.text);
    if (price == null || price < 0) {
      CoreUtils.showSnackBar(context, message: 'Please enter a valid price');
      return;
    }

    final stock = int.tryParse(stockController.text);
    if (stock == null || stock < 0 || stock > 255) {
      CoreUtils.showSnackBar(
        context,
        message: 'Stock must be between 0 and 255',
      );
      return;
    }

    // First, delete images if any
    if (_imagesToDelete.isNotEmpty) {
      ref
          .read(productAdapterProvider(productAdapterFamilyKey).notifier)
          .deleteProductImages(
            productId: widget.product.id,
            imageUrls: _imagesToDelete,
          );
    }

    // Then update product
    ref
        .read(productAdapterProvider(productAdapterFamilyKey).notifier)
        .updateProduct(
          productId: widget.product.id,
          updateData: updateContainer,
        );
  }

  Future<void> _deleteProduct() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text(
          'Are you sure you want to delete this product? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref
          .read(productAdapterProvider(productAdapterFamilyKey).notifier)
          .deleteProduct(widget.product.id);
    }
  }

  void _resetChanges() {
    // Reset all controllers
    nameController.text = widget.product.name;
    descriptionController.text = widget.product.description;
    priceController.text = widget.product.price.toString();
    brandController.text = widget.product.brand;
    modelController.text = widget.product.model;
    stockController.text = widget.product.countInStock.toString();

    // Reset product type and gender/age
    setState(() {
      _selectedProductType = widget.product.type;
      _selectedGenderAgeCategory = widget.product.genderAgeCategory;
    });

    // Reset category
    ref
        .read(categoryNotifierProvider(categoryFamilyKey).notifier)
        .changeCategory(widget.product.category);

    // Clear temp image state
    _clearTempImageState();

    // Clear update container
    updateContainer.clear();
    changeNotifier.value = false;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    brandController.dispose();
    modelController.dispose();
    stockController.dispose();

    nameFocusNode.dispose();
    descriptionFocusNode.dispose();
    priceFocusNode.dispose();
    brandFocusNode.dispose();
    modelFocusNode.dispose();
    stockFocusNode.dispose();

    lockNotifier.dispose();
    changeNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adapterState =
        ref.watch(productAdapterProvider(productAdapterFamilyKey));
    final isLoading =
        adapterState is UpdatingProduct || adapterState is DeletingProduct;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        bottom: const AppBarBottom(),
        actions: [
          // Delete button
          ValueListenableBuilder(
            valueListenable: lockNotifier,
            builder: (_, isLocked, __) {
              return IconButton(
                onPressed: isLocked ? _deleteProduct : null,
                icon: const Icon(IconlyBroken.delete),
                color: isLocked ? Colors.red : Colors.grey,
              );
            },
          ),
          // Lock/Unlock button
          ValueListenableBuilder(
            valueListenable: lockNotifier,
            builder: (_, isLocked, __) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          lockNotifier.value = !lockNotifier.value;
                          if (!lockNotifier.value) {
                            nameFocusNode.requestFocus();
                          } else {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (changeNotifier.value) {
                              _resetChanges();
                            }
                          }
                          final message = lockNotifier.value
                              ? 'Editing Locked'
                              : 'Editing Unlocked';
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
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ValueListenableBuilder(
                valueListenable: lockNotifier,
                builder: (_, isLocked, __) {
                  return AbsorbPointer(
                    absorbing: isLocked || isLoading,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImageSection(),
                        const Gap(24),
                        _buildBasicInfoSection(),
                        const Gap(24),
                        _buildCategorySection(),
                        const Gap(24),
                        _buildProductTypeSection(),
                        const Gap(24),
                        _buildGallerySection(),
                        const Gap(80), // Space for save button
                      ],
                    ),
                  );
                },
              ),
            ),
            // Save button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ValueListenableBuilder(
                valueListenable: changeNotifier,
                builder: (_, hasChanges, __) {
                  if (!hasChanges) return const SizedBox.shrink();

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colours.lightThemePrimaryColour,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Save Changes',
                              style: TextStyles.headingSemiBold1.white,
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Main Product Image',
          style: TextStyles.headingBold1.adaptiveColour(context),
        ),
        const Gap(12),
        GestureDetector(
          onTap: _pickMainImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colours.lightThemePrimaryColour.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colours.lightThemePrimaryColour.withOpacity(0.3),
              ),
            ),
            child: _selectedMainImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _selectedMainImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                : widget.product.image.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildImagePlaceholder(),
                        ),
                      )
                    : _buildImagePlaceholder(),
          ),
        ),
        if (lockNotifier.value == false)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Tap to change main image',
              style: TextStyles.paragraphSubTextRegular2.grey,
            ),
          ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 48,
          color: Colours.lightThemePrimaryColour,
        ),
        const Gap(8),
        Text(
          'Add Product Image',
          style: TextStyles.paragraphSubTextRegular1.grey,
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Information',
          style: TextStyles.headingBold1.adaptiveColour(context),
        ),
        const Gap(16),
        TextField(
          controller: nameController,
          focusNode: nameFocusNode,
          decoration: const InputDecoration(
            labelText: 'Product Name *',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const Gap(16),
        TextField(
          controller: descriptionController,
          focusNode: descriptionFocusNode,
          decoration: const InputDecoration(
            labelText: 'Description *',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
        ),
        const Gap(16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: priceController,
                focusNode: priceFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Price *',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
              ),
            ),
            const Gap(16),
            Expanded(
              child: TextField(
                controller: stockController,
                focusNode: stockFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Stock *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
        const Gap(16),
        TextField(
          controller: brandController,
          focusNode: brandFocusNode,
          decoration: const InputDecoration(
            labelText: 'Brand *',
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const Gap(16),
        TextField(
          controller: modelController,
          focusNode: modelFocusNode,
          decoration: const InputDecoration(
            labelText: 'Model',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category *',
          style: TextStyles.headingBold1.adaptiveColour(context),
        ),
        const Gap(12),
        CategorySelector(
          categoryNotifierFamilyKey: categoryFamilyKey,
        ),
      ],
    );
  }

  Widget _buildProductTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Type *',
          style: TextStyles.headingBold1.adaptiveColour(context),
        ),
        const Gap(12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Auto Part'),
              selected: _selectedProductType == 'autoPart',
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedProductType = 'autoPart';
                  });
                  updateContainer['type'] = 'autoPart';
                  changeNotifier.value = true;
                }
              },
              selectedColor: Colours.lightThemePrimaryColour,
              labelStyle: _selectedProductType == 'autoPart'
                  ? TextStyles.headingSemiBold1.white
                  : TextStyles.paragraphSubTextRegular1.grey,
            ),
            ChoiceChip(
              label: const Text('Furniture/Appliance'),
              selected: _selectedProductType == 'furnitureAppliance',
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedProductType = 'furnitureAppliance';
                  });
                  updateContainer['type'] = 'furnitureAppliance';
                  changeNotifier.value = true;
                }
              },
              selectedColor: Colours.lightThemePrimaryColour,
              labelStyle: _selectedProductType == 'furnitureAppliance'
                  ? TextStyles.headingSemiBold1.white
                  : TextStyles.paragraphSubTextRegular1.grey,
            ),
          ],
        ),
        const Gap(16),
        Text(
          'Gender/Age Category (Optional)',
          style: TextStyles.headingMedium4.adaptiveColour(context),
        ),
        const Gap(8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Men'),
              selected: _selectedGenderAgeCategory == 'men',
              onSelected: (selected) {
                setState(() {
                  _selectedGenderAgeCategory = selected ? 'men' : null;
                });
                if (selected) {
                  updateContainer['genderAgeCategory'] = 'men';
                } else {
                  updateContainer.remove('genderAgeCategory');
                }
                changeNotifier.value = true;
              },
              selectedColor: Colours.lightThemePrimaryColour,
              labelStyle: _selectedGenderAgeCategory == 'men'
                  ? TextStyles.headingSemiBold1.white
                  : TextStyles.paragraphSubTextRegular1.grey,
            ),
            ChoiceChip(
              label: const Text('Women'),
              selected: _selectedGenderAgeCategory == 'women',
              onSelected: (selected) {
                setState(() {
                  _selectedGenderAgeCategory = selected ? 'women' : null;
                });
                if (selected) {
                  updateContainer['genderAgeCategory'] = 'women';
                } else {
                  updateContainer.remove('genderAgeCategory');
                }
                changeNotifier.value = true;
              },
              selectedColor: Colours.lightThemePrimaryColour,
              labelStyle: _selectedGenderAgeCategory == 'women'
                  ? TextStyles.headingSemiBold1.white
                  : TextStyles.paragraphSubTextRegular1.grey,
            ),
            ChoiceChip(
              label: const Text('Unisex'),
              selected: _selectedGenderAgeCategory == 'unisex',
              onSelected: (selected) {
                setState(() {
                  _selectedGenderAgeCategory = selected ? 'unisex' : null;
                });
                if (selected) {
                  updateContainer['genderAgeCategory'] = 'unisex';
                } else {
                  updateContainer.remove('genderAgeCategory');
                }
                changeNotifier.value = true;
              },
              selectedColor: Colours.lightThemePrimaryColour,
              labelStyle: _selectedGenderAgeCategory == 'unisex'
                  ? TextStyles.headingSemiBold1.white
                  : TextStyles.paragraphSubTextRegular1.grey,
            ),
            ChoiceChip(
              label: const Text('Kids'),
              selected: _selectedGenderAgeCategory == 'kids',
              onSelected: (selected) {
                setState(() {
                  _selectedGenderAgeCategory = selected ? 'kids' : null;
                });
                if (selected) {
                  updateContainer['genderAgeCategory'] = 'kids';
                } else {
                  updateContainer.remove('genderAgeCategory');
                }
                changeNotifier.value = true;
              },
              selectedColor: Colours.lightThemePrimaryColour,
              labelStyle: _selectedGenderAgeCategory == 'kids'
                  ? TextStyles.headingSemiBold1.white
                  : TextStyles.paragraphSubTextRegular1.grey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGallerySection() {
    final currentImages = widget.product.images
        .where((url) => !_imagesToDelete.contains(url))
        .toList();

    final totalImages = currentImages.length + _newGalleryImages.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Product Gallery',
              style: TextStyles.headingBold1.adaptiveColour(context),
            ),
            Text(
              '$totalImages/10',
              style: TextStyles.paragraphSubTextRegular1.grey,
            ),
          ],
        ),
        const Gap(12),
        if (totalImages == 0)
          GestureDetector(
            onTap: _pickGalleryImages,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colours.lightThemePrimaryColour.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colours.lightThemePrimaryColour.withOpacity(0.3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 40,
                    color: Colours.lightThemePrimaryColour,
                  ),
                  const Gap(8),
                  Text(
                    'Add Gallery Images',
                    style: TextStyles.paragraphSubTextRegular1.grey,
                  ),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: totalImages + (totalImages < 10 ? 1 : 0),
            itemBuilder: (context, index) {
              // Add button
              if (index == totalImages && totalImages < 10) {
                return GestureDetector(
                  onTap: _pickGalleryImages,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colours.lightThemePrimaryColour.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colours.lightThemePrimaryColour.withOpacity(0.3),
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 32,
                      color: Colours.lightThemePrimaryColour,
                    ),
                  ),
                );
              }

              // Existing images from server
              if (index < currentImages.length) {
                final imageUrl = currentImages[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    if (!lockNotifier.value)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeGalleryImage(imageUrl),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }

              // New images (not yet uploaded)
              final newImageIndex = index - currentImages.length;
              return Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _newGalleryImages[newImageIndex],
                      fit: BoxFit.cover,
                    ),
                  ),
                  // NEW badge
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'NEW',
                        style: TextStyles.paragraphSubTextRegular.white
                            .copyWith(fontSize: 10),
                      ),
                    ),
                  ),
                  // Remove button
                  if (!lockNotifier.value)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removeNewImage(newImageIndex),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

        // Show deleted images with undo option
        if (_imagesToDelete.isNotEmpty) ...[
          const Gap(16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red, size: 20),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        '${_imagesToDelete.length} image(s) marked for deletion',
                        style: TextStyles.paragraphSubTextRegular2
                            .copyWith(color: Colors.red),
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _imagesToDelete
                      .map(
                        (url) => GestureDetector(
                          onTap: () => _undoRemoveImage(url),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.undo,
                                    size: 14, color: Colors.red),
                                const Gap(4),
                                Text(
                                  'Undo',
                                  style: TextStyles.paragraphSubTextRegular2
                                      .copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
