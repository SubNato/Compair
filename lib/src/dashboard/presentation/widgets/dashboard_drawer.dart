import 'package:compair_hub/core/common/app/cache_helper.dart';
import 'package:compair_hub/core/common/app/riverpod/current_user_provider.dart';
import 'package:compair_hub/core/common/singletons/cache.dart';
import 'package:compair_hub/core/common/widgets/bottom_sheet.dart';
import 'package:compair_hub/core/common/widgets/bottom_sheet_card.dart';
import 'package:compair_hub/core/common/widgets/rounded_button.dart';
import 'package:compair_hub/core/extensions/string_extensions.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/extensions/widget_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/core/services/injection_container.dart';
import 'package:compair_hub/core/utils/core_utils.dart';
import 'package:compair_hub/core/utils/enums/drawer_enums.dart';
import 'package:compair_hub/src/dashboard/presentation/app/dashboard_state.dart';
import 'package:compair_hub/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:compair_hub/src/dashboard/presentation/widgets/product_toggle.dart';
import 'package:compair_hub/src/dashboard/presentation/widgets/theme_toggle.dart';
import 'package:compair_hub/src/upload/category/presentation/views/category_upload_view.dart';
import 'package:compair_hub/src/upload/product/presentation/views/upload_view.dart';
import 'package:compair_hub/src/user/presentation/adapter/auth_user_provider.dart';
import 'package:compair_hub/src/user/presentation/views/payment_profile_view.dart';
import 'package:compair_hub/src/user/presentation/views/profile_view.dart';
import 'package:compair_hub/src/wishlist/presentation/views/wishlist_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class DashboardDrawer extends ConsumerStatefulWidget {
  const DashboardDrawer({super.key});

  @override
  ConsumerState<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends ConsumerState<DashboardDrawer> {
  final signingOutNotifier = ValueNotifier(false);
  final authUserFamilyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    ref.listenManual(authUserProvider(authUserFamilyKey), (previous, next) {
      if (next is AuthUserError) {
        final AuthUserError(:message) = next;
        Scaffold.of(context).closeDrawer();
        CoreUtils.showSnackBar(context, message: message);
      } else if (next
          case FetchedUserPaymentProfile(
            :final paymentProfileUrl,
          )) {
        context.push(PaymentProfileView.path, extra: paymentProfileUrl);
      }
    });
  }

  @override
  void dispose() {
    signingOutNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    final authUserAdapter = ref.watch(authUserProvider(authUserFamilyKey));

    // Since we are watching to see if a user is a business account or not,
    // We have to dynamically check and watch to see the variable that the the backend sends
    final currentUser = ref.watch(currentUserProvider);
    final drawerItems = DashboardUtils.drawerItems(currentUser!);


    return Drawer(
      backgroundColor: CoreUtils.adaptiveColour(
        context,
        lightModeColour: Colours.lightThemeWhiteColour,
        darkModeColour: Colours.darkThemeDarkSharpColour,
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colours.lightThemePrimaryColour,
                    child: Center(
                      child: Text(
                        user!.name.initials,
                        style: TextStyles.headingMedium.white,
                      ),
                    ),
                  ),
                  const Gap(15),
                  Tooltip(
                    message: user.name,
                    waitDuration: const Duration(milliseconds: 300),
                    showDuration: const Duration(seconds: 3),
                    child: Text(
                      user.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.headingMedium.adaptiveColour(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(
                color: CoreUtils.adaptiveColour(context,
                    lightModeColour: Colours.lightThemeWhiteColour,
                    darkModeColour: Colours.darkThemeDarkNavBarColour),
              ),
              itemCount: drawerItems.length,//DashboardUtils.drawerItems.length,
              itemBuilder: (_, index) {
                //Updated logic to check the index
                // whenever it is dynamically changed
                final drawerItem = drawerItems[index];
                return ListTile(
                  leading: Icon(
                    drawerItem.icon,
                    color: Colours.classicAdaptiveTextColour(context),
                  ),
                  title: Text(
                    drawerItem.title,
                    style: TextStyles.headingMedium3.adaptiveColour(context),
                  ).loading(
                    index == 1 && authUserAdapter is GettingUserPaymentProfile,
                  ),
                  onTap: () async { //Logic for the dashboard drawer items.
                    if (index != 1) Scaffold.of(context).closeDrawer();
                    switch (drawerItem.type) {
                    // Replacing integers, titles or lengths with an enumerator
                    // is better and cleaner coding for future usage!
                      case DrawerItemTypes.profile:
                        context.push(ProfileView.path);
                      case DrawerItemTypes.upload:
                        user.isAdmin ? showAdminOptions(
                            context: context,
                          onUploadProduct: () => context.push(UploadView.path),
                          onUploadCategory: () => context.push(CategoryUploadView.path),
                        ): context.push(UploadView.path);
                        //context.push(UploadView.path);
                      case DrawerItemTypes.paymentProfile:
                        ref
                            .read(authUserProvider(authUserFamilyKey).notifier)
                            .getUserPaymentProfile(Cache.instance.userId!);
                      case DrawerItemTypes.wishList:
                      DashboardState.instance.changeIndex(3);
                      context.go(WishlistView.path);
                      case DrawerItemTypes.orders:
                        print("-------------------------------ORDER BUTTON PRESSED ------------------------------");
                        // TODO(Nav): Go to OrdersPage
                      case DrawerItemTypes.privacyPolicy:
                        print("-------------------------------pp BUTTON PRESSED ------------------------------");

                    // TODO(Nav): Go to privacyPolicy
                      case DrawerItemTypes.termsAndConditions:
                        print("-------------------------------tc BUTTON PRESSED ------------------------------");

                    // TODO(Nav): Go to termsAndConditions
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(
              bottom: 20,
              top: 10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ThemeToggle(),
                    ProductToggle(),
                  ],
                ),
                const Gap(10),
                ValueListenableBuilder(
                  valueListenable: signingOutNotifier,
                  builder: (_, value, __) {
                    return RoundedButton(
                      height: 50,
                      text: 'Sign Out',
                      onPressed: () async {
                        final router = GoRouter.of(context);
                        final result = await showModalBottomSheet<bool>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          isDismissible: false,
                          builder: (_) {
                            return const BottomSheetCard(
                              title: 'Are you sure you want to Sign out?',
                              positiveButtonText: 'Yes',
                              negativeButtonText: 'Cancel',
                              positiveButtonColour:
                                  Colours.lightThemeSecondaryColour,
                            );
                          },
                        );

                        if (result ?? false) {
                          signingOutNotifier.value = true;
                          await sl<CacheHelper>().resetSession();
                          router.go('/');
                        }
                      },
                    ).loading(value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
