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
  bool isNotBannerCorrect;

  Anime(
      {required this.id,
      required this.title,
      required this.poster,
      required this.banner,
      required this.synopsis,
      required this.rating,
      required this.debut,
      required this.type,
      required this.genres,
      required this.isNotBannerCorrect,
      required this.episodes});

  factory Anime.fromJson(Map<dynamic, dynamic> json) {
    var genresFromJson = json['genres'];
    List<String>? genresList = List<String>.from(genresFromJson);
    var episodesFromJson = json['episodes'] as List;
    List<Episode>? episodesList = episodesFromJson
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
      isNotBannerCorrect: true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'poster': poster,
      'banner': banner,
      'synopsis': synopsis,
      'rating': rating,
      'debut': debut,
      'type': type,
      'genres': genres,
      'episodes': episodes.map((episode) => episode.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'Anime{id: $id, title: $title, poster: $poster, banner: $banner, synopsis: $synopsis, rating: $rating, debut: $debut, type: $type, genres: $genres, episodes: $episodes, isNotBannerCorrect: $isNotBannerCorrect}';
  }
}
