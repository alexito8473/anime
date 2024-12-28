import 'package:anime/data/server.dart';
import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:animeflv/animeflv.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import '../../data/anime.dart';

class AnimeRepository {
  final AnimeFlv animeFlv;
  const AnimeRepository({required this.animeFlv});

  Future<List<ServerInfo>> obtainVideoServerOfEpisode(
      {required String id}) async {
    return (await animeFlv.getVideoServers(id))
        .map((server) => ServerInfo.fromJson(server))
        .toList();
  }

  Future<Anime?> obtainAnimeForTitleAndId(
      {required AnimeState state,
      required String title,
      required String id}) async {
    Anime? anime;
    if ((anime = checkExitAnimeForLastEpisode(
            title: title, listAnimes: state.listAnimes)) ==
        null) {
      anime = Anime.fromJson(await animeFlv.getAnimeInfo(id));
      anime.isNotBannerCorrect = await _checkAnimeBanner(anime: anime);
    }
    return anime;
  }

  Anime? checkExitAnimeForLastEpisode(
      {required String title, required List<Anime> listAnimes}) {
    return listAnimes.where((element) => element.title == title).firstOrNull;
  }

  Future<bool> _checkAnimeBanner({required Anime anime}) async {
    final response = await http.get(Uri.parse(anime.banner));
    if (response.statusCode != 200) return false;
    final image = img.decodeImage(response.bodyBytes);
    if (image == null) return false;
    final referencePixel = image.getPixel(0, 0);
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        if (image.getPixel(x, y) != referencePixel) {
          return false; // Si un píxel es diferente, no es monocromática
        }
      }
    }
    return true;
  }
}
