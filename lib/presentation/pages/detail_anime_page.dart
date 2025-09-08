import 'dart:io';

import 'package:anime/data/enums/type_my_animes.dart';
import 'package:anime/data/enums/types_vision.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../data/model/complete_anime.dart';
import '../../data/model/episode.dart';
import '../screens/detail_anime_screen.dart';
import '../widgets/load/load_widget.dart';
import 'package:share_plus/share_plus.dart';

class DetailAnimePage extends StatefulWidget {
  final String idAnime;
  final String? tag;

  const DetailAnimePage({super.key, required this.idAnime, required this.tag});

  @override
  State<DetailAnimePage> createState() => _DetailAnimePageState();
}

class _DetailAnimePageState extends State<DetailAnimePage> {
  final TextEditingController _controller = TextEditingController();
  late CompleteAnime anime;
  late bool isSave;
  TypesVision typesVision = TypesVision.all;
  late TypeMyAnimes miAnime;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    anime = context
        .read<AnimeBloc>()
        .state
        .listAnimes
        .firstWhere((anime) => anime.id == widget.idAnime);
    miAnime = checkTypeAnime();
    isSave = miAnime != TypeMyAnimes.NONE;
    _controller.addListener(() => setState(() {}));
  }

  void navigation({required String id, String? tag, required String title}) {
    context
        .read<AnimeBloc>()
        .add(ObtainDataAnime(context: context, id: id, tag: tag, title: title));
  }

  TypeMyAnimes checkTypeAnime() {
    final animeBloc = context.read<AnimeBloc>().state.mapAnimesLoad;
    return TypeMyAnimes.values.firstWhere(
      (type) =>
          animeBloc[type]?.any((anime) => anime.id == widget.idAnime) ?? false,
      orElse: () => TypeMyAnimes.NONE,
    );
  }

  void changeTypeVision({required TypesVision? type}) {
    if (type == null || typesVision == type) {
      return;
    }
    setState(() => typesVision = type);
  }

  List<Episode> filteredList(
      {required List<Episode> list,
      required String text,
      required bool isConfig}) {
    final filtered = text.isEmpty
        ? list
        : list.where((ep) => ep.episode.toString().contains(text)).toList();

    filtered.sort((a, b) => isConfig ? a.compareTo(b) : b.compareTo(a));

    final watchedEpisodes = context.watch<AnimeBloc>().state.listEpisodesView;
    return typesVision == TypesVision.noVision
        ? filtered.where((ep) => !watchedEpisodes.contains(ep.id)).toList()
        : typesVision == TypesVision.vision
            ? filtered.where((ep) => watchedEpisodes.contains(ep.id)).toList()
            : filtered;
  }

  void saveAnime(bool isSave, CompleteAnime anime, TypeMyAnimes typeMyAnimes) {
    context.read<AnimeBloc>().add(
        SaveAnime(anime: anime, isSave: isSave, typeMyAnimes: typeMyAnimes));
  }

  void onTapSaveEpisode(bool isSave, Episode episode) {
    context
        .read<AnimeBloc>()
        .add(SaveEpisode(episode: episode, isSave: isSave));
  }

  Future<void> openDialog({required CompleteAnime anime}) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('¿Cuál es su categoría?',
                style: Theme.of(context).textTheme.titleLarge),
            backgroundColor: Colors.grey.shade800,
            content: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<TypeMyAnimes>(
                    value: miAnime,
                    underline: const SizedBox(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                    borderRadius: BorderRadius.circular(15),
                    dropdownColor: Colors.grey.shade900,
                    icon: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.orange),
                    items: TypeMyAnimes.values
                        .map((vision) => DropdownMenuItem(
                              value: vision,
                              child: Text(vision.name,
                                  style: const TextStyle(color: Colors.white)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value == null || miAnime == value) return;
                      setState(() => miAnime = value);
                      saveAnime(isSave, anime, value);
                      Navigator.of(context).pop();
                    }))));
  }

  void onTap(int index) => setState(() => _currentPage = index);
  void shareTextAndUrl() async{

    try {
      // 1. Descargar la imagen
      final response = await http.get(Uri.parse(anime.poster));
      final bytes = response.bodyBytes;

      // 2. Guardar la imagen en un archivo temporal
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/anime_image.png');
      await file.writeAsBytes(bytes);

      // 3. Compartir la imagen junto con texto
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Hey mira este es el anime que te quiero compartir: "${anime.title}" '
            'tiene un total de ${anime.episodes.length} episodios en estos momentos',
        subject: 'Abrir mi app',
      );
    } catch (e) {
      print('Error compartiendo la imagen: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<AnimeBloc, AnimeState>(
        listener: (context, state) {
          setState(() {
            anime = context
                .read<AnimeBloc>()
                .state
                .listAnimes
                .firstWhere((anime) => anime.id == widget.idAnime);
            miAnime = checkTypeAnime();
            isSave = miAnime != TypeMyAnimes.NONE;
          });
        },
        child: AnimationLoadPage(
            child: DetailAnimeScreen(
                    anime: anime,
                    currentPage: _currentPage,
                    allEpisode: anime.episodes,
                    textController: _controller,
                    tag: widget.tag,
                    typesVision: typesVision,
                    miAnime: miAnime,
                    textFiltered: _controller.text,
                    isSave: isSave,
                    navigation: navigation,
                    shareAnime: shareTextAndUrl,
                    onTap: onTap,
                    filteredList: filteredList,
                    onTapSaveEpisode: onTapSaveEpisode,
                    changeTypeVision: changeTypeVision,
                    openDialog: openDialog)));
  }
}
