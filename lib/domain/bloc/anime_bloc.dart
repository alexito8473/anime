import 'package:anime/data/model/basic_anime.dart';
import 'package:anime/data/model/anime.dart';
import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/data/model/last_episode.dart';
import 'package:anime/data/model/episode.dart';
import 'package:anime/data/typeAnime/type_version_anime.dart';
import 'package:anime/domain/repository/anime/anime_repository.dart';
import 'package:anime/presentation/pages/detail_anime_page.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/model/list_type_anime_page.dart';
import '../../presentation/pages/server_page.dart';

part 'anime_event.dart';
part 'anime_state.dart';

class AnimeBloc extends Bloc<AnimeEvent, AnimeState> {
  final AnimeRepository animeRepository;
  AnimeBloc({required this.animeRepository}) : super(AnimeState.init()) {
    on<SaveAnime>((event, emit) async {
      if (event.isSave) {
        state.listAnimeSave
            .removeWhere((element) => element.id == event.anime.id);
      } else {
        state.listAnimeSave.add(event.anime);
      }
      animeRepository.saveList(state.listAnimeSave);
      emit(state.copyWith(countAnimeSave: state.listAnimeSave.length));
    });

    on<Reset>((event, emit) async {
      emit(state.copyWith(isObtainAllData: false, initLoad: false));
    });
    on<ObtainData>((event, emit) async {
      List<String> animeSave;
      emit(state.copyWith(isObtainAllData: false, initLoad: true));
      state.listAnimes.clear();
      state.lastEpisodes.clear();
      state.lastAnimesAdd.clear();
      state.listAringAnime.clear();
      state.listAnimeSave.clear();
      try {
        final results = await Future.wait([
          animeRepository.getLastEpisodes(),
          animeRepository.getLastAddedAnimes(),
          animeRepository.getAiringAnimes(),
          animeRepository.loadList(),
          animeRepository.searchByType(listTypeAnimePage: state.pageOvaAnime),
          animeRepository.searchByType(listTypeAnimePage: state.pageMovieAnime),
          animeRepository.searchByType(listTypeAnimePage: state.pageTVAnime),
          animeRepository.searchByType(
              listTypeAnimePage: state.pageSpecialAnime),
        ]);

        state.lastEpisodes
            .addAll(results[0].map((e) => LastEpisode.fromJson(e)).toList());
        state.lastAnimesAdd
            .addAll(results[1].map((e) => Anime.fromJson(e)).toList());
        state.listAringAnime
            .addAll(results[2].map((e) => BasicAnime.fromJson(e)).toList());
        animeSave = results[3] as List<String>;
        state.pageOvaAnime.listAnime
            .addAll(results[4].map((e) => Anime.fromJson(e)).toList());
        state.pageMovieAnime.listAnime
            .addAll(results[5].map((e) => Anime.fromJson(e)).toList());
        state.pageTVAnime.listAnime
            .addAll(results[6].map((e) => Anime.fromJson(e)).toList());
        state.pageSpecialAnime.listAnime
            .addAll(results[7].map((e) => Anime.fromJson(e)).toList());
        emit(state.copyWith(
            isObtainAllData: true,
            initLoad: false,
            countAnimeSave: animeSave.length));

        // Esperar a que todas las solicitudes se completen
        await Future.wait(animeSave.map((id) async {
          try {
            final anime = await animeRepository.obtainAnimeForId(
                id: id, checkBanner: false);
            if (anime != null) {
              state.listAnimeSave.add(anime);
            }
          } catch (e) {
            print("Error al obtener anime con ID $id: $e");
          }
        }).toList());
      } catch (e) {
        print("Error en el proceso de carga masiva de animes: $e");
      }
      emit(state.copyWith(isObtainAllData: true, initLoad: false));
    }, transformer: restartable());

    on<ObtainDataAnime>((event, emit) async {
      CompleteAnime? anime;
      emit(state.copyWith(initLoad: true));
      anime = await animeRepository.obtainAnimeForTitleAndId(
          state: state, id: event.id, title: event.title);
      state.listAnimes.add(anime!);
      emit(state.copyWith(initLoad: false));
      navigationAnimated(
          context: event.context,
          navigateWidget: DetailAnimePage(tag: event.tag, idAnime: anime.id));
    });

    on<SearchAnime>((event, emit) async {
      List<Anime> listAnime;
      emit(state.copyWith(initLoad: true));
      listAnime = (await animeRepository.search(event.query))
          .map((e) => Anime.fromJson(e))
          .toList();
      state.listSearchAnime.clear();
      state.listSearchAnime.addAll(listAnime);
      emit(state.copyWith(initLoad: false));
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
      }
      emit(state.copyWith(initLoad: false));

      navigationAnimated(
          isReplacement: event.isNavigationReplacement,
          context: event.context,
          navigateWidget: ServerListPage(
              idAnime: event.anime.id, idEpisode: event.episode.id));
    });
  }
  void navigationAnimated(
      {required BuildContext context,
      required Widget navigateWidget,
      bool isReplacement = false}) {
    if (isReplacement) {
      Navigator.pushReplacement(
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
      return;
    }
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
