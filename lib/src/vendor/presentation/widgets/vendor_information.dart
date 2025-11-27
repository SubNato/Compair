import 'package:compair_hub/core/common/entities/user.dart';
import 'package:compair_hub/core/extensions/text_style_extensions.dart';
import 'package:compair_hub/core/res/styles/colours.dart';
import 'package:compair_hub/core/res/styles/text.dart';
import 'package:compair_hub/src/product/domain/entities/product.dart';
import 'package:compair_hub/src/user/presentation/adapter/auth_user_provider.dart';
import 'package:compair_hub/src/vendor/presentation/views/vendor_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

Widget vendorNameSection(
    Product product, AuthUserState authUserState, BuildContext context) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: _vendorContent(product, authUserState, context))
    ],
  );
}

Widget _vendorContent(
    Product product, AuthUserState authUserState, BuildContext context) {
  final isAutoPart = product.type?.toLowerCase() == 'autopart'; //Product Type Check

  final primaryColour = isAutoPart
    ? Colours.lightThemePrimaryColour
    : Colours.lightThemeSecondaryColour;

  if (authUserState is GettingUserData) {
    return Row(
      children: [
        Text(
          'Sold By: ',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(
          height: 14,
          width: 14,
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 2,
          ),
        ),
      ],
    );
  }
  if (authUserState is UserUpdated || authUserState is FetchedUser) {
    final user = authUserState is UserUpdated
        ? authUserState.user
        : (authUserState as FetchedUser).user;
    return Row(
      children: [
        Text(
          'Sold By:  ',
          style: TextStyles.headingMedium4.adaptiveColour(context),
          // style: TextStyle(
          //   fontSize: 14,
          //   color: Colors.grey[600],
          // ),
        ),
        Flexible(//TODO: Add the profile photo beside the vendor name.
          child: GestureDetector( //TODO: ADD THE ICON FOR THE FIRST 10 COMPANIES TO SIGN UP
            onTap: () => context.push(VendorView.path, extra: user), //print("Routing to vendor's page"),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    user.name,
                    style: TextStyle(
                            fontSize: 18,
                            color: primaryColour,
                            fontWeight: FontWeight.w600,
                          ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: primaryColour,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  if (authUserState is AuthUserError) {
    return Row(
      children: [
        Text(
          'Sold By: ',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        GestureDetector(
          onTap: () => null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Unable to load vendor data. Please refresh the page',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red[700],
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
            ],
          ),
        )
      ],
    );
  }

  return Row(
    children: [
      Text(
        'Sold By: ',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      Text(
        'Loading...',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[500],
        ),
      ),
    ],
  );
}

Widget addressView(
    User vendor, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 20),
    child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Vendor Apartment
          if(vendor.address?.apartment != null) Text(
            vendor.address!.apartment!,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.headingMedium
                .adaptiveColour(context).copyWith(fontSize: 25),
          ),

          const Gap(5),

          //Vendor Street
          if(vendor.address?.street != null) Text(
            vendor.address!.street!,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.headingMedium
                .adaptiveColour(context).copyWith(fontSize: 25),
          ),

          const Gap(5),

          //Vendor City
          if(vendor.address?.city != null) Text(
            vendor.address!.city!,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.headingMedium
                .adaptiveColour(context).copyWith(fontSize: 25),
          ),

          const Gap(5),

          //Vendor Parish
          if(vendor.address?.parish != null) Text(
            vendor.address!.parish!,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.headingMedium
                .adaptiveColour(context).copyWith(fontSize: 25),
          ),

          const Gap(5),

          //Vendor Country
          if(vendor.address?.country != null) Text(
            vendor.address!.country!,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.headingMedium
                .adaptiveColour(context).copyWith(fontSize: 25),
          ),

          const Gap(5),

          //Vendor PostalCode
          if(vendor.address?.postalCode != null) Text(
            vendor.address!.postalCode!,
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.headingMedium
                .adaptiveColour(context).copyWith(fontSize: 25),
          ),
        ],
      ),
  );
}

