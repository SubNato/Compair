import 'package:compair_hub/core/common/widgets/favourite_icon.dart';
import 'package:compair_hub/core/extensions/string_extensions.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/product/presentation/widgets/colour_palette.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeProductTile extends StatelessWidget {
  const HomeProductTile(this.product, {super.key, this.margin});

  final Product product;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // TODO(Navigation): Push to Product details page
      },
      child: Container(
        width: 196,
        margin: margin,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: CoreUtils.adaptiveColour(
            context,
            lightModeColour: Colours.lightThemeWhiteColour,
            darkModeColour: Colours.darkThemeDarkSharpColour,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    height: 131,
                    width: 180,
                    decoration: BoxDecoration(
                      color: const Color((0xFFF0F0F0)),
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: NetworkImage(product.image),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: FavouriteIcon(productId: product.id),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name.truncateWithEllipsis(12),
                    style: TextStyles.headingMedium4.adaptiveColour(context),
                  ),
                  if (product.colours.isNotEmpty)
                    Flexible(
                      child: ColourPalette(
                        colours: product.colours.take(3).toList(),
                        radius: 5,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5).copyWith(top: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyles.paragraphSubTextRegular3.orange,
                  ),
                  const Gap(6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colours.lightThemeYellowColour,
                        size: 11,
                      ),
                      const Gap(3),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: TextStyles.paragraphSubTextRegular2
                            .adaptiveColour(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
