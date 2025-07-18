import 'package:compair_hub/core/common/widgets/input_field.dart';
import 'package:compair_hub/core/extensions/context_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({
    super.key,
    this.onTap,
    this.readOnly = false,
    this.suffixIcon,
    this.controller,
    this.onSubmitted,
  });

  final VoidCallback? onTap;
  final bool readOnly;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  late TextEditingController controller;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    focusNode
      ..unfocus()
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '/search-section',
      flightShuttleBuilder: (context, __, ___, ____, _____) {
        return Material(
          color: context.theme.scaffoldBackgroundColor,
          child: const SearchSection(readOnly: true),
        );
      },
      child: InputField(
        controller: controller,
        focusNode: focusNode,
        defaultValidation: false,
        readOnly: widget.readOnly,
        hintText: 'Search for products',
        onTap: widget.onTap,
        prefixIcon: const Icon(IconlyLight.search),
        onTapOutside: (_) => focusNode.unfocus(),
        onSubmitted: widget.onSubmitted,
        suffixIcon: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListenableBuilder(
                listenable: focusNode,
                builder: (context, __) {
                  return VerticalDivider(
                    color: focusNode.hasFocus
                        ? Colours.lightThemePrimaryColour
                        : Colours.lightThemeWhiteColour,
                    indent: 10,
                    endIndent: 10,
                    width: 20,
                  );
                },
              ),
              if (widget.suffixIcon != null)
                widget.suffixIcon!
              else
                const Icon(IconlyLight.filter, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
