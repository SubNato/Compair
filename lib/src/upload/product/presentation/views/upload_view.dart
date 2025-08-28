import 'package:compair_hub/core/common/widgets/app_bar_bottom.dart';
import 'package:compair_hub/src/upload/product/presentation/widgets/upload_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadView extends ConsumerStatefulWidget {
  const UploadView({super.key});

  static const path = '/upload';

  @override
  ConsumerState<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends ConsumerState<UploadView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Upload',
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
                  UploadForm(),
                ],
              ),
          ),
        ],
      ),
    );
  }
}
