import 'episode.dart';

class Anime {
  final String id;
  final String title;
  final String poster;
  final String banner;
  final String synopsis;
  final String rating;
  final String debut;
  final String type;
  final List<String> genres;
  final List<Episode> episodes;

  const Anime(
      {required this.id,
      required this.title,
      required this.poster,
      required this.banner,
      required this.synopsis,
      required this.rating,
      required this.debut,
      required this.type,
      required this.genres,
      required this.episodes});

  factory Anime.fromJson(Map<String, dynamic> json) {
    var genresFromJson = json['genres'];
    List<String> genresList = List<String>.from(genresFromJson);

    var episodesFromJson = json['episodes'] as List;
    List<Episode> episodesList = episodesFromJson
        .map((episodeJson) => Episode.fromJson(episodeJson))
        .toList();

    return Anime(
      id: json['id'],
      title: json['title'],
      poster: json['poster'],
      banner: json['banner'],
      synopsis: json['synopsis'],
      rating: json['rating'],
      debut: json['debut'],
      type: json['type'],
      genres: genresList,
      episodes: episodesList,
    );
  }
}
