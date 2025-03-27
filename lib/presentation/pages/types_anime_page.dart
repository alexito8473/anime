import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

import '../../data/enums/type_version_anime.dart';
import '../../data/model/list_type_anime_page.dart';
import '../../domain/bloc/anime/anime_bloc.dart';
import '../screens/type_anime_screen.dart';

class TypesAnimePage extends StatefulWidget {
  const TypesAnimePage({super.key});

  @override
  State<TypesAnimePage> createState() => _TypesAnimePageState();
}

class _TypesAnimePageState extends State<TypesAnimePage> {
  int _currentIndex = 0;
  final ScrollController _scrollControllerMovie = ScrollController();
  final ScrollController _scrollControllerOva = ScrollController();
  final ScrollController _scrollControllerSpecial = ScrollController();
  final ScrollController _scrollControllerTV = ScrollController();
  bool _canUpdateMovie = true;
  bool _canUpdateOva = true;
  bool _canUpdateSpecial = true;
  bool _canUpdateTV = true;
  final List<GlobalKey> _targetKeyList = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey()
  ];

  late final List<Widget> listScreenPage = [
    ListTypeScreen(
        scrollController: _scrollControllerMovie,
        type: TypeVersionAnime.MOVIE,
        targetKey: _targetKeyList[0]),
    ListTypeScreen(
        scrollController: _scrollControllerSpecial,
        type: TypeVersionAnime.SPECIAL,
        targetKey: _targetKeyList[1]),
    ListTypeScreen(
        scrollController: _scrollControllerOva,
        type: TypeVersionAnime.OVA,
        targetKey: _targetKeyList[2]),
    ListTypeScreen(
        scrollController: _scrollControllerTV,
        type: TypeVersionAnime.TV,
        targetKey: _targetKeyList[3])
  ];

  @override
  void initState() {
    context.read<AnimeBloc>().state.mapPageAnimes.forEach(
      (key, value) {
        get(key).addListener(() => loadMore(get(key), value));
      },
    );
    super.initState();
  }

  ScrollController get(TypeVersionAnime key) {
    switch (key) {
      case TypeVersionAnime.TV:
        return _scrollControllerTV;
      case TypeVersionAnime.OVA:
        return _scrollControllerOva;
      case TypeVersionAnime.MOVIE:
        return _scrollControllerMovie;
      case TypeVersionAnime.SPECIAL:
        return _scrollControllerSpecial;
    }
  }

  bool getBool(TypeVersionAnime key) {
    switch (key) {
      case TypeVersionAnime.TV:
        return _canUpdateTV;
      case TypeVersionAnime.OVA:
        return _canUpdateOva;
      case TypeVersionAnime.MOVIE:
        return _canUpdateMovie;
      case TypeVersionAnime.SPECIAL:
        return _canUpdateSpecial;
    }
  }

  void loadMore(
      ScrollController scrollController, ListTypeAnimePage page) async {
    if (page.isObtainAllData) {
      if (getBool(page.typeVersionAnime)) {
        setState(() {
          switch (page.typeVersionAnime) {
            case TypeVersionAnime.TV:
              _canUpdateTV = false;
            case TypeVersionAnime.OVA:
              _canUpdateOva = false;
            case TypeVersionAnime.MOVIE:
              _canUpdateMovie = false;
            case TypeVersionAnime.SPECIAL:
              _canUpdateSpecial = false;
          }
        });
      }
      return;
    }
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      final double currentScrollPosition = scrollController.position.pixels;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(currentScrollPosition - 100);
      });
      context
          .read<AnimeBloc>()
          .add(UpdatePage(typeVersionAnime: page.typeVersionAnime));
    }
  }

  @override
  void dispose() {
    _scrollControllerMovie.dispose();
    _scrollControllerOva.dispose();
    _scrollControllerSpecial.dispose();
    _scrollControllerTV.dispose();
    super.dispose();
  }

  void moveScroll(GlobalKey globalKey) {
    Scrollable.ensureVisible(globalKey.currentContext!,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  void changeIndex({required int index}) {
    if (_currentIndex == index) {
      moveScroll(_targetKeyList[index]);
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocListener<AnimeBloc, AnimeState>(
        listener: (context, state) {
          state.mapPageAnimes.forEach((key, value) {
            if (value.isObtainAllData && getBool(key)) {
              get(key).removeListener(
                () => loadMore(get(key), value),
              );
            }
          });
        },
        child: Scaffold(
            body: IndexedStack(index: _currentIndex, children: listScreenPage),
            bottomNavigationBar: SnakeNavigationBar.color(
                currentIndex: _currentIndex,
                backgroundColor: Colors.grey.shade900,
                elevation: 2,
                shadowColor: Colors.white.withAlpha(100),
                snakeShape: SnakeShape.indicator,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.only(
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    bottom: size.height * 0.008),
                onTap: (index) => changeIndex(index: index),
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.movie)),
                  BottomNavigationBarItem(icon: Icon(Icons.star)),
                  BottomNavigationBarItem(icon: Icon(Icons.album)),
                  BottomNavigationBarItem(icon: Icon(Icons.tv))
                ],
                selectedLabelStyle: const TextStyle(fontSize: 14),
                unselectedLabelStyle: const TextStyle(fontSize: 10))));
  }
}
