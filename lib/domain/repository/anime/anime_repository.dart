import 'dart:convert';


import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/data/model/server.dart';
import 'global.dart';
import 'package:http/http.dart' as http;

class AnimeRepository {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  AnimeRepository();

  Future<void> saveList(List<CompleteAnime> listAnime) async =>
      await asyncPrefs.setString(
          'listSafeAnime', jsonEncode(listAnime.map((e) => e.id).toList()));

  Future<List<String>> loadList() async {
    final String? jsonString = await asyncPrefs.getString('listSafeAnime');
    if (jsonString != null) {
      return List<String>.from(jsonDecode(jsonString));
    }
    return [];
  }

  Future<List<ServerInfo>> obtainVideoServerOfEpisode(
          {required String id}) async =>
      (await getVideoServers(id))
          .map((server) => ServerInfo.fromJson(server))
          .toList();

  Future<CompleteAnime?> obtainAnimeForTitleAndId(
      {required AnimeState state,
      required String title,
      required String id}) async {
    CompleteAnime? anime;
    if ((anime = checkExitAnimeForLastEpisode(
            title: title, listAnimes: state.listAnimes)) ==
        null) {
      anime = await obtainAnimeForId(id: id);
    }
    return anime;
  }

  Future<CompleteAnime?> obtainAnimeForId({required String id}) async {
    CompleteAnime? anime;
    anime = CompleteAnime.fromJson(await _getAnimeInfo(id));
    anime.isNotBannerCorrect = await _checkAnimeBanner(anime: anime);
    return anime;
  }

