import 'dart:math' show Random;

import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class FavouriteIcon extends StatefulWidget {
  const FavouriteIcon({required this.productId, super.key});

  final String productId;

  @override
  State<FavouriteIcon> createState() => _FavouriteIconState();
}

class _FavouriteIconState extends State<FavouriteIcon> {
  // TODO(Implementation): Implement remote logic
  late bool isFavourite;

  @override
  void initState() {
    super.initState();
    isFavourite = Random().nextBool();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // TODO(Implementation): Implement remote logic
        setState(() {
          isFavourite = !isFavourite;
        });
      },
      icon: Icon(
        isFavourite ? IconlyBold.heart : IconlyBroken.heart,
        color: Colours.lightThemeSecondaryColour,
      ),
    );
  }
}
