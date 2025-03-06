import 'anime.dart';
import 'episode.dart';

class CompleteAnime extends Anime {
  final String debut;
  final List<String> genres;
  final List<Episode> episodes;
  bool isNotBannerCorrect;
  bool isCheckBanner;
  bool isCheckListAnimesRelated;
  final List<Anime> listAnimeRelated = List.empty(growable: true);

  CompleteAnime(
      {required super.id,
      required super.title,
      required super.poster,
      required super.banner,
      required super.synopsis,
      required super.rating,
      required super.type,
      required this.debut,
      required this.isCheckBanner,
      required this.genres,
      required this.isCheckListAnimesRelated,
      required this.isNotBannerCorrect,
      required this.episodes});

  factory CompleteAnime.fromJson(Map<dynamic, dynamic> json) {
    return CompleteAnime(
        id: json['id'],
        title: json['title'],
        poster: json['poster'],
        banner: json['banner'],
        synopsis: json['synopsis'],
        rating: json['rating'],
        debut: json['debut'],
        type: json['type'],
        genres: List<String>.from(json['genres']),
        episodes: (json['episodes'] as List)
            .map((episodeJson) => Episode.fromJson(episodeJson))
            .toList(),
        isNotBannerCorrect: true,
        isCheckListAnimesRelated: false,
        isCheckBanner: false);
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
