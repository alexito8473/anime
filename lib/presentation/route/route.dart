import 'package:anime/data/episode.dart';
import 'package:anime/presentation/pages/detail_anime_page.dart';
import 'package:anime/presentation/pages/home_page.dart';
import 'package:anime/presentation/pages/server_list_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/anime.dart';

final GoRouter router = GoRouter(routes: <RouteBase>[
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
            path: 'animeData',
            pageBuilder: (context, state) {
              return customTransitionPage(
                  state: state,
                  widget: DetailAnimePage(anime: state.extra as Anime));
            },
            routes: [
              GoRoute(
                path: '/servers',
                pageBuilder: (context, state) {
                  return customTransitionPage(
                      state: state,
                      widget: ServerListPage(episode: state.extra as Episode));
                },
              )
            ])
      ])
]);

CustomTransitionPage customTransitionPage(
    {required Widget widget, required GoRouterState state}) {
  return CustomTransitionPage(
      key: state.pageKey,
      child: widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Controlar la duración de la animación
        var delayedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInBack,
            reverseCurve: Curves.linear);

        // Aplicar el retraso para la animación
        return FadeTransition(opacity: delayedAnimation, child: child);
      });
}
