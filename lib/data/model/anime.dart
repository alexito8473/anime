import 'package:anime/data/model/basic_anime.dart';

import '../interface/anime_interface.dart';

class Anime extends BasicAnime implements AnimeInterface {
  final String poster;
  final String banner;
  final String synopsis;
  final String rating;

  Anime(
      {required super.id,
      required super.title,
      required super.type,
      required this.poster,
      required this.banner,
      required this.synopsis,
      required this.rating});

  factory Anime.fromJson(Map<dynamic, dynamic> json) {
    return Anime(
        id: json['id'],
        title: json['title'],
        poster: json['poster'],
        banner: json['banner'],
        synopsis: json['synopsis'],
        rating: json['rating'],
        type: json['type']);
  }

  @override
  String idAnime() {
    return id;
  }

  @override
  String getTitle() {
    return title;
  }
}
