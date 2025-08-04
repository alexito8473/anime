import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

import '../../../data/enums/type_version_anime.dart';
import '../../../domain/bloc/anime/anime_bloc.dart';

class TypesAnimePage extends StatelessWidget {
  final int currentIndex;
  final void Function({required int index}) changeIndex;
  final List<Widget> listScreenTypePage;
  final List<bool> canUpdate;
  final List<ScrollController> scrollControllers;
  final void Function({required TypeVersionAnime key}) loadMore;

  const TypesAnimePage(
      {super.key,
      required this.currentIndex,
      required this.changeIndex,
      required this.listScreenTypePage,
      required this.canUpdate,
      required this.scrollControllers,
      required this.loadMore});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocListener<AnimeBloc, AnimeState>(
        listener: (context, state) {
          for (var key in state.mapPageAnimes.keys) {
            if (state.mapPageAnimes[key]?.isObtainAllData == true &&
                canUpdate[key.index]) {
              scrollControllers[key.index]
                  .removeListener(() => loadMore(key: key));
            }
          }
        },
        child: Scaffold(
            extendBody: true,
            body:
                IndexedStack(index: currentIndex, children: listScreenTypePage),
            bottomNavigationBar: SnakeNavigationBar.color(
                currentIndex: currentIndex,
                backgroundColor: Colors.grey.shade900,
                snakeShape: SnakeShape.rectangle,
                shape: RoundedRectangleBorder(
                    side:
                        BorderSide(color: Colors.white.withAlpha(20), width: 1),
                    borderRadius: BorderRadius.circular(40)),
                onTap: (value) => changeIndex(index: value),
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                    vertical: size.height * 0.003),
                items: const [
                  BottomNavigationBarItem(
                      activeIcon: Icon(Icons.movie, color: Colors.white),
                      icon: Icon(Icons.movie)),
                  BottomNavigationBarItem(
                      activeIcon: Icon(Icons.star, color: Colors.white),
                      icon: Icon(Icons.star)),
                  BottomNavigationBarItem(
                      activeIcon: Icon(Icons.album, color: Colors.white),
                      icon: Icon(Icons.album)),
                  BottomNavigationBarItem(
                      activeIcon: Icon(Icons.tv, color: Colors.white),
                      icon: Icon(Icons.tv))
                ],
                selectedLabelStyle: const TextStyle(fontSize: 14),
                unselectedLabelStyle: const TextStyle(fontSize: 10))));
  }
}
