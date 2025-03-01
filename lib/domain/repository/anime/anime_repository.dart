import 'dart:convert';
import 'dart:math';

import 'package:anime/constans.dart';
import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/data/model/list_type_anime_page.dart';
import 'package:anime/data/model/server.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import '../../../utils/parse_table.dart';

class AnimeRepository {
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
    return CompleteAnime.fromJson(await _getAnimeInfo(id));
  }

  Future<List> getLastAddedAnimes() async {
    var lastAnimes = [];
    List<Bs4Element> lastAnimesElements;
    http.Response res = kIsWeb
        ? await http.Client()
            .get(Uri.parse(Constants.corsFilter + Constants.baseUrl))
        : await http.Client().get(Uri.parse(Constants.baseUrl));

    if (res.statusCode == 200) {
      if (kIsWeb) {
        lastAnimesElements = BeautifulSoup(jsonDecode(res.body)["contents"])
            .findAll('', selector: '.ListAnimes article.Anime');
      } else {
        lastAnimesElements =
            BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true))
                .findAll('', selector: '.ListAnimes article.Anime');
      }
      for (var anime in lastAnimesElements) {
        final id = anime.a?['href'];
        lastAnimes.add({
          'id': id?.substring(1, id.length),
          'title': anime.find('', selector: 'a h3')?.string,
          'poster':
              '${Constants.baseUrl}${anime.find('', selector: '.Image figure img')?['src']}',
          'banner':
              '${Constants.baseUrl}${anime.find('', selector: '.Image figure img')?['src']?.replaceAll('covers', 'banners').trim()}',
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
    http.Response res;
    var airingAnimes = [];
    List<Bs4Element> airingAnimesElements;
    if (kIsWeb) {
      res = await http.Client()
          .get(Uri.parse(Constants.corsFilter + Constants.baseUrl));
    } else {
      res = await http.Client().get(Uri.parse(Constants.baseUrl));
    }
    try {
      if (res.statusCode == 200) {
        if (kIsWeb) {
          airingAnimesElements = BeautifulSoup(jsonDecode(res.body)["contents"])
              .findAll('', selector: '.ListSdbr li');
        } else {
          airingAnimesElements =
              BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true))
                  .findAll('', selector: '.ListSdbr li');
        }
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
    } catch (e) {}
    return [];
  }

  Future<List> search(String searchQuery) async {
    http.Response res;
    List<Bs4Element> elements;
    if (kIsWeb) {
      res = await http.Client().get(Uri.parse(
          '${Constants.corsFilter}${Constants.searchUrl}$searchQuery'));
    } else {
      res = await http.Client()
          .get(Uri.parse('${Constants.searchUrl}$searchQuery'));
    }
    if (res.statusCode == 200) {
      if (kIsWeb) {
        elements = BeautifulSoup(jsonDecode(res.body)["contents"])
            .findAll('article', class_: 'Anime alt B');
      } else {
        elements =
            BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true))
                .findAll('article', class_: 'Anime alt B');
      }
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

  Future<List> searchByType(
      {required ListTypeAnimePage listTypeAnimePage}) async {
    http.Response res = kIsWeb
        ? await http.Client().get(Uri.parse(
            "${Constants.corsFilter + Constants.searchUrlForType}${listTypeAnimePage.typeVersionAnime.value}&page=${listTypeAnimePage.page}"))
        : await http.Client().get(Uri.parse(
            "${Constants.searchUrlForType}${listTypeAnimePage.typeVersionAnime.value}&page=${listTypeAnimePage.page}"));
    List<Bs4Element> elements;
    if (res.statusCode == 200) {
      elements = kIsWeb
          ? BeautifulSoup(jsonDecode(res.body)["contents"])
              .findAll('article', class_: 'Anime alt B')
          : BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true))
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
    List<Bs4Element> scripts;
    http.Response res = kIsWeb
        ? await http.Client().get(Uri.parse(
            '${Constants.corsFilter + Constants.animeVideoUrl}$episodeId'))
        : await http.Client()
            .get(Uri.parse('${Constants.animeVideoUrl}$episodeId'));
    if (res.statusCode == 200) {
      scripts = kIsWeb
          ? BeautifulSoup(jsonDecode(res.body)["contents"]).findAll('script')
          : BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true))
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
    http.Response res = kIsWeb
        ? await http.Client().get(
            Uri.parse('${Constants.corsFilter}${Constants.baseUrl}/$animeId'))
        : await http.Client().get(Uri.parse('${Constants.baseUrl}/$animeId'));
    BeautifulSoup soup;
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
      soup = kIsWeb
          ? BeautifulSoup(jsonDecode(res.body)["contents"])
          : BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true));
      extraInfo = {
        'title': soup.find('', selector: 'h1.Title')?.string,
        'poster':
            '${Constants.baseUrl}${soup.find("", selector: "div.Image figure img")?["src"]}',
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
              '${Constants.baseEpisodeImgUrl}${infoIds[0][0]}/${episodeData[0]}/th_3.jpg',
        });
      }
      return [episodes, genres, extraInfo];
    }
    return [];
  }

  Future<List> getLastEpisodes() async {
    http.Response res;
    var lastEpisodes = [];
    final List<Bs4Element> lastEpisodesElements;
    try {
      if (kIsWeb) {
        res = await http.Client()
            .get(Uri.parse(Constants.corsFilter + Constants.baseUrl));
      } else {
        res = await http.Client().get(Uri.parse(Constants.baseUrl));
      }
      if (res.statusCode == 200) {
        if (kIsWeb) {
          lastEpisodesElements = BeautifulSoup(jsonDecode(res.body)["contents"])
              .findAll('', selector: '.ListEpisodios li a.fa-play');
        } else {
          lastEpisodesElements =
              BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true))
                  .findAll('', selector: '.ListEpisodios li a.fa-play');
        }
        for (var episode in lastEpisodesElements) {
          lastEpisodes.add({
            'anime': episode.find('', selector: '.Title')?.string,
            'episode': episode
                .find('', selector: '.Capi')
                ?.string
                .replaceAll('Episodio ', ''),
            'id': episode['href']?.split('ver/')[1],
            'imagePreview':
                '${Constants.baseUrl}${episode.find('', selector: '.Image img')?['src']}'
          });
        }
        return lastEpisodes;
      }
      return [];
    } catch (e) {}
    return [];
  }

  CompleteAnime? checkExitAnimeForLastEpisode(
      {required String title, required List<CompleteAnime> listAnimes}) {
    return listAnimes
        .where((CompleteAnime element) => element.title == title)
        .firstOrNull;
  }

  bool checkExitAnimeForAnime(
      {required String title, required List<CompleteAnime> listAnimes}) {
    return listAnimes.any((CompleteAnime element) => element.title == title);
  }

  bool isExitsAnime(
      {required String title, required List<CompleteAnime> listAnimes}) {
    return listAnimes.any((element) => element.title == title);
  }

  Future<bool> checkAnimeBanner({required CompleteAnime anime}) async {
    try {
      final response = await http.get(Uri.parse(anime.banner));

      if (response.statusCode != 200) return false;

      final image = img.decodeImage(response.bodyBytes);
      if (image == null) return false;

      // Obtener un píxel de referencia en (0,0)
      final referencePixel = image.getPixel(0, 0);
      final random = Random();

      // Número de muestras aleatorias (ajústalo según la precisión deseada)
      const int sampleCount = 100;

      for (int i = 0; i < sampleCount; i++) {
        final x = random.nextInt(image.width);
        final y = random.nextInt(image.height);

        if (image.getPixel(x, y) != referencePixel) {
          return false; // Si un píxel aleatorio difiere, no es monocromática
        }
      }

      return true; // Si todas las muestras coinciden, la imagen es monocromática
    } catch (e) {
      print('Error al verificar el banner: $e');
      return false;
    }
  }

  Future<List> downloadLinksByEpisodeId(String id) async {
    final res =
        await http.Client().get(Uri.parse('${Constants.animeVideoUrl}$id'));
    final List rows;
    List ret;
    http.Response resZS;
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
