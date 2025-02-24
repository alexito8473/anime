import 'package:anime/data/typeAnime/type_my_animes.dart';
import 'package:anime/data/typeAnime/types_vision.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/complete_anime.dart';
import '../../data/model/episode.dart';
import '../screens/detail_anime_screen.dart';
import '../widgets/load/load_widget.dart';

class DetailAnimePage extends StatefulWidget {
  final String idAnime;
  final String? tag;

  const DetailAnimePage({super.key, required this.idAnime, required this.tag});

  @override
  State<DetailAnimePage> createState() => _DetailAnimePageState();
}

class _DetailAnimePageState extends State<DetailAnimePage> {
  final TextEditingController _controller = TextEditingController();
  TypesVision typesVision = TypesVision.ALL;
  late TypeMyAnimes miAnime = TypeMyAnimes.NONE;
  int _currentPage = 0;

  @override
  void initState() {
    miAnime = checkTypeAnime();
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  TypeMyAnimes checkTypeAnime() {
    List<TypeMyAnimes> typeMyAnimes = TypeMyAnimes.values
        .where((element) => context
            .read<AnimeBloc>()
            .state
            .mapAnimesLoad[element]!
            .map((e) => e.id)
            .contains(widget.idAnime))
        .toList();
    return typeMyAnimes.isEmpty ? TypeMyAnimes.NONE : typeMyAnimes.first;
  }

  List<Episode> filteredList(List<Episode> list, String text) {
    List<Episode> listFiltered = List.empty(growable: true);
    List<String> episodes = context.watch<AnimeBloc>().state.listEpisodesView;
    if (text.isEmpty) {
      listFiltered.addAll(list);
    } else {
      listFiltered.addAll(list
          .where((element) => element.episode.toString().contains(text))
          .toList());
    }
    if (typesVision == TypesVision.NO_VISION) {
      return listFiltered
          .where((element) => !episodes.contains(element.id))
          .toList();
    } else if (typesVision == TypesVision.VISION) {
      return listFiltered
          .where((element) => episodes.contains(element.id))
          .toList();
    }
    return listFiltered;
  }

  void saveAnime(
          {required bool isSave,
          required CompleteAnime anime,
          required TypeMyAnimes typeMyAnimes}) =>
      context.read<AnimeBloc>().add(
          SaveAnime(anime: anime, isSave: isSave, typeMyAnimes: typeMyAnimes));

  void onTapSaveEpisode(bool isSave, Episode episode) => context
      .read<AnimeBloc>()
      .add(SaveEpisode(episode: episode, isSave: isSave));

  Future<void> openDialog(
      {required CompleteAnime anime, required bool isSave}) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('¿Cual es su categoría?',
                  style: Theme.of(context).textTheme.titleLarge),
              backgroundColor: Colors.grey.shade800,
              content: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(10)),
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
                                  style: const TextStyle(color: Colors.white))))
                          .toList(),
                      onChanged: (value) {
                        if (miAnime == value) {
                          return;
                        }
                        if (value == null) {
                          return;
                        }
                        setState(() => miAnime = value);
                        saveAnime(
                            anime: anime, isSave: isSave, typeMyAnimes: value);
                        Navigator.of(context).pop();
                      })),
            ));
  }

  void onTap(int index) => setState(() => _currentPage = index);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      CompleteAnime anime = state.listAnimes
          .firstWhere((element) => element.id == widget.idAnime);
      bool isSave = miAnime != TypeMyAnimes.NONE;
      return AnimationLoadPage(
          child: DetailAnimeScreen(
              size: MediaQuery.sizeOf(context),
              anime: anime,
              onTap: onTap,
              currentPage: _currentPage,
              listAnimeFilter: filteredList(anime.episodes, _controller.text),
              textController: _controller,
              tag: widget.tag,
              onTapSaveEpisode: onTapSaveEpisode,
              safeAnime: Row(
                children: [
                  if (miAnime != TypeMyAnimes.NONE)
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      child: Text(
                        miAnime.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                      ),
                    ),
                  IconButton(
                      onPressed: () async {
                        await openDialog(isSave: isSave, anime: anime);
                      },
                      isSelected: isSave,
                      style: const ButtonStyle(
                          elevation: WidgetStatePropertyAll(200)),
                      selectedIcon:
                          const Icon(Icons.autorenew, color: Colors.orange),
                      icon:
                          const Icon(CupertinoIcons.heart, color: Colors.white))
                ],
              ),
              action: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButton<TypesVision>(
                      value: typesVision,
                      underline: const SizedBox(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                      borderRadius: BorderRadius.circular(15),
                      dropdownColor: Colors.grey.shade900,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.orange),
                      items: TypesVision.values
                          .map((vision) => DropdownMenuItem(
                              value: vision,
                              child: Text(vision.content,
                                  style: const TextStyle(color: Colors.white))))
                          .toList(),
                      onChanged: (value) {
                        if (typesVision == value) {
                          return;
                        }
                        if (value == null) {
                          return;
                        }
                        setState(() => typesVision = value);
                      }))));
    });
  }
/*

   */
}
