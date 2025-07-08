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
      builder: (_, state) => ResetPasswordScreen(email: state.extra as String),
    ),
    GoRoute(
      path: RegistrationScreen.path,
      builder: (_, __) => const RegistrationScreen(),
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
      path: PaymentProfileView.path,
      builder: (_, state) => PaymentProfileView(
        sessionUrl: state.extra as String,
      ),
    ),
  ],
);
