import 'package:anime/data/enums/gender.dart';
import 'package:anime/data/model/anime.dart';
import 'package:anime/data/model/basic_anime.dart';
import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/data/model/episode.dart';
import 'package:anime/data/model/gender_anime_page.dart';
import 'package:anime/data/model/last_episode.dart';
import 'package:anime/domain/repository/anime/anime_repository.dart';
import 'package:anime/presentation/pages/detail_anime_page.dart';
import 'package:anime/presentation/pages/gender_list_anime_page.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../data/enums/type_my_animes.dart';
import '../../../data/enums/type_version_anime.dart';
import '../../../data/model/home_page_data.dart';
import '../../../data/model/list_type_anime_page.dart';
import '../../../presentation/pages/server_page.dart';

part 'anime_event.dart';

part 'anime_state.dart';

class AnimeBloc extends HydratedBloc<AnimeEvent, AnimeState> {
  final AnimeRepository animeRepository = AnimeRepository();

  AnimeBloc({required AnimeState animeState}) : super(animeState) {
    on<LoadNewState>((event, emit) async {
      emit(state.copyWith(
          lastEpisodes: event.animeState.lastEpisodes,
          lastAnimesAdd: event.animeState.lastAnimesAdd,
          listAringAnime: event.animeState.listAringAnime,
          mapPageAnimes: event.animeState.mapPageAnimes));
    });

    on<SaveAnime>((event, emit) async {
      // Clonar los mapas para mantener inmutabilidad
      final newMapAnimesLoad = state.mapAnimesLoad.map((key, value) {
        final newList = List<CompleteAnime>.from(value);
        newList.removeWhere((element) => element.id == event.anime.id);
        if (key == event.typeMyAnimes) {
          newList.add(event.anime);
          newList.sort((a, b) => a.title.compareTo(b.title));
        }
        return MapEntry(key, newList);
      });

      final newMapAnimesSave = state.mapAnimesSave.map((key, value) {
        final newList = List<String>.from(value);
        newList.removeWhere((id) => id == event.anime.id);
        if (key == event.typeMyAnimes) {
          newList.add(event.anime.id);
        }
        return MapEntry(key, newList);
      });

      emit(state.copyWith(
          mapAnimesLoad: newMapAnimesLoad, mapAnimesSave: newMapAnimesSave));
    });

    on<SaveEpisode>((event, emit) async {
      if (event.isSave) {
        state.listEpisodesView
            .removeWhere((element) => element == event.episode.id);
      } else {
        state.listEpisodesView.add(event.episode.id);
      }
      emit(state.copyWith());
    });

    on<Reset>((event, emit) async {
      emit(state.copyWith(isObtainAllData: false, initLoad: false));
    });

    on<ObtainData>((event, emit) async {
      final List<Future<Null>> listFutures = List.empty(growable: true);
      emit(state.copyWith(isObtainAllData: false, initLoad: true));
      await Future.wait([
        Future.microtask(() => state.listAnimes.clear()),
        Future.microtask(() => state.listAnimes.clear()),
        Future.microtask(() => state.lastEpisodes.clear()),
        Future.microtask(() => state.lastAnimesAdd.clear()),
        Future.microtask(() => state.listAringAnime.clear()),
        Future.microtask(
            () => state.mapAnimesLoad.forEach((key, value) => value.clear())),
        Future.microtask(() {
          for (TypeMyAnimes animes in TypeMyAnimes.values
              .where((element) => element != TypeMyAnimes.NONE)) {
            listFutures.addAll(transformListStringToListFuture(
                listAnime: state.mapAnimesSave[animes]!,
                listAnimeState: state.mapAnimesLoad[animes]!));
          }
        })
      ]);
      try {
        final results = await Future.wait([
          animeRepository.obtainHomePageData(),
          animeRepository.searchByType(
              listTypeAnimePage: state.mapPageAnimes[TypeVersionAnime.ova]!),
          animeRepository.searchByType(
              listTypeAnimePage: state.mapPageAnimes[TypeVersionAnime.movie]!),
          animeRepository.searchByType(
              listTypeAnimePage: state.mapPageAnimes[TypeVersionAnime.tv]!),
          animeRepository.searchByType(
              listTypeAnimePage:
              animeState.mapPageAnimes[TypeVersionAnime.special]!),
        ]);
        await Future.wait([
          Future.microtask(() => state.lastEpisodes
              .addAll((results[0] as HomePageData).listLastEpisodes)),
          Future.microtask(() => state.lastAnimesAdd
              .addAll((results[0] as HomePageData).listAnime)),
          Future.microtask(() => state.listAringAnime
              .addAll((results[0] as HomePageData).listBasicAnime)),
          Future.microtask(() => state
              .mapPageAnimes[TypeVersionAnime.ova]?.listAnime
              .addAll(Anime.listDynamicToListAnime(results[1] as List<dynamic>))),
          Future.microtask(() => state
              .mapPageAnimes[TypeVersionAnime.movie]?.listAnime
              .addAll(Anime.listDynamicToListAnime(results[2] as List<dynamic>))),
          Future.microtask(() => state
              .mapPageAnimes[TypeVersionAnime.tv]?.listAnime
              .addAll(Anime.listDynamicToListAnime(results[3] as List<dynamic>))),
          Future.microtask(() => state
              .mapPageAnimes[TypeVersionAnime.special]?.listAnime
              .addAll(Anime.listDynamicToListAnime(results[4] as List<dynamic>))),
          Future.microtask(() {
            state.mapPageAnimes.updateAll((key, value) {
              return value.copyWith(page: value.page + 1);
            });
          })
        ]);
        emit(state.copyWith(isObtainAllData: true, initLoad: false,lastAnimesAdd: state.listAnimes,listAringAnime: state.listAringAnime));
        await Future.wait(listFutures);
      } catch (e) {
        if (kDebugMode) {
          print('Error en el proceso de carga masiva de animes: $e');
        }
      }
      emit(state.copyWith(isObtainAllData: true, initLoad: false));
    }, transformer: restartable());

    on<ObtainDataAnime>((event, emit) async {
      CompleteAnime? anime;
      try {
        emit(state.copyWith(initLoad: true));
        await animeRepository
            .obtainAnimeForTitleAndId(
                state: state, id: event.id, title: event.title)
            .then((value) async {
          if (!animeRepository.checkExitAnimeForAnime(
              title: value!.title, listAnimes: state.listAnimes)) {
            anime = value;
            state.listAnimes.add(value);
            if (!value.isCheckBanner) {
              await animeRepository.checkAnimeBanner(anime: value).then((res) {
                value.isNotBannerCorrect = res;
                value.isCheckBanner = true;
                emit(state.copyWith());
              });
            }
          }
          emit(state.copyWith(initLoad: false));
          await Future.wait([
            if (anime != null && !anime!.isCheckListAnimesRelated)
              animeRepository.search(event.title).then((value) {
                anime?.listAnimeRelated.addAll(value
                    .map((e) => Anime.fromJson(e))
                    .where((element) => element.title != anime?.title)
                    .toList());
                anime!.isCheckListAnimesRelated = true;
                emit(state.copyWith());
              }),
            // Navegación
            if (event.context.mounted)
              Future.microtask(() => navigationAnimated(
                  context: event.context,
                  isReplacement: false,
                  navigateWidget:
                      DetailAnimePage(idAnime: event.id, tag: event.tag)))
          ]);
        });
      } catch (e) {}
      emit(state.copyWith(initLoad: false));
    });

    on<UpdatePage>((event, emit) async {
      if (state.mapPageAnimes[event.typeVersionAnime]!.isObtainAllData) {
        emit(state.copyWith(initLoad: false));
        return;
      }
      emit(state.copyWith(initLoad: true));
      await animeRepository
          .searchByType(
              listTypeAnimePage: state.mapPageAnimes[event.typeVersionAnime]!)
          .then(
        (data) {
          state.mapPageAnimes.update(event.typeVersionAnime, (value) {
            if (data.isEmpty) {
              value.isObtainAllData = true;
              return value;
            } else {
              value.listAnime.addAll(Anime.listDynamicToListAnime(data));
              return value.copyWith(page: value.page + 1);
            }
          });
        },
      );
      emit(state.copyWith(initLoad: false, mapPageAnimes: state.mapPageAnimes));
    }, transformer: restartable());

    on<SearchAnime>((event, emit) async {
      emit(state.copyWith(initLoad: true));

      try {
        final response = await animeRepository.search(event.query);
        final searchResults = response.map((e) => Anime.fromJson(e)).toList();

        emit(state.copyWith(
          initLoad: false,
          listSearchAnime: searchResults,
        ));
      } catch (e) {
        // Aquí puedes manejar errores si lo necesitas
        emit(state.copyWith(initLoad: false));
      }
    });

    on<ObtainDataGender>((event, emit) async {
      if (state.mapGeneresAnimes[event.gender]!.listAnime.isNotEmpty) {
        navigationAnimated(
            context: event.context,
            navigateWidget: GenderListAnimePage(gender: event.gender));
        return;
      }
      emit(state.copyWith(initLoad: true));
      await animeRepository
          .searchByGender(gender: state.mapGeneresAnimes[event.gender]!)
          .then(
        (value) {
          state.mapGeneresAnimes.update(
            event.gender,
            (page) {
              if (value.isEmpty) {
                return page.copyWith(isObtainAllData: true);
              }
              page.listAnime.addAll(value.map((e) => Anime.fromJson(e)));
              return page.copyWith(page: page.page + 1);
            },
          );
          emit(state.copyWith(initLoad: false));

          navigationAnimated(
              context: event.context,
              navigateWidget: GenderListAnimePage(gender: event.gender));
        },
      );
    });

    on<LoadMoreGender>((event, emit) async {
      if (state.mapGeneresAnimes[event.gender]!.isObtainAllData) {
        return;
      }
      emit(state.copyWith(initLoad: true));
      await animeRepository
          .searchByGender(gender: state.mapGeneresAnimes[event.gender]!)
          .then(
        (value) {
          state.mapGeneresAnimes.update(
            event.gender,
            (page) {
              if (value.isEmpty) {
                return page.copyWith(isObtainAllData: true);
              }
              page.listAnime.addAll(value.map((e) => Anime.fromJson(e)));
              return page.copyWith(page: page.page + 1);
            },
          );
          emit(state.copyWith(initLoad: false));
        },
      );
    }, transformer: restartable());

    on<ObtainVideoSever>((event, emit) async {
      if (event.episode.servers.isEmpty) {
        emit(state.copyWith(initLoad: true));
        await animeRepository
            .obtainVideoServerOfEpisode(id: event.episode.id)
            .then((value) {
          event.episode.servers.addAll(value);
        });
        emit(state.copyWith(initLoad: false));
      }

      navigationAnimated(
          isReplacement: event.isNavigationReplacement,
          context: event.context,
          navigateWidget: ServerListPage(
              idAnime: event.anime.id, idEpisode: event.episode.id));
    });
  }

  List<Future<Null>> transformListStringToListFuture(
      {required List<String> listAnime,
      required List<CompleteAnime> listAnimeState}) {
    return listAnime.map((id) async {
      try {
        final anime = await animeRepository.obtainAnimeForId(id: id);
        if (anime != null) {
          listAnimeState.add(anime);
          listAnimeState.sort((a, b) => a.title.compareTo(b.title));
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error al obtener anime con ID $id: $e');
        }
      }
    }).toList();
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
              reverseTransitionDuration: const Duration(milliseconds: 700),
              transitionDuration: const Duration(seconds: 1),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  navigateWidget,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                    opacity: CurvedAnimation(
                        parent: animation,
                        curve: Curves.linear,
                        reverseCurve: Curves.linear),
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

  @override
  AnimeState? fromJson(Map<String, dynamic> json) {
    return AnimeState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AnimeState state) {
    return state.toJson();
  }
}
