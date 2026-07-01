import 'package:go_router/go_router.dart';
import 'package:vistone_app/models/color_swatch.dart' as models;
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/analyzing_screen.dart';
import '../screens/result_screen.dart';
import '../screens/color_preview_screen.dart';
import '../screens/about_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (_, __) => const HomeScreen(),
    ),
    GoRoute(
      path: '/analyzing',
      builder: (_, __) => const AnalyzingScreen(),
    ),
    GoRoute(
      path: '/result',
      builder: (_, __) => const ResultScreen(),
    ),
    GoRoute(
      path: '/color-preview',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ColorPreviewScreen(
          swatch: extra['swatch'] as models.ColorSwatch,
          isAvoid: extra['isAvoid'] as bool,
          undertone: extra['undertone'] as String,
        );
      },
    ),
    GoRoute(
      path: '/about',
      builder: (_, __) => const AboutScreen(),
    ),
  ],
);
