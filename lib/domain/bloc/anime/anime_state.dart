part of 'anime_bloc.dart';

class AnimeState {
  final List<CompleteAnime> listAnimes;
  final List<Anime> lastAnimesAdd;
  final List<LastEpisode> lastEpisodes;
  final List<BasicAnime> listAringAnime;
  final Map<TypeMyAnimes, List<CompleteAnime>> mapAnimesLoad;
  final Map<TypeVersionAnime, ListTypeAnimePage> mapPageAnimes;
  final Map<Gender, GenderAnimeForPage> mapGeneresAnimes;
  final Map<TypeMyAnimes, List<String>> mapAnimesSave;

  final List<Anime> listSearchAnime;
  final List<Anime> listFilmAnime;

  final List<String> listEpisodesView;
  final bool isObtainAllData;
  final bool initLoad;

  const AnimeState(
      {required this.lastEpisodes,
      required this.isObtainAllData,
      required this.listSearchAnime,
      required this.initLoad,
      required this.listAnimes,
      required this.listAringAnime,
      required this.mapAnimesLoad,
      required this.lastAnimesAdd,
      required this.listFilmAnime,
      required this.listEpisodesView,
      required this.mapPageAnimes,
      required this.mapGeneresAnimes,
      required this.mapAnimesSave});

  factory AnimeState.init() {
    final Map<TypeVersionAnime, ListTypeAnimePage> mapPageAnimes = {};
    final Map<Gender, GenderAnimeForPage> mapGeneresAnimes = {};
    final Map<TypeMyAnimes, List<CompleteAnime>> mapAnimesLoad = {};
    final Map<TypeMyAnimes, List<String>> mapAnimesSave = {};
    for (TypeVersionAnime versionAnime in TypeVersionAnime.values) {
      mapPageAnimes.putIfAbsent(
          versionAnime, () => ListTypeAnimePage.init(type: versionAnime));
    }
    for (TypeMyAnimes animes in TypeMyAnimes.values) {
      mapAnimesLoad.putIfAbsent(animes, () => List.empty(growable: true));
      mapAnimesSave.putIfAbsent(animes, () => List.empty(growable: true));
    }
    for (Gender animes in Gender.values) {
      mapGeneresAnimes.putIfAbsent(
          animes, () => GenderAnimeForPage.init(type: animes));
    }
    return AnimeState(
        lastEpisodes: List.empty(growable: true),
        isObtainAllData: false,
        initLoad: false,
        listAnimes: List.empty(growable: true),
        listAringAnime: List.empty(growable: true),
        lastAnimesAdd: List.empty(growable: true),
        listSearchAnime: List.empty(growable: true),
        listFilmAnime: List.empty(growable: true),
        listEpisodesView: List.empty(growable: true),
        mapAnimesLoad: mapAnimesLoad,
        mapAnimesSave: mapAnimesSave,
        mapPageAnimes: mapPageAnimes,
        mapGeneresAnimes: mapGeneresAnimes);
  }

  AnimeState copyWith(
      {bool? isObtainAllData,
      List<Anime>? lastAnimesAdd,
      List<LastEpisode>? lastEpisodes,
      List<CompleteAnime>? listAnimes,
      List<BasicAnime>? listAringAnime,
      List<Anime>? listSearchAnime,
      List<Anime>? listFilmAnime,
      Map<TypeVersionAnime, ListTypeAnimePage>? mapPageAnimes,
      Map<TypeMyAnimes, List<CompleteAnime>>? mapAnimesLoad,
      Map<TypeMyAnimes, List<String>>? mapAnimesSave,
      List<String>? listEpisodesView,
      Map<Gender, GenderAnimeForPage>? mapGeneresAnimes,
      bool? initLoad}) {
    return AnimeState(
        isObtainAllData: isObtainAllData ?? this.isObtainAllData,
        lastAnimesAdd: lastAnimesAdd ?? this.lastAnimesAdd,
        listAnimes: listAnimes ?? this.listAnimes,
        lastEpisodes: lastEpisodes ?? this.lastEpisodes,
        initLoad: initLoad ?? this.initLoad,
        listAringAnime: listAringAnime ?? this.listAringAnime,
        listSearchAnime: listSearchAnime ?? this.listSearchAnime,
        listFilmAnime: listFilmAnime ?? this.listFilmAnime,
        listEpisodesView: listEpisodesView ?? this.listEpisodesView,
        mapAnimesSave: mapAnimesSave ?? this.mapAnimesSave,
        mapAnimesLoad: mapAnimesLoad ?? this.mapAnimesLoad,
        mapGeneresAnimes: mapGeneresAnimes ?? this.mapGeneresAnimes,
        mapPageAnimes: mapPageAnimes ?? this.mapPageAnimes);
  }

  Map<String, dynamic> toJson() {
    return {
      'mapAnimesSave':
          mapAnimesSave.map((key, value) => MapEntry(key.name, value)),
      'listEpisodesView': listEpisodesView
    };
  }

  factory AnimeState.fromJson(Map<String, dynamic> json) {
    // ignore: prefer_collection_literals
    final Map<TypeVersionAnime, ListTypeAnimePage> mapPageAnimes = Map();
    // ignore: prefer_collection_literals
    final Map<TypeMyAnimes, List<CompleteAnime>> mapAnimesLoad = Map();
    // ignore: prefer_collection_literals
    final Map<Gender, GenderAnimeForPage> mapGeneresAnimes = Map();
    Map<TypeMyAnimes, List<String>> mapAnimesSave;
    for (TypeVersionAnime versionAnime in TypeVersionAnime.values) {
      mapPageAnimes.putIfAbsent(
          versionAnime, () => ListTypeAnimePage.init(type: versionAnime));
    }
    for (TypeMyAnimes animes in TypeMyAnimes.values) {
      mapAnimesLoad.putIfAbsent(animes, () => List.empty(growable: true));
    }
    mapAnimesSave = (json['mapAnimesSave'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
            TypeMyAnimes.values.firstWhere((e) => e.name == key),
            List<String>.from(value)));
    for (Gender animes in Gender.values) {
      mapGeneresAnimes.putIfAbsent(
          animes, () => GenderAnimeForPage.init(type: animes));
    }
    return AnimeState(
        isObtainAllData: false,
        initLoad: false,
        mapAnimesLoad: mapAnimesLoad,
        mapPageAnimes: mapPageAnimes,
        mapAnimesSave: mapAnimesSave,
        listEpisodesView: json['listEpisodesView'] != null
            ? List<String>.from(json['listEpisodesView'])
            : List.empty(growable: true),
        listAnimes: List.empty(growable: true),
        lastAnimesAdd: List.empty(growable: true),
        lastEpisodes: List.empty(growable: true),
        listAringAnime: List.empty(growable: true),
        listSearchAnime: List.empty(growable: true),
        listFilmAnime: List.empty(growable: true),
        mapGeneresAnimes: mapGeneresAnimes);
  }
}
