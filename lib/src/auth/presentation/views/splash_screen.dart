import 'package:compair_hub/core/common/app/cache_helper.dart';
import 'package:compair_hub/core/common/app/riverpod/current_user_provider.dart';
import 'package:compair_hub/core/common/singletons/cache.dart';
import 'package:compair_hub/core/common/widgets/compair_logo.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/services/injection_container.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/src/auth/presentation/app/adapter/auth_adapter.dart';
import 'package:compair_hub/src/user/presentation/adapter/auth_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authAdapterProvider().notifier).verifyToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(currentUserProvider, (previous, next) {
      if (next != null) {
        CoreUtils.postFrameCall(() => context.go('/', extra: 'home'));
      }
    });

    ref.listen(authAdapterProvider(), (previous, next) async {
      if (next is TokenVerified) {
        if (next.isValid) {
          ref.read(authUserProvider().notifier).getUserById(
            Cache.instance.userId!,
          );
        } else {
          await sl<CacheHelper>().resetSession();
          CoreUtils.postFrameCall(() => context.go('/'));
        }
      } else if (next is AuthError) {
        if (next.message.startsWith('401')) {
          return;
        }
      }
    });

    ref.listen(authUserProvider(), (previous, next) async {
      if (next case AuthUserError(:final message)) {
        CoreUtils.showSnackBar(context, message: message);
        await sl<CacheHelper>().resetSession();
        CoreUtils.postFrameCall(() => context.go('/'));
      }
    });
    return const Scaffold(
        backgroundColor: Colours.lightThemePrimaryColour,
        body: Center(child: CompairLogo()));
  }
}