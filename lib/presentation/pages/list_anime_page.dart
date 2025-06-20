import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/anime.dart';
import '../../data/enums/type_data.dart';
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

  @override
  void initState() {
    controller.addListener(() => setState(() {}));
    super.initState();
  }

  List<Anime> filterAnime({required List<Anime> listAnime}) {
    if (isFirstReset && !widget.typeAnime.isAdd()) {
      listAnime.sort((a, b) => a.title.compareTo(b.title));
      setState(() {
        isFirstReset = false;
      });
    }

    return listAnime
        .where((element) =>
            element.title.toLowerCase().contains(controller.text.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AnimationLoadPage(
        child: BlocSelector<AnimeBloc, AnimeState, List<Anime>>(
            selector: (state) => state.lastAnimesAdd,
            builder: (context, state) {
              final List<Anime> listAnime = filterAnime(listAnime: state);
              return ListAnimeScreen(
                  tag: widget.tag,
                  title: widget.title,
                  colorTitle: widget.colorTitle,
                  controller: controller,
                  listAnime: listAnime,
                  onTapElement: (String id, String? tag) {});
            }));
  }
}
