import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/data/model/episode.dart';
import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
  InAppWebViewController? webViewController;
  final InAppWebViewSettings inAppWebViewSettings = InAppWebViewSettings(
      allowFileAccess: true,
      useHybridComposition:
          true, // Optimiza la renderización en Android (recomendado para dispositivos modernos).
      allowsInlineMediaPlayback:
          true, // Permite la reproducción de medios en línea sin abrir una ventana separada.
      mixedContentMode: MixedContentMode
          .MIXED_CONTENT_ALWAYS_ALLOW, // Permite cargar contenido mixto (http y https).
      javaScriptEnabled:
          true, // Asegura que JavaScript esté habilitado para mejorar la funcionalidad.
      cacheEnabled:
          true, // Habilita el uso de caché para mejorar tiempos de carga.
      transparentBackground:
          true, // Permite fondos transparentes si es necesario.
      supportZoom:
          false, // Desactiva el zoom para evitar comportamientos no deseados.
      useShouldInterceptRequest:
          true, // Permite interceptar solicitudes para un mayor control.
      incognito: false, // Desactiva el modo incógnito para aprovechar la caché.
      verticalScrollBarEnabled:
          false, // Desactiva la barra de desplazamiento vertical para una apariencia más limpia.
      horizontalScrollBarEnabled:
          false // Desactiva la barra de desplazamiento horizontal.
      );
  void onTap(int index, Episode episode) async {
    setState(() {
      _currentPage = index;
    });
    setState(() async {
      await webViewController?.loadUrl(
          urlRequest: URLRequest(
              allowsExpensiveNetworkAccess: true,
              assumesHTTP3Capable: true,
              url: WebUri(episode.servers[_currentPage].code!)));
    });
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
          inAppWebViewSettings: inAppWebViewSettings,
          onWebViewCreated: onWebViewCreated,
          anime: anime,
          onTapLeft: onTapLeft,
          onTapRight: onTapRight,
          onTapSaveEpisode: onTapSaveEpisode,
          isSave: state.listEpisodesView.contains(episode.id));
    }));
  }
}
