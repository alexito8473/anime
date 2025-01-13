import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/anime.dart';
import '../../data/typeAnime/type_data.dart';
import '../../domain/bloc/anime_bloc.dart';
import '../screens/list_anime_screen.dart';
import '../widgets/banner/banner_widget.dart';
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
  bool isOpen = false;

  @override
  void initState() {
    controller.addListener(() => setState(() {}));
    super.initState();
  }

  Function(BuildContext context, int index) itemBuilder(
      {required List<Anime> listAnime,
      required Size size,
      required bool isPortrait}) {
    if (widget.typeAnime == TypeAnime.ADD) {
      return (BuildContext context, int index) {
        return BannerAnime(anime: listAnime[index], tag: widget.tag);
      };
    }
    return (BuildContext context, int index) {
      if (index < listAnime.length) {
        return BannerAnime(anime: listAnime[index], tag: widget.tag);
      }
      return const BannerAnimeReload();
    };
  }

  List<Anime> filterAnime({required List<Anime> listAnime}) {
    return listAnime
        .where((element) =>
            element.title.toLowerCase().contains(controller.text.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isAdd = widget.typeAnime.isAdd();
    List<Anime> listAnime = filterAnime(
        listAnime: isAdd
            ? context.watch<AnimeBloc>().state.lastAnimesAdd
            : context.watch<AnimeBloc>().state.listAnimeSave);
    return AnimationLoadPage(
        child: ListAnimeScreen(
            tag: widget.tag,
            title: widget.title,
            colorTitle: widget.colorTitle,
            itemBuilder: itemBuilder(
                listAnime: listAnime, size: size, isPortrait: isPortrait),
            count: isAdd || isOpen
                ? listAnime.length
                : context.watch<AnimeBloc>().state.countAnimeSave,
            controller: controller));
  }
}
