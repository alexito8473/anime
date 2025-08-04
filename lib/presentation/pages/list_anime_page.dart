import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/interface/anime_interface.dart';
import '../../data/enums/type_data.dart';
import '../../data/model/last_episode.dart';
import '../../domain/bloc/anime/anime_bloc.dart';
import '../screens/list_anime_screen.dart';
import '../widgets/load/load_widget.dart';

class ListAnimePage extends StatefulWidget {
  final String? tag;
  final TypeAnime typeAnime;
  final String title;
  final Color colorTitle;

  const ListAnimePage(
      {super.key,
      required this.tag,
      required this.typeAnime,
      required this.title,
      required this.colorTitle});

  @override
  State<ListAnimePage> createState() => _ListAnimePageState();
}

class _ListAnimePageState extends State<ListAnimePage> {
  final TextEditingController controller = TextEditingController();
  bool isFirstReset = true;
  bool isEpisode = false;

  @override
  void initState() {
    isEpisode = widget.typeAnime.isEpisode();
    controller.addListener(() => setState(() {}));
    super.initState();
  }

  List<AnimeBanner> filterAnime({required List<AnimeBanner> listAnime}) {
    if (isFirstReset && !widget.typeAnime.isEpisode()) {
      listAnime.sort((a, b) => a.getTitle().compareTo(b.getTitle()));
      setState(() {
        isFirstReset = false;
      });
    }

    return listAnime
        .where((element) => element
            .getTitle()
            .toLowerCase()
            .contains(controller.text.toLowerCase()))
        .toList();
  }

  void navigation({required String id, String? tag, required String title}) {
    context
        .read<AnimeBloc>()
        .add(ObtainDataAnime(context: context, id: id, tag: tag, title: title));
  }

  @override
  Widget build(BuildContext context) {
    if (isEpisode) {
      return AnimationLoadPage(
          child: BlocSelector<AnimeBloc, AnimeState, List<LastEpisode>>(
              selector: (state) => state.lastEpisodes,
              builder: (context, state) {
                return ListAnimeScreen(
                    tag: widget.tag,
                    title: widget.title,
                    colorTitle: widget.colorTitle,
                    controller: controller,
                    listAnime: filterAnime(listAnime: state),
                    onTapElement: navigation);
              }));
    }
    return AnimationLoadPage(
        child: ListAnimeScreen(
            tag: widget.tag,
            title: widget.title,
            colorTitle: widget.colorTitle,
            controller: controller,
            listAnime: filterAnime(
                listAnime: context.watch<AnimeBloc>().state.lastAnimesAdd),
            onTapElement: navigation));
  }
}
