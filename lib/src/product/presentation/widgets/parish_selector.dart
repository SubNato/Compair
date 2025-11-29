//Works. Stateful widget
import 'package:compair_hub/core/extensions/context_extensions.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/enums/jamaican_parishes.dart';
import 'package:compair_hub/src/product/presentation/app/parish_notifier/parish_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ParishSelector extends ConsumerStatefulWidget {
  const ParishSelector({
    super.key,
    required this.parishNotifierFamilyKey,
    this.onParishChanged,
  });

  final GlobalKey parishNotifierFamilyKey;
  final void Function(JamaicanParishes? parish)? onParishChanged;

  @override
  ConsumerState<ParishSelector> createState() => _ParishSelectorState();
}

class _ParishSelectorState extends ConsumerState<ParishSelector> {
  final ScrollController _scrollController = ScrollController();

  void selectParish(JamaicanParishes? parish) {
    ref
        .read(parishNotifierProvider(widget.parishNotifierFamilyKey).notifier)
        .changeParish(parish);

    widget.onParishChanged?.call(parish);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedParish = ref.watch(
      parishNotifierProvider(widget.parishNotifierFamilyKey),
    );

    return SizedBox(
      height: 40,
      child: Theme(
        data: context.theme.copyWith(canvasColor: Colors.transparent),
        child: ListView.separated(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_, __) => const Gap(10),
          itemCount: JamaicanParishes.values.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              final selected = selectedParish == null;
              return ChoiceChip(
                label: const Text('All Parishes'),
                labelStyle: selected
                    ? TextStyles.headingSemiBold1.white
                    : TextStyles.paragraphSubTextRegular1.grey,
                selected: selected,
                selectedColor: Colours.lightThemePrimaryColour,
                showCheckmark: false,
                backgroundColor: Colors.transparent,
                onSelected: (_) => selectParish(null),
              );
            }

            final parish = JamaicanParishes.values[index - 1];
            final selected = selectedParish == parish;

            return ChoiceChip(
              label: Text(parish.title),
              labelStyle: selected
                  ? TextStyles.headingSemiBold1.white
                  : TextStyles.paragraphSubTextRegular1.grey,
              selected: selected,
              selectedColor: Colours.lightThemePrimaryColour,
              showCheckmark: false,
              backgroundColor: Colors.transparent,
              onSelected: (_) => selectParish(parish),
            );
          },
        ),
      ),
    );
  }
}







//Works. Not a stateful widget though.

// import 'package:compair_hub/core/extensions/context_extensions.dart';
// import 'package:compair_hub/core/extensions/text_style_extensions.dart';
// import 'package:compair_hub/core/res/styles/colours.dart';
// import 'package:compair_hub/core/res/styles/text.dart';
// import 'package:compair_hub/core/utils/enums/jamaican_parishes.dart';
// import 'package:compair_hub/src/product/presentation/app/parish_notifier/parish_notifier.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gap/gap.dart';
//
// class ParishSelector extends ConsumerWidget {
//   const ParishSelector({
//     super.key,
//     required this.parishNotifierFamilyKey,
//     this.onParishChanged,
//   });
//
//   final GlobalKey parishNotifierFamilyKey;
//   final void Function(JamaicanParishes? parish)? onParishChanged;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedParish = ref.watch(
//       parishNotifierProvider(parishNotifierFamilyKey),
//     );
//
//     void selectParish(JamaicanParishes? parish) {
//       ref
//           .read(parishNotifierProvider(parishNotifierFamilyKey).notifier)
//           .changeParish(parish);
//
//       onParishChanged?.call(parish);
//     }
//
//     return SizedBox(
//       height: 40,
//       child: Theme(
//         data: context.theme.copyWith(canvasColor: Colors.transparent),
//         child: ListView.separated(
//           controller: ScrollController(),
//           scrollDirection: Axis.horizontal,
//           separatorBuilder: (_, __) => const Gap(10),
//           itemCount: JamaicanParishes.values.length + 1,
//           itemBuilder: (context, index) {
//             if (index == 0) {
//               final selected = selectedParish == null;
//               return ChoiceChip(
//                 label: const Text('All Parishes'),
//                 labelStyle: selected
//                     ? TextStyles.headingSemiBold1.white
//                     : TextStyles.paragraphSubTextRegular1.grey,
//                 selected: selected,
//                 selectedColor: Colours.lightThemePrimaryColour,
//                 showCheckmark: false,
//                 backgroundColor: Colors.transparent,
//                 onSelected: (_) => selectParish(null),
//               );
//             }
//
//             final parish = JamaicanParishes.values[index - 1];
//             final selected = selectedParish == parish;
//
//             return ChoiceChip(
//               label: Text(parish.title),
//               labelStyle: selected ? TextStyles.headingSemiBold1.white : TextStyles.paragraphSubTextRegular1.grey,
//               selected: selected,
//               selectedColor: Colours.lightThemePrimaryColour,
//               showCheckmark: false,
//               backgroundColor: Colors.transparent,
//               onSelected: (_) => selectParish(parish),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
