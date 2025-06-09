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
            body:
                IndexedStack(index: currentIndex, children: listScreenTypePage),
            bottomNavigationBar: SnakeNavigationBar.color(
                currentIndex: currentIndex,
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
                onTap: (value) {
                  changeIndex(index: value);
                },
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
