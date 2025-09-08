import 'dart:convert';
import 'dart:math';

import 'package:anime/constansT.dart';
import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/data/model/gender_anime_page.dart';
import 'package:anime/data/model/list_type_anime_page.dart';
import 'package:anime/data/model/server.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import '../../../data/model/anime.dart';
import '../../../data/model/basic_anime.dart';
import '../../../data/model/home_page_data.dart';
import '../../../data/model/last_episode.dart';
import '../../../utils/parse_table.dart';

class AnimeRepository {
  Future<List<ServerInfo>> obtainVideoServerOfEpisode(
      {required String id}) async =>
      (await getVideoServers(id))
          .map((server) => ServerInfo.fromJson(server))
          .toList();

  Future<CompleteAnime?> obtainAnimeForTitleAndId({required AnimeState state,
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

  Future<HomePageData> obtainHomePageData() async {
    final http.Response res = await http.Client().get(
        Uri.parse(Constants.baseUrl));
    return HomePageData(
        listAnime: _getLastAddedAnimes(res),
        listLastEpisodes: _getLastEpisodes(res),
        listBasicAnime: _getAiringAnimes(res));
  }

  Future<List<Anime>> getLastAddedAnimes() async {
    return _getLastAddedAnimes(
        await http.Client().get(Uri.parse(Constants.baseUrl)));
  }

  Future<List<BasicAnime>> getAiringAnimes() async {
    return _getAiringAnimes(
        await http.Client().get(Uri.parse(Constants.baseUrl)));
  }

  Future<List> search(String searchQuery) async {
    final res = await http.Client().get(
        Uri.parse('${Constants.searchUrl}$searchQuery'),
        headers: {'Accept-Encoding': 'gzip'});

    if (res.statusCode != 200) return [];

    return compute(
        _parseAnimeList, utf8.decode(res.bodyBytes, allowMalformed: true));
  }

  Future<List> searchByType(
      {required ListTypeAnimePage listTypeAnimePage}) async {
    final res = await http.Client().get(
        Uri.parse(
            '${Constants.searchUrlForType}${listTypeAnimePage.typeVersionAnime
                .value}&page=${listTypeAnimePage.page}'),
        headers: {'Accept-Encoding': 'gzip'});

    if (res.statusCode != 200) return [];

    return compute(
        _parseAnimeList, utf8.decode(res.bodyBytes, allowMalformed: true));
  }

  Future<List> searchByGender({required GenderAnimeForPage gender}) async {
    final res = await http.Client().get(
        Uri.parse(
            '${Constants.searchUrlForGender}${gender.typeVersionAnime
                .search}&page=${gender.page}'),
        headers: {'Accept-Encoding': 'gzip'});

    if (res.statusCode != 200) return [];

    return compute(
        _parseAnimeList, utf8.decode(res.bodyBytes, allowMalformed: true));
  }

// Función optimizada para procesar en un `Isolate`
  List _parseAnimeList(String html) {
    final elements =
    BeautifulSoup(html).findAll('article', class_: 'Anime alt B');

    return elements
        .map((element) {
      try {
        final id = element
            .find('div', class_: 'Description')
            ?.find('a', class_: 'Button')?['href'];
        return {
          'id': id?.substring(1, id.length),
          'title': element
              .find('a')
              ?.find('h3')
              ?.text,
          'poster': element
              .find('div', class_: 'Image')
              ?.find('figure')
              ?.find('img')?['src'],
          'banner': element
              .find('div', class_: 'Image')
              ?.find('figure')
              ?.find('img')?['src']
              ?.replaceAll('covers', 'banners')
              .trim(),
          'type': element
              .find('div', class_: 'Description')
              ?.find('p')
              ?.find('span', class_: 'Type')
              ?.text,
          'synopsis': element
              .find('div', class_: 'Description')
              ?.findAll('p')[1]
              .text
              .trim(),
          'rating': element
              .find('div', class_: 'Description')
              ?.find('p')
              ?.find('span', class_: 'Vts')
              ?.text,
        };
      } catch (e) {
        return null; // Evita agregar elementos inválidos a la lista
      }
    })
        .where((element) => element != null)
        .toList();
  }

  Future<List> getVideoServers(String episodeId) async {
    List<Bs4Element> scripts;
    final http.Response res = await http.Client()
        .get(Uri.parse('${Constants.animeVideoUrl}$episodeId'));
    if (res.statusCode == 200) {
      scripts = BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true))
          .findAll('script');
      final servers = [];
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

  List<BasicAnime> _getAiringAnimes(http.Response res) {
    final airingAnimes = [];
    List<Bs4Element> airingAnimesElements;
    try {
      if (res.statusCode == 200) {
        if (kIsWeb) {
          airingAnimesElements = BeautifulSoup(jsonDecode(res.body)['contents'])
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
            'type': anime
                .find('', selector: '.Type')
                ?.string,
          });
        }
        return airingAnimes.map((e) => BasicAnime.fromJson(e)).toList();
      }
    // ignore: empty_catches
    } catch (e) {}
    return [];
  }

  List<Anime> _getLastAddedAnimes(http.Response res) {
    final lastAnimes = [];
    List<Bs4Element> lastAnimesElements;
    if (res.statusCode == 200) {
      lastAnimesElements =
          BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true))
              .findAll('', selector: '.ListAnimes article.Anime');

