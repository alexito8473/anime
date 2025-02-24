import 'dart:io';

import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/data/model/episode.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../screens/server_screen.dart';
import '../widgets/load/load_widget.dart';

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
  WebViewController? _controller;
  bool onFullScreen = false;
  InAppWebViewController? webViewController;
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
    if (kIsWeb || Platform.isWindows) {
      task();
    }
    super.initState();
  }

  void onTap(int index, Episode episode) async {
    setState(() {
      _currentPage = index;
    });

    if (kIsWeb || Platform.isWindows) {
      if (_controller != null) {
        _controller!
            .loadRequest(Uri.parse(episode.servers[_currentPage].code!));
      }
    } else {
      await webViewController?.loadUrl(
          urlRequest: URLRequest(
              allowsExpensiveNetworkAccess: true,
              assumesHTTP3Capable: true,
              url: WebUri(episode.servers[_currentPage].code!)));
    }
  }

  void task() {
    CompleteAnime anime = context
        .read<AnimeBloc>()
        .state
        .listAnimes
        .firstWhere((element) => element.id == widget.idAnime);
    Episode episode =
        anime.episodes.firstWhere((element) => element.id == widget.idEpisode);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
          NavigationDelegate(onNavigationRequest: (NavigationRequest request) {
        if (request.url.toString().contains("hlsflast.com") ||
            request.url.toString().contains("streamwish") ||
            request.url.toString().contains("yourupload") ||
            request.url.toString().contains("ok.ru")) {
          return NavigationDecision.navigate;
        }
        if (episode.servers[_currentPage].code!
            .contains(request.url.toString())) {
          return NavigationDecision.navigate; // Bloquea la carga del enlace
        }
        return NavigationDecision.prevent;
      }))
      ..loadRequest(Uri.parse(episode.servers[_currentPage].code!));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
  }

  void onTapLeft() {
    CompleteAnime anime = context
        .read<AnimeBloc>()
        .state
        .listAnimes
        .firstWhere((element) => element.id == widget.idAnime);
    Episode episode =
        anime.episodes.firstWhere((element) => element.id == widget.idEpisode);
    context.read<AnimeBloc>().add(ObtainVideoSever(
        context: context,
        anime: anime,
        episode: anime.episodes[episode.episode - 2],
        isNavigationReplacement: true));
  }

  void onTapSaveEpisode(bool isSave, Episode episode) {
    context
        .read<AnimeBloc>()
        .add(SaveEpisode(episode: episode, isSave: isSave));
  }

  void onTapRight() {
    CompleteAnime anime = context
        .read<AnimeBloc>()
        .state
        .listAnimes
        .firstWhere((element) => element.id == widget.idAnime);
    Episode episode =
        anime.episodes.firstWhere((element) => element.id == widget.idEpisode);
    context.read<AnimeBloc>().add(ObtainVideoSever(
        context: context,
        anime: anime,
        episode: anime.episodes[episode.episode],
        isNavigationReplacement: true));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return AnimationLoadPage(
        child: BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      CompleteAnime anime = state.listAnimes
          .firstWhere((element) => element.id == widget.idAnime);
      Episode episode = anime.episodes
          .firstWhere((element) => element.id == widget.idEpisode);
      return ServerScreen(
          episode: episode,
          currentPage: _currentPage,
          onTap: onTap,
          button: kIsWeb || Platform.isWindows
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
          web: kIsWeb || Platform.isWindows
              ? SizedBox(
                  height: onFullScreen ? size.height * 0.8 : size.height * 0.7,
                  width: onFullScreen ? size.width : size.width * 0.8,
                  child: episode.servers[_currentPage].code == null
                      ? const CircularProgressIndicator()
                      : Padding(
                          padding: onFullScreen
                              ? EdgeInsets.zero
                              : EdgeInsets.symmetric(
                                  horizontal: size.width * 0.05,
                                  vertical: size.height * 0.05),
                          child: _controller == null
                              ? const SizedBox()
                              : WebViewWidget(controller: _controller!),
                        ))
              : SizedBox(
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
                                if (navigationAction.request.url
                                        .toString()
                                        .contains("hlsflast.com") ||
                                    navigationAction.request.url
                                        .toString()
                                        .contains("streamwish") ||
                                    navigationAction.request.url
                                        .toString()
                                        .contains("yourupload") ||
                                    navigationAction.request.url
                                        .toString()
                                        .contains("ok.ru") ||
                                    navigationAction.request.url
                                        .toString()
                                        .contains("rapidplayers")) {
                                  return NavigationActionPolicy.ALLOW;
                                }
                                if (episode.servers[_currentPage].code!
                                    .contains(navigationAction.request.url
                                        .toString())) {
                                  return NavigationActionPolicy
                                      .ALLOW; // Bloquea la carga del enlace
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
