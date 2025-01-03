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

  Widget floatingChild({required Size size}) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        width: isOpen ? size.width * 0.8 : size.width * 0.13,
        child: Row(
            spacing: size.width * 0.01,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                decoration: BoxDecoration(
                    color: const Color(0xFF1C2833),
                    border: Border.all(color: Colors.white.withAlpha(40)),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'Buscar...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10))),
              )),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isOpen ? controller.clear() : controller.text = '';
                      isOpen = !isOpen;
                    });
                  },
                  child: Container(
                      width: size.width * 0.12,
                      height: size.width * 0.12,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: const Color(0xFF1C2833),
                          border: Border.all(color: Colors.white.withAlpha(40)),
                          borderRadius: BorderRadius.circular(10)),
                      child: isOpen
                          ? const Icon(Icons.search_off)
                          : const Icon(Icons.search))),
            ]));
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
            count: isAdd||isOpen
                ? listAnime.length
                :  context.watch<AnimeBloc>().state.countAnimeSave,
            floatingChild: floatingChild(size: size)));
  }
}
