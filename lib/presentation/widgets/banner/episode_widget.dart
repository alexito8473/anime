import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anime/data/model/episode.dart';
import 'package:anime/data/model/complete_anime.dart';
import '../../../domain/bloc/anime_bloc.dart';
import '../sliver/sliver_widget.dart';
import '../title/title_widget.dart';

class BannerEpisode extends StatelessWidget {
  final Episode episode;
  final CompleteAnime anime;
  const BannerEpisode({super.key, required this.episode, required this.anime});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    return GestureDetector(
        onTap: () {
          context.read<AnimeBloc>().add(ObtainVideoSever(
              anime: anime,
              episode: episode,
              context: context,
              isNavigationReplacement: false));
        },
        child: Card(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: size.height * 0.01),
                child: Row(spacing: size.width * 0.05, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                        width: size.width * 0.2,
                        height: orientation == Orientation.portrait
                            ? size.height * 0.1
                            : size.height * 0.3,
                        child: CachedNetworkImage(
                            imageUrl: episode.imagePreview,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                CachedNetworkImage(
                                    imageUrl: anime.poster,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const CircularProgressIndicator()))),
                  ),
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
  final CompleteAnime anime;
  final List<Episode> episodes;
  final TextEditingController textController;
  const ListEpisodes(
      {super.key,
      required this.anime,
      required this.episodes,
      required this.textController});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBarSearch(controller: textController),
        SliverPadding(
            padding: const EdgeInsets.only(top: 20),
            sliver: SliverList.builder(
                itemCount: episodes.length,
                itemBuilder: (context, index) {
                  return BannerEpisode(anime: anime, episode: episodes[index]);
                }))
      ],
    );
  }
}
