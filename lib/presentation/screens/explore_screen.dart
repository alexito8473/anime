import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/banner/banner_widget.dart';
import '../widgets/sliver/sliver_widget.dart';

class ExploreScreen extends StatelessWidget {
  final TextEditingController controller;

  const ExploreScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      return CustomScrollView(slivers: [
        SliverAppBarSearch(
            controller: controller,
            onSubmit: () {
              context
                  .read<AnimeBloc>()
                  .add(SearchAnime(query: controller.text));
            }),
        if (state.listSearchAnime.isEmpty)
          SliverToBoxAdapter(
              child: SizedBox(
                  height: size.height * 0.8,
                  child: const Center(
                      child: Text('No se encontraron resultados')))),
        SliverPadding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.02),
            sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                    childCount: state.listSearchAnime.length, (context, index) {
                  return BannerAnime(
                      anime: state.listSearchAnime[index], tag: 'animeSearch');
                }),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 10,
                    maxCrossAxisExtent: 150,
                    mainAxisExtent: 300)))
      ]);
    });
  }
}
