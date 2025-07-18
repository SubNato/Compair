import 'package:compair_hub/core/extensions/context_extensions.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/enums/gender_age_category.dart';
import 'package:compair_hub/src/product/presentation/app/gender_age_category_notifier/gender_age_category_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class GenderAgeCategorySelector extends ConsumerWidget {
  const GenderAgeCategorySelector({
    required this.genderAgeCategoryNotifierFamilyKey,
    super.key,
  });

  final GlobalKey genderAgeCategoryNotifierFamilyKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGenderAgeCategory = ref.watch(
      genderAgeCategoryNotifierProvider(genderAgeCategoryNotifierFamilyKey),
    );
    return SizedBox(
      height: 40,
      child: Theme(
        data: context.theme.copyWith(canvasColor: Colors.transparent),
        child: ListView.separated(
          controller: ScrollController(),
          scrollDirection: Axis.horizontal,
          itemCount: GenderAgeCategory.values.length,
          separatorBuilder: (_, __) => const Gap(10),
          itemBuilder: (context, index) {
            final category = GenderAgeCategory.values[index];
            final selected = selectedGenderAgeCategory == category;
            return ChoiceChip(
              label: Text(category.title),
              labelStyle: selected
                  ? TextStyles.headingSemiBold1.white
                  : TextStyles.paragraphSubTextRegular1.grey,
              selected: selected,
              selectedColor: Colours.lightThemePrimaryColour,
              showCheckmark: false,
              backgroundColor: Colors.transparent,
              onSelected: (_) {
                ref
                    .read(
                      genderAgeCategoryNotifierProvider(
                        genderAgeCategoryNotifierFamilyKey,
                      ).notifier,
                    )
                    .changeCategory(category);
              },
            );
          },
        ),
      ),
    );
  }
}
