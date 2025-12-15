part of 'router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          redirect: (context, state) {
            final cacheHelper = sl<CacheHelper>()
              ..getSessionToken()
              ..getUserId();
            if ((Cache.instance.sessionToken == null ||
                    Cache.instance.userId == null) &&
                !cacheHelper.isFirstTime()) {
              return LoginScreen.path;
            }
            if (state.extra == 'home') return HomeView.path;

            return null;
          },
          builder: (_, __) {
            final cacheHelper = sl<CacheHelper>()
              ..getSessionToken()
              ..getUserId();
            if (cacheHelper.isFirstTime()) {
              return const OnBoardingScreen();
            }
            return const SplashScreen();
          }),
      GoRoute(
        path: LoginScreen.path,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: ForgotPasswordScreen.path,
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: VerifyOTPScreen.path,
        builder: (_, state) => VerifyOTPScreen(email: state.extra as String),
      ),
      GoRoute(
        path: ResetPasswordScreen.path,
        builder: (_, state) =>
            ResetPasswordScreen(email: state.extra as String),
      ),
      GoRoute(
        path: RegistrationScreen.path,
        builder: (_, __) => const RegistrationScreen(),
      ),
      GoRoute(
        path: SearchView.path,
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, __) => const SearchView(),
      ),
      GoRoute(
        path: '/products/:productId',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) {
          final productId = state.pathParameters['productId'] as String;
          final extra = state.extra;

          //Opened from Compare View
          final fromCompare = (extra is Map && extra['fromCompare'] == true);

          return ProductDetailsView(
            productId,
            fromCompare: fromCompare,
          );
        },

        // builder: (_, state) => ProductDetailsView(
        //   state.pathParameters['productId'] as String,
        // ),
      ),
      GoRoute(
        path: '/products/:productId/reviews',
        parentNavigatorKey: rootNavigatorKey,
        builder: (_, state) => ProductReviews(state.extra as Product),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return DashboardScreen(state: state, child: child);
        },
        routes: [
          GoRoute(
            path: HomeView.path,
            builder: (_, __) => const HomeView(),
            routes: [
              GoRoute(
                path: AllNewArrivalsView.path,
                builder: (_, __) => const AllNewArrivalsView(),
              ),
              GoRoute(
                path: AllPopularProductsView.path,
                builder: (_, __) => const AllPopularProductsView(),
              ),
            ],
          ),
          GoRoute(
            path: ExploreView.path,
            builder: (_, __) => const ExploreView(),
          ),
          GoRoute(
            path: WishlistView.path,
            builder: (_, __) => const WishlistView(),
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: CartView.path,
        builder: (_, __) => const CartView(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: ProfileView.path,
        builder: (_, __) => const ProfileView(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: VendorView.path,
        builder: (_, state) => VendorView(vendor: state.extra as User),
      ),
      // GoRoute(
      //   parentNavigatorKey: rootNavigatorKey,
      //   path: VendorProductsView.path,
      //   builder: (_,state) => VendorProductsView(vendor: state.extra as User),
      // ),
      GoRoute(
          parentNavigatorKey: rootNavigatorKey,
          path: VendorProductsView.path,
          builder: (_, state) {
            final extra = state.extra;

            if (extra is Map<String, dynamic>) {
              return VendorProductsView(
                vendor: extra['vendor'] as User,
                isEditMode: extra['isEditMode'] as bool? ?? false,
              );
            } else if (extra is User) {
              return VendorProductsView(
                vendor: extra,
                isEditMode: false,
              );
            } else {
              throw Exception('VendorProductsView requires User in extra parameter');
            }
          }),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: ProductEditView.path,
        builder: (_, state) => ProductEditView(
          product: state.extra as Product,
        ),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: UploadView.path,
        builder: (_, __) => const UploadView(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: CategoryUploadView.path,
        builder: (_, __) => const CategoryUploadView(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: PaymentProfileView.path,
        builder: (_, state) => PaymentProfileView(
          sessionUrl: state.extra as String,
        ),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: CheckoutView.path,
        builder: (_, state) => CheckoutView(sessionUrl: state.extra as String),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: CheckoutSuccessfulView.path,
        builder: (_, state) => const CheckoutSuccessfulView(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/:category_name',
        redirect: (_, state) {
          if (state.extra is! ProductCategory) return '/home';
          return null;
        },
        builder: (_, state) {
          return CategorizedProductsView(state.extra as ProductCategory);
        },
      ),
    ],
    errorBuilder: (context, state) {
      return const RouteNotFoundPage();
    });
