import 'package:anime/data/airing_anime.dart';
import 'package:anime/domain/repository/anime/anime_repository.dart';
import 'package:anime/presentation/pages/detail_anime_page.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/complete_anime.dart';
import '../../data/episode.dart';
import '../../data/last/anime.dart';
import '../../data/last/last_episode.dart';
import '../../presentation/pages/server_page.dart';

part 'anime_event.dart';
part 'anime_state.dart';

class AnimeBloc extends Bloc<AnimeEvent, AnimeState> {
  final AnimeRepository animeRepository;
  AnimeBloc({required this.animeRepository}) : super(AnimeState.init()) {
    on<SaveAnime>((event, emit) async {
      if (event.isSave) {
        state.listAnimeSave.remove(event.anime);
      } else {
        state.listAnimeSave.add(event.anime);
      }
      animeRepository.saveList(state.listAnimeSave);
      emit(state.copyWith());
    });

    on<Reset>((event, emit) async {
      emit(state.copyWith(isObtainAllData: false, initLoad: false));
    });

    on<ObtainData>(
      (event, emit) async {
        await animeRepository.getLastEpisodes().then((value) {
          state.lastEpisodes
              .addAll(value.map((e) => LastEpisode.fromJson(e)).toList());
        });
        await animeRepository.getLastAddedAnimes().then((value) {
          state.lastAnimesAdd
              .addAll(value.map((e) => Anime.fromJson(e)).toList());
        });
        await animeRepository.getAiringAnimes().then((value) {
          state.listAringAnime
              .addAll(value.map((e) => AiringAnime.fromJson(e)).toList());
        });
        emit(state.copyWith(isObtainAllData: true));
        try {
          await animeRepository
              .fetchAnimeStream(await animeRepository.loadList())
              .forEach((anime) {
            state.listAnimeSave.add(anime);
            emit(state.copyWith());
          });
          state.listAnimes.addAll(state.listAnimeSave);
          emit(state.copyWith());
        } catch (e) {
          print('Error en el Stream: $e');
        }
      },
    );

    on<ObtainDataAnime>((event, emit) async {
      CompleteAnime? anime;
      emit(state.copyWith(initLoad: true));
      anime = await animeRepository.obtainAnimeForTitleAndId(
          state: state, id: event.id, title: event.title);
      state.listAnimes.add(anime!);
      emit(state.copyWith(initLoad: false));
      navigationAnimated(
          context: event.context,
          navigateWidget: DetailAnimePage(anime: anime, tag: event.tag));
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
            allowSnapshotting: true,
            barrierColor: Colors.black38,
            opaque: true,
            barrierDismissible: true,
            reverseTransitionDuration: const Duration(milliseconds: 600),
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) =>
                navigateWidget,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                  opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.decelerate,
                      reverseCurve: Curves.decelerate),
                  child: child);
            }));
  }
}
