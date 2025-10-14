import 'package:compair_hub/core/common/widgets/bottom_sheet_card.dart';
import 'package:compair_hub/core/common/widgets/classic_product_tile.dart';
import 'package:compair_hub/core/extensions/context_extensions.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteNotFoundPage extends StatelessWidget {
  const RouteNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              const Text(
                'The page you’re trying to access does not exist or was removed.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/'); // fallback to home if cannot pop
                  }
                },
                icon: Icon(Icons.arrow_back,
                  size: 20,
                  color: context.isDarkMode
                    ? Colours.lightThemeWhiteColour
                    : Colors.black,
                ),
                label: Text(
                    'Go Back',
                    style: TextStyles.headingMedium4.adaptiveColour(context),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
