import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:anime/presentation/widgets/sliver/sliver_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/list_type_anime_page.dart';
import '../widgets/banner/banner_widget.dart';

class ListTypeScreen extends StatelessWidget {
  final ListTypeAnimePage pageMovieAnime;

  const ListTypeScreen(
      {super.key, required this.pageMovieAnime});

  final String tag="typeScreen";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          final metrics = notification.metrics;
          if (metrics.pixels >= metrics.maxScrollExtent) {
            print("ahora ahora");
            //  _loadMoreAnimes();
          }
          return false;
        },
        child: CustomScrollView(slivers: [
          SliverAppBarSearch(controller: TextEditingController()),
          SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              sliver: SliverGrid.builder(
                  addRepaintBoundaries: true,
                  itemCount: pageMovieAnime.listAnime.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisExtent: 300,
                      crossAxisSpacing: 10,
                      maxCrossAxisExtent: 150),
                  itemBuilder: (context, index) {
                    return BannerAnime(
                        anime: pageMovieAnime.listAnime[index], tag: tag);
                  }))
        ]));
  }
}
