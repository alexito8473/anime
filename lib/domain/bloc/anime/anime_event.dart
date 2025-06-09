part of 'anime_bloc.dart';

class AnimeEvent {}

class ObtainDataAnime extends AnimeEvent {
  final String title;
  final String id;
  final BuildContext context;
  final String? tag;
  final void Function() navigationPage;

  ObtainDataAnime(
      {required this.context,
      required this.title,
      required this.id,
      required this.tag,
      required this.navigationPage});
}

class SearchAnime extends AnimeEvent {
  final String query;

  SearchAnime({required this.query});
}

class LoadNewState extends AnimeEvent {
  final AnimeState animeState;

  LoadNewState({required this.animeState});
}

class Reset extends AnimeEvent {}

class ObtainDataType extends AnimeEvent {
  final BuildContext context;
  final TypeVersionAnime type;

  ObtainDataType(this.type, {required this.context});
}

class ObtainDataGender extends AnimeEvent {
  final BuildContext context;
  final Gender gender;

  ObtainDataGender({required this.context, required this.gender});
}

class LoadMoreGender extends AnimeEvent {
  final BuildContext context;
  final Gender gender;

  LoadMoreGender({required this.context, required this.gender});
}

class ObtainVideoSever extends AnimeEvent {
  final Episode episode;
  final CompleteAnime anime;
  final BuildContext context;
  final bool isNavigationReplacement;

  ObtainVideoSever(
      {required this.anime,
      required this.episode,
      required this.context,
      required this.isNavigationReplacement});
}

class Save extends AnimeEvent {
  final bool isSave;

  Save({required this.isSave});
}

class UpdatePage extends AnimeEvent {
  final TypeVersionAnime typeVersionAnime;

  UpdatePage({required this.typeVersionAnime});
}

class SaveAnime extends Save {
  final CompleteAnime anime;
  final TypeMyAnimes typeMyAnimes;

  SaveAnime(
      {required this.anime, required super.isSave, required this.typeMyAnimes});
}

class SaveEpisode extends Save {
  final Episode episode;

  SaveEpisode({required this.episode, required super.isSave});
}

class ObtainData extends AnimeEvent {
  final BuildContext context;

  ObtainData({required this.context});
}

class ObtainDataRebuild extends ObtainData {
  ObtainDataRebuild({required super.context});
}
