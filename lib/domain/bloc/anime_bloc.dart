import 'package:anime/data/model/basic_anime.dart';
import 'package:anime/data/model/anime.dart';
import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/data/model/last_episode.dart';
import 'package:anime/data/model/episode.dart';
import 'package:anime/domain/repository/anime/anime_repository.dart';
import 'package:anime/presentation/pages/detail_anime_page.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        List<LastEpisode> newLastEpisodes = List.empty(growable: true);
        List<Anime> newLastAnimesAdd = List.empty(growable: true);
        List<BasicAnime> newListAringAnime = List.empty(growable: true);
        List<String> animeSave;
        emit(state.copyWith(isObtainAllData: false, initLoad: true));
        await animeRepository.getLastEpisodes().then((value) => newLastEpisodes
            .addAll(value.map((e) => LastEpisode.fromJson(e)).toList()));
        await animeRepository.getLastAddedAnimes().then((value) =>
            newLastAnimesAdd
                .addAll(value.map((e) => Anime.fromJson(e)).toList()));
        await animeRepository.getAiringAnimes().then((value) =>
            newListAringAnime
                .addAll(value.map((e) => BasicAnime.fromJson(e)).toList()));
        animeSave = await animeRepository.loadList();
        state.listAnimes.clear();
        state.lastEpisodes.clear();
        state.lastAnimesAdd.clear();
        state.listAringAnime.clear();
        state.listAnimeSave.clear();
        state.lastEpisodes.addAll(List.from(newLastEpisodes));
        state.lastAnimesAdd.addAll(List.from(newLastAnimesAdd));
        state.listAringAnime.addAll(List.from(newListAringAnime));
        emit(state.copyWith(
            isObtainAllData: true,
            initLoad: false,
            countAnimeSave: animeSave.length));
        try {
          await animeRepository.fetchAnimeStream(animeSave).forEach((anime) {
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
          navigateWidget: DetailAnimePage(tag: event.tag, idAnime: anime.id));
    });

    on<SearchAnime>((event, emit) async {
      List<Anime> listAnime;
      emit(state.copyWith(initLoad: true));
      listAnime = (await animeRepository.search(event.query)).map((e) {
        return Anime.fromJson(e);
      }).toList();
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
              idAnime: event.anime.id,
              idEpisode: event.episode.id));
    });
  }
  void navigationAnimated(
      {required BuildContext context, required Widget navigateWidget, bool isReplacement = false}) {

    if(isReplacement){
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
