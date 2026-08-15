import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vistone_app/models/color_swatch.dart' as models;
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/analyzing_screen.dart';
import '../screens/result_screen.dart';
import '../screens/color_preview_screen.dart';
import '../screens/about_screen.dart';

CustomTransitionPage<void> _page(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 420),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, page) {
      final curve = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curve,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, .035), end: Offset.zero).animate(curve),
          child: page,
        ),
      );
    },
  );
}

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (_, state) => _page(state, const SplashScreen()),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (_, state) => _page(state, const HomeScreen()),
    ),
    GoRoute(
      path: '/analyzing',
      pageBuilder: (_, state) => _page(state, const AnalyzingScreen()),
    ),
    GoRoute(
      path: '/result',
      pageBuilder: (_, state) => _page(state, const ResultScreen()),
    ),
    GoRoute(
      path: '/color-preview',
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return _page(
          state,
          ColorPreviewScreen(
            swatch: extra['swatch'] as models.ColorSwatch,
            isAvoid: extra['isAvoid'] as bool,
            undertone: extra['undertone'] as String,
          ),
        );
      },
    ),
    GoRoute(
      path: '/about',
      pageBuilder: (_, state) => _page(state, const AboutScreen()),
    ),
  ],
);
