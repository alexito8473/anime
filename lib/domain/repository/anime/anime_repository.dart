import 'dart:convert';

import 'package:anime/data/server.dart';
import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:image/image.dart' as img;
import '../../../data/anime.dart';
import 'global.dart';
import 'package:http/http.dart' as http;

class AnimeRepository {
  const AnimeRepository();
  Future<List<ServerInfo>> obtainVideoServerOfEpisode(
      {required String id}) async {
    return (await getVideoServers(id))
        .map((server) => ServerInfo.fromJson(server))
        .toList();
  }

  Future<Anime?> obtainAnimeForTitleAndId(
      {required AnimeState state,
      required String title,
      required String id}) async {
    Anime? anime;
    if ((anime = _checkExitAnimeForLastEpisode(
            title: title, listAnimes: state.listAnimes)) ==
        null) {
      anime = Anime.fromJson(await getAnimeInfo(id));
      anime.isNotBannerCorrect = await _checkAnimeBanner(anime: anime);
    }
    return anime;
  }

  Future<List> getLastAddedAnimes() async {
    // get request to base animeflv url
    final res = await http.Client().get(Uri.parse(BASE_URL));
    if (res.statusCode == 200) {
      // get html and look for last animes list
      final body = utf8.decode(res.bodyBytes, allowMalformed: true);
      final soup = BeautifulSoup(body);
      var lastAnimes = [];
      final lastAnimesElements =
          soup.findAll('', selector: '.ListAnimes article.Anime');
      // for every anime found we save some data
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
      // return last animes found
      return lastAnimes;
    }
    return [];
  }

