import 'package:anime/data/interface/last_interface.dart';

class LastEpisode implements LastInterface{
  final String anime;
  final String episode;
  final String id;
  final String imagePreview;

  const LastEpisode(
      {required this.anime,
      required this.episode,
      required this.id,
      required this.imagePreview});

  factory LastEpisode.fromJson(Map<String, dynamic> json) {
    return LastEpisode(
        anime: json['anime'],
        episode: json['episode'],
        id: json['id'],
        imagePreview: json['imagePreview']);
  }
  @override
  String idAnime(){
    return "anime/${id.substring(0,id.length-(episode.length+1)).toLowerCase().replaceAll(" ", "-")}";
  }

  @override
  String getTitle() {
    return anime;
  }
}