      for (var anime in lastAnimesElements) {
        final id = anime.a?['href'];
        lastAnimes.add({
          'id': id?.substring(1, id.length),
          'title': anime
              .find('', selector: 'a h3')
              ?.string,
          'poster':
          '${Constants.baseUrl}${anime.find(
              '', selector: '.Image figure img')?['src']}',
          'banner':
          '${Constants.baseUrl}${anime.find(
              '', selector: '.Image figure img')?['src']?.replaceAll(
              'covers', 'banners').trim()}',
          'type':
          anime
              .find('', selector: 'div.Description p span.Type')
              ?.string,
          'synopsis':
          anime.findAll('', selector: 'div.Description p')[1].string.trim(),
          'rating':
          anime
              .find('', selector: 'div.Description p span.Vts')
              ?.string,
        });
      }
      return lastAnimes.map((e) => Anime.fromJson(e)).toList();
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
    final res = await http.Client().get(
        Uri.parse('${Constants.baseUrl}/$animeId'),
        headers: {'Accept-Encoding': 'gzip'});

    if (res.statusCode != 200) return [];

    return compute(
        _parseAnimeEpisodes, utf8.decode(res.bodyBytes, allowMalformed: true));
  }

// 🌟 Función que procesa los resultados en un `Isolate`
  List _parseAnimeEpisodes(String html) {
    final soup = BeautifulSoup(html);

    final extraInfo = {
      'title': soup
          .find('h1', class_: 'Title')
          ?.text,
      'poster':
      '${Constants.baseUrl}${soup
          .find('div', class_: 'Image')
          ?.find('figure')
          ?.find('img')?['src']}',
      'synopsis':
      soup
          .find('div', class_: 'Description')
          ?.find('p')
          ?.text
          .trim(),
      'rating': soup
          .find('span', id: 'votes_prmd')
          ?.text,
      'debut': soup
          .find('p', class_: 'AnmStts')
          ?.text,
      'type': soup
          .find('span', class_: 'Type')
          ?.text,
    };
    extraInfo['banner'] = extraInfo['poster']?.replaceAll('covers', 'banners');

    // Obtener géneros
    final genres = [];
    final elements = soup.findAll('', selector: '.Nvgnrs a');
    for (var element in elements) {
      if (element['href']!.contains('=')) {
        genres.add(element['href']?.split('=')[1]);
      }
    }

    String? animeInfo;
    List episodesData = [];
    for (var script in soup.findAll('script')) {
      final contents = script.toString();
      if (contents.contains('var anime_info')) {
        animeInfo = contents.split('var anime_info = ')[1].split(';')[0];
      }
      if (contents.contains('var episodes = [')) {
        final data = contents.split('var episodes = ')[1].split(';')[0];
        episodesData = List.from(jsonDecode(data));
      }
    }

    if (animeInfo == null) return [];

    final infoIds = List.from(jsonDecode(animeInfo));
    final idAnime = infoIds[2];

    // Obtener episodios
    final episodes = episodesData.map((episodeData) {
      return {
        'anime': extraInfo['title'],
        'episode': episodeData[0],
        'id': '$idAnime-${episodeData[0]}',
        'imagePreview':
        '${Constants
            .baseEpisodeImgUrl}${infoIds[0]}/${episodeData[0]}/th_3.jpg',
      };
    }).toList();

    return [episodes, genres, extraInfo];
  }


  Future<List<LastEpisode>> getLastEpisodes() async {
    try {
      return _getLastEpisodes(
          await http.Client().get(Uri.parse(Constants.baseUrl)));
    } catch (e) {
      return [];
    }
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
      // Descargar la imagen antes de enviar los datos a `compute`
      final response = await http.get(Uri.parse(anime.banner));

      if (response.statusCode != 200 || response.bodyBytes.isEmpty) {
        return false; // La imagen no es válida
      }

      return await compute(_checkBannerCompute, response.bodyBytes);
    } catch (e) {
      if (kDebugMode) {
        print('Error al verificar el banner: $e');
      }
      return false;
    }
  }

  List<LastEpisode> _getLastEpisodes(http.Response res) {
    final lastEpisodes = [];
    final List<Bs4Element> lastEpisodesElements;
    try {
      if (res.statusCode == 200) {
        lastEpisodesElements =
            BeautifulSoup(utf8.decode(res.bodyBytes, allowMalformed: true))
                .findAll('', selector: '.ListEpisodios li a.fa-play');

        for (var episode in lastEpisodesElements) {
          lastEpisodes.add({
            'anime': episode
                .find('', selector: '.Title')
                ?.string,
            'episode': episode
                .find('', selector: '.Capi')
                ?.string
                .replaceAll('Episodio ', ''),
            'id': episode['href']?.split('ver/')[1],
            'imagePreview':
            '${Constants.baseUrl}${episode.find(
                '', selector: '.Image img')?['src']}'
          });
        }
        return lastEpisodes.map((e) => LastEpisode.fromJson(e)).toList();
      }
      return [];
    // ignore: empty_catches
    } catch (e) {}
    return [];
  }

// 🖼 Función de análisis de imagen en un Isolate
  bool _checkBannerCompute(Uint8List imageData) {
    try {
      final image = img.decodeImage(imageData);
      if (image == null) return false;

      // 📌 Verificar si la imagen es monocromática
      const int sampleCount = 50;
      final random = Random();
      final referencePixel = image.getPixel(0, 0);

      for (int i = 0; i < sampleCount; i++) {
        final x = random.nextInt(image.width);
        final y = random.nextInt(image.height);

        if (image.getPixel(x, y) != referencePixel) {
          return false; // Imagen con variación de color
        }
      }
      return true; // Imagen monocromática
    } catch (e) {
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
      // ignore: empty_catches
      } catch (e) {}
    }
    return [];
  }
}
