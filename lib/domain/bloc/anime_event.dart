part of 'anime_bloc.dart';

class AnimeEvent {}

class ObtainDataAnime extends AnimeEvent {
  final String title;
  final String id;
  final BuildContext context;
  final String? tag;
  ObtainDataAnime(
      {required this.context,
      required this.title,
      required this.id,
      required this.tag});
}

class SearchAnime extends AnimeEvent {
  final String query;
  SearchAnime({required this.query});
}

class Reset extends AnimeEvent {}

class ObtainDataType extends AnimeEvent {
  final BuildContext context;
  final TypeVersionAnime type;
  ObtainDataType(this.type, {required this.context});
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

class SaveAnime extends Save {
  final CompleteAnime anime;

  SaveAnime({required this.anime, required super.isSave});
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
