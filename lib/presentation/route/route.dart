import 'package:anime/presentation/pages/detail_anime_page.dart';
import 'package:anime/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(routes: <RouteBase>[
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
            path: 'anime/:anime',
            pageBuilder: (context, state) {
              final anime = state.pathParameters['anime']!;
              print(state.pathParameters['anime']!);
              return CustomTransitionPage(
                  key: state.pageKey,
                  reverseTransitionDuration: const Duration(milliseconds: 400),
                  maintainState: true,
                  transitionDuration: const Duration(milliseconds: 400),
                  child: HomePage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                      FadeTransition(opacity: animation, child: child));
            }),
      ])
]);