  Future<List> getLastAddedAnimes() async {
    final res = await http.Client().get(Uri.parse(BASE_URL));
    if (res.statusCode == 200) {
      var lastAnimes = [];
      final lastAnimesElements =
          BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true))
              .findAll('', selector: '.ListAnimes article.Anime');
      for (var anime in lastAnimesElements) {
        final id = anime.a?['href'];
        lastAnimes.add({
          'id': id?.substring(1, id.length),
          'title': anime.find('', selector: 'a h3')?.string,
          'poster':
              '$BASE_URL${anime.find('', selector: '.Image figure img')?['src']}',
          'banner':
              '$BASE_URL${anime.find('', selector: '.Image figure img')?['src']?.replaceAll('covers', 'banners').trim()}',
          'type':
              anime.find('', selector: 'div.Description p span.Type')?.string,
          'synopsis':
              anime.findAll('', selector: 'div.Description p')[1].string.trim(),
          'rating':
              anime.find('', selector: 'div.Description p span.Vts')?.string,
        });
      }
      return lastAnimes;
    }
    return [];
  }

  Future<List> getAiringAnimes() async {
    final res = await http.Client().get(Uri.parse(BASE_URL));
    try {
      if (res.statusCode == 200) {
        var airingAnimes = [];
        final airingAnimesElements =
            BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true))
                .findAll('', selector: '.ListSdbr li');
        for (var anime in airingAnimesElements) {
          final id = anime.a?['href'];
          airingAnimes.add({
            'id': id?.substring(1, id.length),
            'title': anime.a?.string
                .replaceAll(anime.find('', selector: '.Type')!.string, '')
                .trim(),
            'type': anime.find('', selector: '.Type')?.string,
          });
        }
        return airingAnimes;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> search(String searchQuery) async {
    final res = await http.Client().get(Uri.parse('$SEARCH_URL$searchQuery'));
    if (res.statusCode == 200) {
      final elements =
          BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true))
              .findAll('article', class_: 'Anime alt B');
      var ret = [];
      for (var element in elements) {
        var id =
            element.find('', selector: 'div.Description a.Button')?['href'];
        try {
          ret.add({
            'id': id?.substring(1, id.length),
            'title': element.find('', selector: 'a h3')?.string,
            'poster': element.find('', selector: '.Image figure img')?['src'],
            'banner': element
                .find('', selector: '.Image figure img')?['src']
                ?.replaceAll('covers', 'banners')
                .trim(),
            'type': element
                .find('', selector: 'div.Description p span.Type')
                ?.string,
            'synopsis': element
                .findAll('', selector: 'div.Description p')[1]
                .string
                .trim(),
            'rating': element
                .find('', selector: 'div.Description p span.Vts')
                ?.string,
          });
        } catch (e) {}
      }
      return ret;
    }
    return [];
  }

  Future<List> getVideoServers(String episodeId) async {
    final res =
        await http.Client().get(Uri.parse('$ANIME_VIDEO_URL$episodeId'));
    if (res.statusCode == 200) {
      final scripts =
          BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true))
              .findAll('script');
      var servers = [];
      for (var script in scripts) {
        final content = script.toString();
        if (content.contains('var videos = {')) {
          final videos = content.split('var videos = ')[1].split(';')[0];
          final data = json.decode(videos);
          if (data.containsKey('SUB')) servers.add(data['SUB']);
        }
      }
      return servers[0];
    }
    return [];
  }

  Future<Map> _getAnimeInfo(String animeId) async {
    final animeEpisodesInfo = await _getAnimeEpisodesInfo(animeId);
    final extraInfo = animeEpisodesInfo[2]!;
    return {
      'id': animeId,
      'title': extraInfo['title'],
      'poster': extraInfo['poster'],
      'banner': extraInfo['banner'],
      'synopsis': extraInfo['synopsis'],
      'rating': extraInfo['rating'],
      'debut': extraInfo['debut'],
      'type': extraInfo['type'],
      'genres': animeEpisodesInfo[1]!,
      'episodes': List.from(animeEpisodesInfo[0]!.reversed),
    };
  }

  Future<List> _getAnimeEpisodesInfo(String animeId) async {
    final res = await http.Client().get(Uri.parse('$BASE_URL/$animeId'));
    final soup;
    final idAnime;
    final elements;
    var extraInfo;
    var genres;
    var infoIds = [];
    var episodesData = [];
    var episodes = [];
    var contents;
    var animeInfo;
    var data;
    if (res.statusCode == 200) {
      soup = BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true));
      extraInfo = {
        'title': soup.find('', selector: 'h1.Title')?.string,
        'poster':
            '$BASE_URL${soup.find("", selector: "div.Image figure img")?["src"]}',
        'synopsis': soup.find('', selector: 'div.Description p')?.string.trim(),
        'rating': soup.find('', selector: 'span#votes_prmd')?.string,
        'debut': soup.find('', selector: 'p.AnmStts')?.string,
        'type': soup.find('', selector: 'span.Type')?.string,
      };
      extraInfo['banner'] =
          extraInfo['poster']?.replaceAll('covers', 'banners');
      genres = [];
      elements = soup.findAll('', selector: '.Nvgnrs a');
      for (var element in elements) {
        if (element['href']!.contains('=')) {
          genres.add(element['href']?.split('=')[1]);
        }
      }
      for (var script in soup.findAll('script')) {
        contents = script.toString();
        if (contents.contains('var anime_info')) {
          animeInfo = contents.split('var anime_info = ')[1].split(';')[0];
          infoIds.add(json.decode(animeInfo));
        }
        if (contents.contains('var episodes = [')) {
          data = contents.split('var episodes = ')[1].split(';')[0];
          for (var episodeData in json.decode(data)) {
            episodesData.add([episodeData[0], episodeData[1]]);
          }
        }
      }
      idAnime = infoIds[0][2];
      for (var episodeData in episodesData) {
        episodes.add({
          'anime': extraInfo['title'],
          'episode': episodeData[0],
          'id': '$idAnime-${episodeData[0]}',
          'imagePreview':
              '$BASE_EPISODE_IMG_URL${infoIds[0][0]}/${episodeData[0]}/th_3.jpg',
        });
      }
      return [episodes, genres, extraInfo];
    }
    return [];
  }

  Future<List> getLastEpisodes() async {
    final res = await http.Client().get(Uri.parse(BASE_URL));
    var lastEpisodes = [];
    final lastEpisodesElements;
    if (res.statusCode == 200) {
      lastEpisodesElements =
          BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true))
              .findAll('', selector: '.ListEpisodios li a.fa-play');
      for (var episode in lastEpisodesElements) {
        lastEpisodes.add({
          'anime': episode.find('', selector: '.Title')?.string,
          'episode': episode
              .find('', selector: '.Capi')
              ?.string
              .replaceAll('Episodio ', ''),
          'id': episode['href']?.split('ver/')[1],
          'imagePreview':
              '$BASE_URL${episode.find('', selector: '.Image img')?['src']}'
        });
      }
      return lastEpisodes;
    }
    return [];
  }

  CompleteAnime? checkExitAnimeForLastEpisode(
      {required String title, required List<CompleteAnime> listAnimes}) {
    return listAnimes.where((CompleteAnime element) => element.title == title).firstOrNull;
  }

  bool isExitsAnime(
      {required String title, required List<CompleteAnime> listAnimes}) {
    return listAnimes.any((element) => element.title == title);
  }

  Stream<CompleteAnime> fetchAnimeStream(List<String> listSaveAnimeIds) async* {
    CompleteAnime? anime;
    for (var idAnime in listSaveAnimeIds) {
      try {
        anime = await obtainAnimeForId(id: idAnime);
        if (anime != null) {
          yield anime; // Devuelve el resultado parcialmente
        }
      } catch (e) {
        print('Error al obtener anime con ID $idAnime: $e');
      }
    }
  }

  Future<bool> _checkAnimeBanner({required CompleteAnime anime}) async {
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

  Future<List> downloadLinksByEpisodeId(String id) async {
    final res = await http.Client().get(Uri.parse('$ANIME_VIDEO_URL$id'));
    final rows;
    var ret;
    var resZS;
    if (res.statusCode == 200) {
      final table =
          BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true))
              .find('table', attrs: {'class': 'RTbl'});
      try {
        rows = parseTable(table);
        ret = [];
        for (var row in rows) {
          if (row['FORMATO'].string == 'SUB') {
            ret.add({
              'server': row['SERVIDOR'].string,
              'url': row['DESCARGAR'].a['href'].toString().replaceAllMapped(
                  RegExp(
                      r'^http[s]?://ouo.io/[A-Za-z0-9]+/[A-Za-z0-9]+\?[A-Za-z0-9]+='),
                  (match) => '"${match.group}"')
            });
          }
        }
        for (var server in ret) {
          if (server['server'] == 'Zippyshare') {
            resZS = await http.Client().get(Uri.parse(server['url']));
            if (resZS.statusCode == 200) {
              final scripts = BeautifulSoup(
                      utf8.decode(resZS.bodyBytes, allowMalformed: true))
                  .findAll('script');
              for (var script in scripts) {
                final content = script.toString();
                if (content.contains('var n = ')) {
                  final n = int.parse(content
                          .split('\n')[1]
                          .trim()
                          .split('var n = ')[1]
                          .split('%')[0]) %
                      2;
                  final b = int.parse(content
                          .split('\n')[2]
                          .trim()
                          .split('var b = ')[1]
                          .split('%')[0]) %
                      3;
                  final z = int.parse(content
                      .split('\n')[3]
                      .trim()
                      .split('var z = ')[1]
                      .split(';')[0]);
                  final title = content.split('\n')[4].trim().split('"')[3];
                  final serverurl = server['url']
                      .replaceAll('v', 'd')
                      .replaceAll('file.html', '${n + b + z - 3}$title');
                  server['url'] = serverurl;
                }
              }
            }
          }
        }
        return ret;
      } catch (e) {}
    }
    return [];
  }
}
