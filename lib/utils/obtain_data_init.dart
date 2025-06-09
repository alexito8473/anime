import 'package:flutter/foundation.dart';

import '../data/enums/type_my_animes.dart';
import '../data/enums/type_version_anime.dart';
import '../data/model/anime.dart';
import '../data/model/basic_anime.dart';
import '../data/model/complete_anime.dart';
import '../data/model/last_episode.dart';
import '../domain/bloc/anime/anime_bloc.dart';
import '../domain/repository/anime/anime_repository.dart';

List<Future<Null>> transformListStringToListFuture(
    {required List<String> listAnime,
      required List<CompleteAnime> listAnimeState,
      required AnimeRepository animeRepository}) {
  return listAnime.map((id) async {
    try {
      final anime = await animeRepository.obtainAnimeForId(id: id);
      if (anime != null) {
        listAnimeState.add(anime);
        listAnimeState.sort((a, b) => a.title.compareTo(b.title));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error al obtener anime con ID $id: $e");
      }
    }
  }).toList();
}

Future<void> extractDataSave(AnimeState animeState) async {
  AnimeRepository animeRepository = AnimeRepository();
  List<Future<Null>> listFutures = List.empty(growable: true);
  for (TypeMyAnimes animes
  in TypeMyAnimes.values.where((element) => element != TypeMyAnimes.NONE)) {
    listFutures.addAll(transformListStringToListFuture(
        listAnime: animeState.mapAnimesSave[animes]!,
        listAnimeState: animeState.mapAnimesLoad[animes]!,
        animeRepository: animeRepository));
  }
  await Future.wait(listFutures);
}

Future<AnimeState> extractData(AnimeState animeState) async {
  AnimeRepository animeRepository = AnimeRepository();

  try {
    final results = await Future.wait([
      animeRepository.getLastEpisodes(),
      animeRepository.getLastAddedAnimes(),
      animeRepository.getAiringAnimes(),
      animeRepository.searchByType(
          listTypeAnimePage: animeState.mapPageAnimes[TypeVersionAnime.ova]!),
      animeRepository.searchByType(
          listTypeAnimePage: animeState.mapPageAnimes[TypeVersionAnime.movie]!),
      animeRepository.searchByType(
          listTypeAnimePage: animeState.mapPageAnimes[TypeVersionAnime.tv]!),
      animeRepository.searchByType(
          listTypeAnimePage:
          animeState.mapPageAnimes[TypeVersionAnime.special]!),
    ]);
    await Future.wait([
      Future.microtask(() => animeState.lastEpisodes
          .addAll(results[0].map((e) => LastEpisode.fromJson(e)).toList())),
      Future.microtask(() => animeState.lastAnimesAdd
          .addAll(results[1].map((e) => Anime.fromJson(e)).toList())),
      Future.microtask(() => animeState.listAringAnime
          .addAll(results[2].map((e) => BasicAnime.fromJson(e)).toList())),
      Future.microtask(() => animeState
          .mapPageAnimes[TypeVersionAnime.ova]?.listAnime
          .addAll(Anime.listDynamicToListAnime(results[3]))),
      Future.microtask(() => animeState
          .mapPageAnimes[TypeVersionAnime.movie]?.listAnime
          .addAll(Anime.listDynamicToListAnime(results[4]))),
      Future.microtask(() => animeState
          .mapPageAnimes[TypeVersionAnime.tv]?.listAnime
          .addAll(Anime.listDynamicToListAnime(results[5]))),
      Future.microtask(() => animeState
          .mapPageAnimes[TypeVersionAnime.special]?.listAnime
          .addAll(Anime.listDynamicToListAnime(results[6]))),
      Future.microtask(() {
        animeState.mapPageAnimes.updateAll((key, value) {
          return value.copyWith(page: value.page + 1);
        });
      })
    ]);
  } catch (e) {
    if (kDebugMode) {
      print("Error en el proceso de carga masiva de animes: $e");
    }
  }
  return animeState;
}
