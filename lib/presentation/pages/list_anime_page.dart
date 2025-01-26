import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/anime.dart';
import '../../data/typeAnime/type_data.dart';
import '../../domain/bloc/anime_bloc.dart';
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
    if(isFirstReset && !widget.typeAnime.isAdd()){
      listAnime.sort((a, b) => a.title.compareTo(b.title));
      setState(() {
        isFirstReset=false;
      });
    }

    return listAnime
        .where((element) =>
            element.title.toLowerCase().contains(controller.text.toLowerCase()))
        .toList();
  }

  List<Anime> selectAnime() {
    return widget.typeAnime.isAdd()
        ? context.watch<AnimeBloc>().state.lastAnimesAdd
        : context.watch<AnimeBloc>().state.listAnimeSave;
  }

  @override
  Widget build(BuildContext context) {
    List<Anime> listAnime = filterAnime(listAnime: selectAnime());
    return AnimationLoadPage(
        child: ListAnimeScreen(
            tag: widget.tag,
            title: widget.title,
            colorTitle: widget.colorTitle,
            controller: controller,
            listAnime: listAnime));
  }
}
