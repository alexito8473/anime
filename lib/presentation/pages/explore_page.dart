import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/explore_screen.dart';
import '../widgets/load/load_widget.dart';
import 'detail_anime_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePage();
}

class _ExplorePage extends State<ExplorePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSubmit() =>
      context.read<AnimeBloc>().add(SearchAnime(query: _controller.text));

  void navigation({required String id, String? tag, required String title}) {
    context.read<AnimeBloc>().add(ObtainDataAnime(
        context: context,
        id: id,
        navigationPage: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  allowSnapshotting: true,
                  barrierColor: Colors.black38,
                  opaque: true,
                  barrierDismissible: true,
                  reverseTransitionDuration: const Duration(milliseconds: 600),
                  transitionDuration: const Duration(milliseconds: 600),
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      DetailAnimePage(idAnime: id, tag: tag),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                        opacity: CurvedAnimation(
                            parent: animation,
                            curve: Curves.decelerate,
                            reverseCurve: Curves.decelerate),
                        child: child);
                  }));
        },
        tag: tag,
        title: title));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      return AnimationLoadPage(
          child: ExploreScreen(
              controller: _controller,
              onSubmit: onSubmit,
              listAnime: state.listSearchAnime,
              onTapElement: navigation));
    });
  }
}
