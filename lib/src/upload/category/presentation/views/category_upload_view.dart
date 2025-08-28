import 'package:compair_hub/core/common/widgets/app_bar_bottom.dart';
import 'package:compair_hub/src/upload/category/presentation/widgets/category_upload_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryUploadView extends ConsumerStatefulWidget {
  const CategoryUploadView({super.key});

  static const path = '/categoryUpload';

  @override
  ConsumerState<CategoryUploadView> createState() => _CategoryUploadViewState();
}

class _CategoryUploadViewState extends ConsumerState<CategoryUploadView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Category Upload',
        ),
        bottom: const AppBarBottom(),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                children: const [
                  CategoryUploadForm(),
                ],
              ),
          ),
        ],
      ),
    );
  }
}
