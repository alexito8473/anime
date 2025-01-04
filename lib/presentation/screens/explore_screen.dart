import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/anime.dart';
import '../widgets/banner/banner_widget.dart';
import '../widgets/sliver/sliver_widget.dart';

class ExploreScreen extends StatelessWidget {
  final TextEditingController controller;
  final Function onSubmit;
  final List<Anime> listAnime;
  const ExploreScreen(
      {super.key,
      required this.controller,
      required this.onSubmit,
      required this.listAnime});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: Colors.grey.shade900,
          title: AutoSizeText("Buscador de anime"),
        ),
        SliverPadding(
            padding: EdgeInsets.only(top: size.height * 0.01),
            sliver: SliverAppBarSearch(
                isFlexibleSpaceBar: false,
                controller: controller,
                onSubmit: () => onSubmit())),
        if (listAnime.isEmpty)
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
                    childCount: listAnime.length, (context, index) {
                  return BannerAnime(
                      anime: listAnime[index], tag: 'animeSearch');
                }),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 10,
                    maxCrossAxisExtent: 150,
                    mainAxisExtent: 300)))
      ]),
    );
  }
}
