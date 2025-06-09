import 'package:anime/data/enums/type_my_animes.dart';
import 'package:anime/data/enums/types_vision.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/complete_anime.dart';
import '../../data/model/episode.dart';
import '../../domain/bloc/configuration/configuration_bloc.dart';
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

  TypeMyAnimes checkTypeAnime() {
    final animeBloc = context.read<AnimeBloc>().state.mapAnimesLoad;
    return TypeMyAnimes.values.firstWhere(
      (type) =>
          animeBloc[type]?.any((anime) => anime.id == widget.idAnime) ?? false,
      orElse: () => TypeMyAnimes.NONE,
    );
  }

  List<Episode> filteredList(List<Episode> list, String text, bool isConfig) {
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

  Future<void> openDialog(CompleteAnime anime) async {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
        builder: (context, stateConfig) {
      return BlocConsumer<AnimeBloc, AnimeState>(listener: (context, state) {
        setState(() {
          anime = context
              .read<AnimeBloc>()
              .state
              .listAnimes
              .firstWhere((anime) => anime.id == widget.idAnime);
          miAnime = checkTypeAnime();
          isSave = miAnime != TypeMyAnimes.NONE;
        });
      }, builder: (context, state) {
        return AnimationLoadPage(
            child: Scaffold(
                backgroundColor: Colors.black,
                body: DetailAnimeScreen(
                  size: size,
                  anime: anime,
                  onTap: onTap,
                  currentPage: _currentPage,
                  listAnimeFilter: filteredList(anime.episodes,
                      _controller.text, stateConfig.isUpwardList),
                  textController: _controller,
                  tag: widget.tag,
                  onTapSaveEpisode: onTapSaveEpisode,
                  safeAnime: Row(children: [
                    if (isSave)
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            miAnime.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                          )),
                    IconButton(
                        onPressed: () => openDialog(anime),
                        isSelected: isSave,
                        style: const ButtonStyle(
                            elevation: WidgetStatePropertyAll(200)),
                        selectedIcon:
                            const Icon(Icons.autorenew, color: Colors.orange),
                        icon: const Icon(CupertinoIcons.heart,
                            color: Colors.white))
                  ]),
                  action: Row(children: [
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(15)),
                      child: IconButton(
                        onPressed: () => context
                            .read<ConfigurationBloc>()
                            .add(ChangeOrderList()),
                        color: Colors.white,
                        isSelected: context
                            .read<ConfigurationBloc>()
                            .state
                            .isUpwardList,
                        icon: const Icon(Icons.arrow_downward),
                        selectedIcon: const Icon(Icons.arrow_upward),
                      ),
                    ),
                    Container(
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
                                        style: const TextStyle(
                                            color: Colors.white))))
                                .toList(),
                            onChanged: (value) {
                              if (value == null || typesVision == value) return;
                              setState(() => typesVision = value);
                            }))
                  ]),
                  onTapElement: (String id, String? tag) {},
                )));
      });
    });
  }
}
