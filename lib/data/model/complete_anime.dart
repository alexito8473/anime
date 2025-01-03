import 'anime.dart';
import 'episode.dart';
class CompleteAnime extends Anime {
  final String debut;
  final List<String> genres;
  final List<Episode> episodes;
  bool isNotBannerCorrect;

  CompleteAnime(
      {required super.id,
      required super.title,
      required super.poster,
      required super.banner,
      required super.synopsis,
      required super.rating,
      required super.type,
      required this.debut,
      required this.genres,
      required this.isNotBannerCorrect,
      required this.episodes});

  factory CompleteAnime.fromJson(Map<dynamic, dynamic> json) {
    var genresFromJson = json['genres'];
    List<String>? genresList = List<String>.from(genresFromJson);
    var episodesFromJson = json['episodes'] as List;
    List<Episode>? episodesList = episodesFromJson
        .map((episodeJson) => Episode.fromJson(episodeJson))
        .toList();
    return CompleteAnime(
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
