import 'anime.dart';
import 'basic_anime.dart';
import 'last_episode.dart';

class HomePageData {
  final List<Anime> listAnime;
  final List<LastEpisode> listLastEpisodes;
  final List<BasicAnime> listBasicAnime;

  const HomePageData(
      {required this.listAnime,
      required this.listLastEpisodes,
      required this.listBasicAnime});
}
