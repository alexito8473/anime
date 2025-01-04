import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:anime/presentation/pages/explore_page.dart';
import 'package:anime/presentation/screens/explore_screen.dart';
import 'package:anime/presentation/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import '../screens/movie_screen.dart';
import '../widgets/load/load_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controllerTextEditing = TextEditingController();

  int _currentIndex = 2;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.initState();
  }

  void changeIndex({required int index}) {
    setState(() => _currentIndex = index);
  }

  void navigateToSearch() {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ExplorePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var offsetAnimation = animation.drive(
                Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                    .chain(CurveTween(curve: Curves.linear)));
            return SlideTransition(position: offsetAnimation, child: child);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<AnimeBloc, AnimeState>(
      builder: (context, state) {
        return AnimationLoadPage(
            child: Scaffold(
                floatingActionButton: _currentIndex == 2
                    ? FloatingActionButton(
                        onPressed: () => navigateToSearch(),
                        child: const Icon(Icons.search),
                      )
                    : null,
                extendBody: true,
                body: IndexedStack(index: _currentIndex, children: [
                  ListTypeScreen(pageMovieAnime: state.pageMovieAnime),
                  ListTypeScreen(pageMovieAnime: state.pageSpecialAnime),
                  const HomeScreen(),
                  ListTypeScreen(pageMovieAnime: state.pageOvaAnime),
                  ListTypeScreen(pageMovieAnime: state.pageTVAnime)
                ]),
                bottomNavigationBar: SnakeNavigationBar.color(
                    currentIndex: _currentIndex,
                    backgroundColor: Colors.grey.shade900,
                    snakeShape: SnakeShape.indicator,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.only(
                        left: size.width * 0.05,
                        right: size.width * 0.05,
                        bottom: size.height * 0.008),
                    onTap: (index) => changeIndex(index: index),
                    items: const [
                      BottomNavigationBarItem(icon: Icon(Icons.movie),label: "Película"),
                      BottomNavigationBarItem(icon: Icon(Icons.star)),
                      BottomNavigationBarItem(icon: Icon(Icons.home)),
                      BottomNavigationBarItem(icon: Icon(Icons.album)),
                      BottomNavigationBarItem(icon: Icon(Icons.tv)),
                    ],
                    selectedLabelStyle: const TextStyle(fontSize: 14),
                    unselectedLabelStyle: const TextStyle(fontSize: 10))));
      },
    );
  }
}
