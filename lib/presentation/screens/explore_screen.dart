import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/sliver/sliver_widget.dart';

class ExploreScreen extends StatelessWidget {
  final TextEditingController controller;
  const ExploreScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      return CustomScrollView(slivers: [
        SliverAppBarSearch(controller: controller, onSubmit: () {}),
        SliverGrid(
            delegate: SliverChildBuilderDelegate(
                childCount: state.listAnimeSave.length, (context, index) {
              return Container(
                  color: Colors.red,
                  child: Text(state.listAnimeSave[index].title));
            }),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3))
      ]);
    });
  }
}
