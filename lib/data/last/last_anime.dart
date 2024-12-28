import '../interface/last_interface.dart';

class LastAnime implements LastInterface{
  final String id;
  final String title;
  final String poster;
  final String banner;
  final String synopsis;
  final String rating;
  final String type;

  const LastAnime(
      {required this.id,
        required this.title,
        required this.poster,
        required this.banner,
        required this.synopsis,
        required this.rating,
        required this.type});

  factory LastAnime.fromJson(Map<dynamic, dynamic> json) {
    return LastAnime(
      id: json['id'],
      title: json['title'],
      poster: json['poster'],
      banner: json['banner'],
      synopsis: json['synopsis'],
      rating: json['rating'],
      type: json['type']
    );
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