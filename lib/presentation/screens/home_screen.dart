import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/banner/banner_widget.dart';
import '../widgets/title/title_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      return Stack(children: [
        const Positioned.fill(
            child: CustomScrollView(slivers: [
          BannerWidget(),
          ListBannerAnimeAddWidget(),
          SliverTitle(),
          ListAiringAnime()
        ])),
        if (state.initLoad)
          Positioned.fill(
              child: Container(
                  color: Colors.black54,
                  child: const Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.red,
                          strokeWidth: 10,
                          strokeAlign: 3,
                          color: Colors.orange))))
      ]);
    });
  }
}
