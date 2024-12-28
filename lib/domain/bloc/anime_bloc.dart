import 'package:anime/data/airing_anime.dart';
import 'package:anime/domain/repository/anime/anime_repository.dart';
import 'package:anime/presentation/pages/detail_anime_page.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/anime.dart';
import '../../data/episode.dart';
import '../../data/last/last_anime.dart';
import '../../data/last/last_episode.dart';
import '../../presentation/pages/server_list_page.dart';

part 'anime_event.dart';
part 'anime_state.dart';

class AnimeBloc extends Bloc<AnimeEvent, AnimeState> {
  final AnimeRepository animeRepository;
  AnimeBloc({required this.animeRepository}) : super(AnimeState.init()) {
    on<Reset>((event, emit) async {
      emit(state.copyWith(isObtainAllData: false, initLoad: false));
    });

    on<ObtainData>((event, emit) async {
      state.lastEpisodes.addAll((await animeRepository.getLastEpisodes())
          .map((e) => LastEpisode.fromJson(e))
          .toList());
      state.lastAnimesAdd.addAll((await animeRepository.getLastAddedAnimes())
          .map((e) => LastAnime.fromJson(e))
          .toList());
      state.listAringAnime.addAll((await animeRepository.getAiringAnimes())
          .map((e) => AiringAnime.fromJson(e))
          .toList());
      emit(state.copyWith(isObtainAllData: true));
    });

    on<ObtainDataAnime>((event, emit) async {
      Anime? anime;
      emit(state.copyWith(initLoad: true));
      anime = await animeRepository.obtainAnimeForTitleAndId(
          state: state, id: event.id, title: event.title);
      state.listAnimes.add(anime!);
      emit(state.copyWith(initLoad: false));
      print("Aqui llega");
      navigationAnimated(
          context: event.context,
          navigateWidget: DetailAnimePage(anime: anime));
    });

    on<ObtainVideoSever>((event, emit) async {
      emit(state.copyWith(initLoad: true));
      if (event.episode.servers.isEmpty) {
        state.listAnimes
                .firstWhere((animeDeleted) => animeDeleted.id == event.anime.id)
                .episodes
                .firstWhere((element) => element.id == event.episode.id)
                .servers =
            await animeRepository.obtainVideoServerOfEpisode(
                id: event.episode.id);
        emit(state.copyWith());
      }
      emit(state.copyWith(initLoad: false));
      navigationAnimated(
          context: event.context,
          navigateWidget: ServerListPage(
              episode: state.listAnimes
                  .firstWhere(
                      (animeDeleted) => animeDeleted.id == event.anime.id)
                  .episodes
                  .firstWhere((element) => element.id == event.episode.id)));
    });
  }
  void navigationAnimated(
      {required BuildContext context, required Widget navigateWidget}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return navigateWidget;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Controlar la duración de la animación
          var delayedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves
                  .easeInBack, // Puedes cambiar la curva a la que prefieras
              reverseCurve: Curves.linear);

          // Aplicar la animación deseada (Fade en este caso)
          return FadeTransition(
            opacity: delayedAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