  // =================================================================================================================================================
  // function to get on air animes
  Future<List> getAiringAnimes() async {
    // get request to base animeflv url
    final res = await http.Client().get(Uri.parse(BASE_URL));
    try {
      if (res.statusCode == 200) {
        final body = utf8.decode(res.bodyBytes, allowMalformed: true);
        final soup = BeautifulSoup(body);
        var airingAnimes = [];
        final airingAnimesElements = soup.findAll('', selector: '.ListSdbr li');
        // for every anime found we save some data
        for (var anime in airingAnimesElements) {
          final id = anime.a?['href'];
          airingAnimes.add({
            'id': id?.substring(1, id.length),
            'title': anime.a?.string
                .replaceAll('${anime.find('', selector: '.Type')!.string}', '')
                .trim(),
            'type': anime.find('', selector: '.Type')?.string,
          });
        }
        // return list with on air animes
        return airingAnimes;
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future<List> search(String searchQuery) async {
    // get request with the given query
    final res = await http.Client().get(Uri.parse('$SEARCH_URL$searchQuery'));
    if (res.statusCode == 200) {
      // get the body and look for the animes found
      final body = utf8.decode(res.bodyBytes, allowMalformed: true);
      final soup = BeautifulSoup(body);
      final elements = soup.findAll('article', class_: 'Anime alt B');
      var ret = [];
      // for each of the animes found we'll save some data
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
      // return the list of animes found
      return ret;
    }
    return [];
  }

  // =================================================================================================================================================
  // function that gives you the servers of the episode with id = given id
  Future<List> getVideoServers(String episodeId) async {
    // get request with the anime url using the given id
    final res =
        await http.Client().get(Uri.parse('$ANIME_VIDEO_URL$episodeId'));
    if (res.statusCode == 200) {
      // get html and look for the scripts as animeflv saves the servers in one
      final body = utf8.decode(res.bodyBytes, allowMalformed: true);
      final soup = BeautifulSoup(body);
      final scripts = soup.findAll('script');
      var servers = [];
      // for every script found we'll look for the one with the servers
      for (var script in scripts) {
        final content = script.toString();
        if (content.contains('var videos = {')) {
          final videos = content.split('var videos = ')[1].split(';')[0];
          final data = json.decode(videos);
          if (data.containsKey('SUB')) servers.add(data['SUB']);
        }
      }
      // return a list of available servers with their data
      return servers[0];
    }
    return [];
  }

  // =================================================================================================================================================
  // function to get the info of an anime with its episodes
  Future<Map> getAnimeInfo(String animeId) async {
    // call function to get episodes info
    final animeEpisodesInfo = await _getAnimeEpisodesInfo(animeId);

    final episodes = animeEpisodesInfo[0]!;
    final genres = animeEpisodesInfo[1]!;
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
      'genres': genres,
      'episodes': List.from(episodes.reversed),
    };
  }

  // =================================================================================================================================================
  // function to get episodesInfo
  Future<List> _getAnimeEpisodesInfo(String animeId) async {
    // get request with url using given animeId
    final res = await http.Client().get(Uri.parse('$BASE_URL/$animeId'));
    if (res.statusCode == 200) {
      final body = utf8.decode(res.bodyBytes, allowMalformed: true);
      final soup = BeautifulSoup(body);

      // saving some extra info about the anime that is not about the episodes
      var extraInfo = {
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
      // getting the genres of the anime
      var genres = [];
      final elements = soup.findAll('', selector: '.Nvgnrs a');
      for (var element in elements) {
        if (element['href']!.contains('='))
          genres.add(element['href']?.split('=')[1]);
      }

      // fetch the episodes
      var infoIds = [];
      var episodesData = [];
      var episodes = [];

      try {
        // for every script found in the html
        for (var script in soup.findAll('script')) {
          final contents = script.toString();
          // if the current script is the one with the episodes then we save the episode data
          if (contents.contains('var anime_info')) {
            final animeInfo =
                contents.split('var anime_info = ')[1].split(';')[0];
            infoIds.add(json.decode(animeInfo));
          }
          if (contents.contains('var episodes = [')) {
            final data = contents.split('var episodes = ')[1].split(';')[0];
            for (var episodeData in json.decode(data)) {
              episodesData.add([episodeData[0], episodeData[1]]);
            }
          }
        }
        // now we convert this data to a map with the episode, the episodeId and the preview
        final animeId = infoIds[0][2];
        for (var episodeData in episodesData) {
          episodes.add({
            'anime': extraInfo['title'],
            'episode': episodeData[0],
            'id': '$animeId-${episodeData[0]}',
            'imagePreview':
                '$BASE_EPISODE_IMG_URL${infoIds[0][0]}/${episodeData[0]}/th_3.jpg',
          });
        }
      } catch (e) {
        print("Error:"+e.toString());
      }
      // we return the episodes and the aditional fetched info
      return [episodes, genres, extraInfo];
    }
    return [];
  }

  Future<List> getLastEpisodes() async {
    // get request to base animeflv url
    final res = await http.Client().get(Uri.parse(BASE_URL));
    if (res.statusCode == 200) {
      final body = utf8.decode(res.bodyBytes, allowMalformed: true);
      final soup = BeautifulSoup(body);
      var lastEpisodes = [];
      final lastEpisodesElements =
          soup.findAll('', selector: '.ListEpisodios li a.fa-play');
      // for every episode found we save some data
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
      // return last episodes found
      return lastEpisodes;
    }
    return [];
  }

  Anime? _checkExitAnimeForLastEpisode(
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

  Future<List> downloadLinksByEpisodeId(String id) async {
    // get request using the provided id
    final res = await http.Client().get(Uri.parse('$ANIME_VIDEO_URL$id'));
    if (res.statusCode == 200) {
      // parse html to string and look for the table with the downloads info
      final body = utf8.decode(res.bodyBytes, allowMalformed: true);
      final soup = BeautifulSoup(body);
      final table = soup.find('table', attrs: {'class': 'RTbl'});

      try {
        // extract the links and save them into ret
        final rows = parseTable(table);
        var ret = [];

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
        // for zippyshare we can get a direct download link so we create it and replace it
        for (var server in ret) {
          if (server['server'] == 'Zippyshare') {
            final resZS = await http.Client().get(Uri.parse(server['url']));
            if (resZS.statusCode == 200) {
              final body = utf8.decode(resZS.bodyBytes, allowMalformed: true);
              final soup = BeautifulSoup(body);
              final scripts = soup.findAll('script');
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
        // return a list with the download links and info
        return ret;
      } catch (e) {}
    }
    return [];
  }
}
