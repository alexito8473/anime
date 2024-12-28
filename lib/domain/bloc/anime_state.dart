part of 'anime_bloc.dart';

class AnimeState {
  final List<Anime> listAnimes;
  final List<LastAnime> lastAnimesAdd;
  final List<LastEpisode> lastEpisodes;
  final List<AiringAnime> listAringAnime;
  final bool isComplete;
  final bool initLoad;
  const AnimeState(
      {required this.lastEpisodes,
      required this.isComplete,
      required this.initLoad,
      required this.listAnimes,
      required this.listAringAnime,
      required this.lastAnimesAdd});
  AnimeState copyWith(
      {bool? isComplete,
      List<LastAnime>? lastAnimesAdd,
      AnimeFlv? animeFlv,
      List<LastEpisode>? lastEpisodes,
      List<Anime>? listAnimes,
      List<AiringAnime>? listAringAnime,
      bool? initLoad}) {
    return AnimeState(
        isComplete: isComplete ?? this.isComplete,
        lastAnimesAdd: lastAnimesAdd ?? this.lastAnimesAdd,
        listAnimes: listAnimes ?? this.listAnimes,
        lastEpisodes: lastEpisodes ?? this.lastEpisodes,
        initLoad: initLoad ?? this.initLoad,
        listAringAnime: listAringAnime ?? this.listAringAnime);
  }
}
