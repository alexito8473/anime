import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/explore_screen.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePage();
}

class _ExplorePage extends State<ExplorePage> {
  final TextEditingController _controller = TextEditingController();
  void onSubmit() {
    context.read<AnimeBloc>().add(SearchAnime(query: _controller.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimeBloc, AnimeState>(
      builder: (context, state) {
        return ExploreScreen(
            controller: _controller,
            onSubmit: onSubmit,
            listAnime: state.listSearchAnime);
      },
    );
  }
}
