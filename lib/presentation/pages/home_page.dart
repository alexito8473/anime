import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:anime/presentation/pages/explore_page.dart';

import 'package:anime/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import '../../data/model/list_type_anime_page.dart';
import '../../data/typeAnime/type_version_anime.dart';
import '../screens/type_anime_screen.dart';
import '../widgets/load/load_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2;
  final ScrollController _scrollControllerMovie = ScrollController();
  final ScrollController _scrollControllerOva = ScrollController();
  final ScrollController _scrollControllerSpecial = ScrollController();
  final ScrollController _scrollControllerTV = ScrollController();
  final List<GlobalKey> _targetKeyList = [
    GlobalKey(),
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
    HomeScreen(targetKey: _targetKeyList[2]),
    ListTypeScreen(
        scrollController: _scrollControllerOva,
        type: TypeVersionAnime.OVA,
        targetKey: _targetKeyList[3]),
    ListTypeScreen(
        scrollController: _scrollControllerTV,
        type: TypeVersionAnime.TV,
        targetKey: _targetKeyList[4])
  ];
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    _scrollControllerMovie.addListener(() => loadMore(_scrollControllerMovie,
        context.read<AnimeBloc>().state.pageMovieAnime));
    _scrollControllerOva.addListener(() => loadMore(
        _scrollControllerOva, context.read<AnimeBloc>().state.pageOvaAnime));
    _scrollControllerSpecial.addListener(() => loadMore(
        _scrollControllerSpecial,
        context.read<AnimeBloc>().state.pageSpecialAnime));
    _scrollControllerTV.addListener(() => loadMore(
        _scrollControllerTV, context.read<AnimeBloc>().state.pageTVAnime));
    super.initState();
  }

  @override
  void dispose() {
    _scrollControllerMovie.dispose();
    _scrollControllerOva.dispose();
    _scrollControllerSpecial.dispose();
    _scrollControllerTV.dispose();
    super.dispose();
  }

  void changeIndex({required int index}) {
    if (_currentIndex == index) {
      moveScroll(_targetKeyList[index]);
    } else {
      setState(() => _currentIndex = index);
    }
  }

  void moveScroll(GlobalKey globalKey) {
    Scrollable.ensureVisible(globalKey.currentContext!,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  void navigateToSearch() {
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ExplorePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var offsetAnimation = animation.drive(
                  Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.linear)));
              return SlideTransition(position: offsetAnimation, child: child);
            }));
  }

  void loadMore(
      ScrollController scrollController, ListTypeAnimePage page) async {
    if (page.isObtainAllData) {
      return;
    }
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      final double currentScrollPosition = scrollController.position.pixels;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(currentScrollPosition);
      });
      context
          .read<AnimeBloc>()
          .add(UpdatePage(typeVersionAnime: page.typeVersionAnime));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocListener<AnimeBloc, AnimeState>(
        listener: (context, state) {
          if (state.pageTVAnime.isObtainAllData) {
            _scrollControllerTV.removeListener(
                () => loadMore(_scrollControllerTV, state.pageTVAnime));
          }
          if (state.pageSpecialAnime.isObtainAllData) {
            _scrollControllerSpecial.removeListener(() =>
                loadMore(_scrollControllerSpecial, state.pageSpecialAnime));
          }
          if (state.pageOvaAnime.isObtainAllData) {
            _scrollControllerOva.removeListener(
                () => loadMore(_scrollControllerOva, state.pageOvaAnime));
          }
          if (state.pageMovieAnime.isObtainAllData) {
            _scrollControllerMovie.removeListener(
                () => loadMore(_scrollControllerMovie, state.pageMovieAnime));
          }
        },
        child: AnimationLoadPage(
            child: Scaffold(
                floatingActionButton: _currentIndex == 2
                    ? FloatingActionButton(
                        onPressed: () => navigateToSearch(),
                        child: const Icon(Icons.search))
                    : null,
                extendBody: true,
                body: IndexedStack(
                    index: _currentIndex, children: listScreenPage),
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
                      BottomNavigationBarItem(icon: Icon(Icons.home)),
                      BottomNavigationBarItem(icon: Icon(Icons.album)),
                      BottomNavigationBarItem(icon: Icon(Icons.tv)),
                    ],
                    selectedLabelStyle: const TextStyle(fontSize: 14),
                    unselectedLabelStyle: const TextStyle(fontSize: 10)))));
  }
}
