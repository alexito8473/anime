import 'dart:io';

import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/data/model/episode.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../screens/server_screen.dart';
import '../widgets/load/load_widget.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ServerListPage extends StatefulWidget {
  final String idAnime;
  final String idEpisode;

  const ServerListPage(
      {super.key, required this.idAnime, required this.idEpisode});

  @override
  State<ServerListPage> createState() => _ServerListPageState();
}

class _ServerListPageState extends State<ServerListPage> {
  int _currentPage = 0;
  bool onFullScreen = false;
  late CompleteAnime anime;
  late Episode episode;
  InAppWebViewController? webViewController;
  final List<String> list = List.unmodifiable(
      ['hlsflast.com', 'streamwish', 'yourupload', 'ok.ru', 'rapidplayers']);
  final InAppWebViewSettings inAppWebViewSettings = InAppWebViewSettings(
      allowFileAccess: true,
      useHybridComposition: true,
      // Optimiza la renderización en Android (recomendado para dispositivos modernos).
      allowsInlineMediaPlayback: true,
      // Permite la reproducción de medios en línea sin abrir una ventana separada.
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
      // Permite cargar contenido mixto (http y https).
      javaScriptEnabled: true,
      // Asegura que JavaScript esté habilitado para mejorar la funcionalidad.
      cacheEnabled: true,
      // Habilita el uso de caché para mejorar tiempos de carga.
      transparentBackground: true,
      // Permite fondos transparentes si es necesario.
      supportZoom: false,
      // Desactiva el zoom para evitar comportamientos no deseados.
      useShouldInterceptRequest: true,
      // Permite interceptar solicitudes para un mayor control.
      incognito: false,
      // Desactiva el modo incógnito para aprovechar la caché.
      verticalScrollBarEnabled: false,
      // Desactiva la barra de desplazamiento vertical para una apariencia más limpia.
      horizontalScrollBarEnabled:
          false // Desactiva la barra de desplazamiento horizontal.
      );

  @override
  void initState() {
     WakelockPlus.enabled;
     anime = context
        .read<AnimeBloc>()
        .state
        .listAnimes
        .firstWhere((element) => element.id == widget.idAnime);
    episode =
        anime.episodes.firstWhere((element) => element.id == widget.idEpisode);
    task();
    super.initState();
  }

  void onTap(int index, Episode episode) async {
    setState(() {
      _currentPage = index;
    });
    await webViewController?.loadUrl(
        urlRequest: URLRequest(
            allowsExpensiveNetworkAccess: true,
            assumesHTTP3Capable: true,
            url: WebUri(episode.servers[_currentPage].code!)));
  }

  void task() async {
    await webViewController?.loadUrl(
        urlRequest: URLRequest(
            allowsExpensiveNetworkAccess: true,
            assumesHTTP3Capable: true,
            url: WebUri(episode.servers[_currentPage].code!)));
  }

  @override
  void dispose() {
    super.dispose();
    WakelockPlus.disable();
  }

  void onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
  }

  void onTapLeft() {
    if (anime.episodes.first.episode == 1) {
      context.read<AnimeBloc>().add(ObtainVideoSever(
          context: context,
          anime: anime,
          episode: anime.episodes[episode.episode - 2],
          isNavigationReplacement: true));
    } else {
      final int episode = anime.episodes
          .indexWhere((element) => element.id == widget.idEpisode);
      context.read<AnimeBloc>().add(ObtainVideoSever(
          context: context,
          anime: anime,
          episode: anime.episodes[episode + 1],
          isNavigationReplacement: true));
    }
  }

  void onTapSaveEpisode(bool isSave, Episode episode) {
    context
        .read<AnimeBloc>()
        .add(SaveEpisode(episode: episode, isSave: isSave));
  }

  void onTapRight() {
    if (anime.episodes.first.episode == 1) {
      context.read<AnimeBloc>().add(ObtainVideoSever(
          context: context,
          anime: anime,
          episode: anime.episodes[episode.episode],
          isNavigationReplacement: true));
    } else {
      final int episode = anime.episodes
          .indexWhere((element) => element.id == widget.idEpisode);
      context.read<AnimeBloc>().add(ObtainVideoSever(
          context: context,
          anime: anime,
          episode: anime.episodes[episode - 1],
          isNavigationReplacement: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return AnimationLoadPage(
        child: BlocConsumer<AnimeBloc, AnimeState>(listener: (context, state) {
      final CompleteAnime animeNew = state.listAnimes
          .firstWhere((element) => element.id == widget.idAnime);
      setState(() {
        anime=animeNew;
        episode = animeNew.episodes
            .firstWhere((element) => element.id == widget.idEpisode);
      });
    }, builder: (context, state) {
      return ServerScreen(
          episode: episode,
          currentPage: _currentPage,
          onTap: onTap,
          button: Platform.isWindows
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      onFullScreen = !onFullScreen;
                    });
                  },
                  isSelected: onFullScreen,
                  selectedIcon: const Icon(Icons.compress),
                  icon: const Icon(Icons.expand))
              : null,
          inAppWebViewSettings: inAppWebViewSettings,
          onWebViewCreated: onWebViewCreated,
          anime: anime,
          onTapLeft: onTapLeft,
          onTapRight: onTapRight,
          onTapSaveEpisode: onTapSaveEpisode,
          isSave: state.listEpisodesView.contains(episode.id),
          web: SizedBox(
              height: size.height * 0.7,
              width: size.width * 0.8,
              child: episode.servers[_currentPage].code == null
                  ? const CircularProgressIndicator()
                  : Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05,
                          vertical: size.height * 0.05),
                      child: InAppWebView(
                          initialSettings: inAppWebViewSettings,
                          shouldOverrideUrlLoading:
                              (controller, navigationAction) async {
                            if (list.any((element) => navigationAction
                                    .request.url
                                    .toString()
                                    .contains(element)) ||
                                episode.servers[_currentPage].code!.contains(
                                    navigationAction.request.url.toString())) {
                              return NavigationActionPolicy.ALLOW;
                            }
                            return NavigationActionPolicy.CANCEL;
                          },
                          onWebViewCreated: (controller) =>
                              onWebViewCreated(controller),
                          initialUrlRequest: URLRequest(
                              url: WebUri(
                                  episode.servers[_currentPage].code!))))));
    }));
  }
}
