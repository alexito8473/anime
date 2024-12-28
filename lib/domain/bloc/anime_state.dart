part of 'anime_bloc.dart';

class AnimeState {
  final List<Anime> listAnimes;
  final List<LastAnime> lastAnimesAdd;
  final List<LastEpisode> lastEpisodes;
  final List<AiringAnime> listAringAnime;
  final bool isObtainAllData;
  final bool initLoad;
  const AnimeState(
      {required this.lastEpisodes,
      required this.isObtainAllData,
      required this.initLoad,
      required this.listAnimes,
      required this.listAringAnime,
      required this.lastAnimesAdd});

  factory AnimeState.init() {
    return AnimeState(
        lastEpisodes: List.empty(growable: true),
        isObtainAllData: false,
        initLoad: false,
        listAnimes: List.empty(growable: true),
        listAringAnime: List.empty(growable: true),
        lastAnimesAdd: List.empty(growable: true));
  }

  AnimeState copyWith(
      {bool? isObtainAllData,
      List<LastAnime>? lastAnimesAdd,
      List<LastEpisode>? lastEpisodes,
      List<Anime>? listAnimes,
      List<AiringAnime>? listAringAnime,
      bool? initLoad}) {
    return AnimeState(
        isObtainAllData: isObtainAllData ?? this.isObtainAllData,
        lastAnimesAdd: lastAnimesAdd ?? this.lastAnimesAdd,
        listAnimes: listAnimes ?? this.listAnimes,
        lastEpisodes: lastEpisodes ?? this.lastEpisodes,
        initLoad: initLoad ?? this.initLoad,
        listAringAnime: listAringAnime ?? this.listAringAnime);
  }
}
