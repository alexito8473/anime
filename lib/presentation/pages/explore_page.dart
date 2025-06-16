import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/anime.dart';
import '../screens/explore_screen.dart';
import '../widgets/load/load_widget.dart';
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
        tag: tag,
        title: title));
  }

  @override
  Widget build(BuildContext context) {
    return
      BlocSelector<AnimeBloc, AnimeState, List<Anime>>(
        selector: (state) => state.listSearchAnime, builder: (context, state) {
        return AnimationLoadPage(
            child: ExploreScreen(
                controller: _controller,
                onSubmit: onSubmit,
                listAnime: state,
                onTapElement: navigation));
      },);
  }
}
