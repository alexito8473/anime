import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      return AnimationLoadPage(
          child: ExploreScreen(
              controller: _controller,
              onSubmit: onSubmit,
              listAnime: state.listSearchAnime));
    });
  }
}
