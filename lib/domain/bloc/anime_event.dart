part of 'anime_bloc.dart';

class AnimeEvent {}

class ObtainDataAnime extends AnimeEvent {
  final String title;
  final String id;
  final BuildContext context;
  ObtainDataAnime( {required this.context, required this.title,required this.id});
}
class Reset extends AnimeEvent {}

class ObtainVideoSever extends AnimeEvent {
  final Episode episode;
  final Anime anime;
  final BuildContext context;
  ObtainVideoSever(
      {required this.anime, required this.episode, required this.context});
}
