import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/anime.dart';
import '../../../data/episode.dart';
import '../../../domain/bloc/anime_bloc.dart';
import '../title/title_widget.dart';

class BannerEpisode extends StatelessWidget {
  final Episode episode;
  final Anime anime;
  const BannerEpisode({super.key, required this.episode, required this.anime});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
        onTap: () {
          context.read<AnimeBloc>().add(ObtainVideoSever(
              anime: anime, episode: episode, context: context));
        },
        child: Card(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: size.height * 0.01),
                child: Row(spacing: size.width * 0.05, children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      width: size.width * 0.2,
                      height: size.width * 0.3,
                      child: CachedNetworkImage(
                          imageUrl: episode.imagePreview,
                          fit: BoxFit.contain,
                          errorWidget: (context, url, error) =>
                              CachedNetworkImage(
                                  imageUrl: anime.poster,
                                  fit: BoxFit.contain,
                                  errorWidget: (context, url, error) =>
                                      const CircularProgressIndicator()))),
                  Expanded(
                      child: Column(
                          spacing: size.height * 0.01,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        TitleWidget(
                            title: anime.title,
                            maxLines: 2,
                            tag: episode.id,
                            textStyle:
                                Theme.of(context).textTheme.titleMedium!),
                        Row(
                          children: [
                            AutoSizeText("Episode : ${episode.episode}"),
                            if (episode.part != null)
                              AutoSizeText(" Part : ${episode.part}")
                          ],
                        )
                      ]))
                ]))));
  }
}

class ListEpisodes extends StatelessWidget {
  final Anime anime;
  final List<Episode> episodes;
  const ListEpisodes({super.key, required this.anime, required this.episodes});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
        padding: const EdgeInsets.only(top: 20),
        sliver: SliverList.builder(
            itemCount: episodes.length,
            itemBuilder: (context, index) {
              return BannerEpisode(
                  anime: anime, episode: episodes[index]);
            }));
  }
}
