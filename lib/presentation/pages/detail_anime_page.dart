import 'package:anime/data/typeAnime/types_vision.dart';
import 'package:anime/domain/bloc/anime_bloc.dart';
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
  int _currentPage = 0;

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
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

  void onTapSaveEpisode(bool isSave, Episode episode) {
    context
        .read<AnimeBloc>()
        .add(SaveEpisode(episode: episode, isSave: isSave));
  }

  void onTap(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      CompleteAnime anime = state.listAnimes
          .firstWhere((element) => element.id == widget.idAnime);
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
                  },
                ),
              )));
    });
  }
}
