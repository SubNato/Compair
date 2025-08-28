import 'package:compair_hub/core/common/entities/user.dart';
import 'package:compair_hub/core/utils/enums/drawer_enums.dart';
import 'package:compair_hub/src/cart/presentation/views/cart_view.dart';
import 'package:compair_hub/src/explore/presentation/views/explore_view.dart';
import 'package:compair_hub/src/home/presentation/views/home_view.dart';
import 'package:compair_hub/src/upload/product/presentation/views/upload_view.dart';
import 'package:compair_hub/src/user/presentation/views/profile_view.dart';
import 'package:compair_hub/src/wishlist/presentation/views/wishlist_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

abstract class DashboardUtils {
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  //This is for the bottom navigation bar items
  static final iconList = <({IconData idle, IconData active})>[
    (idle: IconlyBroken.home, active: IconlyBold.home),
    (idle: IconlyBroken.discovery, active: IconlyBold.discovery),
    (idle: IconlyBroken.buy, active: IconlyBold.buy),
    (idle: IconlyBroken.heart, active: IconlyBold.heart),
    (idle: IconlyBroken.profile, active: IconlyBold.profile),
  ];

  //This is for the dashboard drawer items
  static List <({String title, IconData icon, DrawerItemTypes type})> drawerItems (User user) {
    return [
      (title: 'Profile', icon: IconlyBroken.profile, type: DrawerItemTypes.profile),
      if (user.isBusiness || user.isAdmin) (title: 'Upload', icon: IconlyBroken.upload, type: DrawerItemTypes.upload),
      (title: 'Payment Profile', icon: IconlyBroken.scan, type: DrawerItemTypes.paymentProfile),
      (title: 'Wishlist', icon: IconlyBroken.heart, type: DrawerItemTypes.wishList),
      (title: 'My orders', icon: IconlyBroken.time_circle, type: DrawerItemTypes.orders),
      (title: 'Privacy Policy', icon: IconlyBroken.shield_done, type: DrawerItemTypes.privacyPolicy),
      (title: 'Terms & Conditions', icon: IconlyBroken.document, type: DrawerItemTypes.termsAndConditions),
    ];
  }

  //This is for the bottom navigation bar items routing.
  static int activeIndex(GoRouterState state) {
    return switch (state.fullPath) {
      HomeView.path => 0,
      ExploreView.path => 1,
      CartView.path => 2,
      WishlistView.path => 3,
      ProfileView.path => 4,
      //UploadView.path => 5,
      _ => 0,
    };
  }
}
