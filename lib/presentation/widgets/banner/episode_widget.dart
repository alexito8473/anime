import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
  final Orientation orientation;
  final Size size;
  final Function onTapSaveEpisode;
  const BannerEpisode(
      {super.key,
      required this.episode,
      required this.anime,
      required this.orientation,
      required this.size,
      required this.onTapSaveEpisode});

  @override
  Widget build(BuildContext context) {
    bool isSave =
        context.watch<AnimeBloc>().state.listEpisodesView.contains(episode.id);
    return GestureDetector(
        onTap: () {
          context.read<AnimeBloc>().add(ObtainVideoSever(
              anime: anime,
              episode: episode,
              context: context,
              isNavigationReplacement: false));
        },
        child: Card(
            margin: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.01),
            color: Colors.grey.shade900.withAlpha(100),
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.01),
                child: Row(spacing: size.width * 0.05, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                        constraints:
                            const BoxConstraints(minWidth: 100, maxHeight: 100),
                        width: size.width * 0.1,
                        height: size.height * 0.2,
                        child: CachedNetworkImage(
                            imageUrl: episode.imagePreview,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.none,
                            progressIndicatorBuilder:
                                (context, url, progress) => Container(
                                    width: size.width * 0.1,
                                    height: size.width * 0.1,
                                    color: Colors.grey.withAlpha(10),
                                    child: Center(
                                        child: CircularProgressIndicator(
                                            value: progress.progress,
                                            color: Colors.orange))),
                            errorWidget: (context, url, error) =>
                                CachedNetworkImage(
                                    imageUrl: anime.poster,
                                    fit: BoxFit.cover,
                                    colorBlendMode: BlendMode.darken,
                                    color: Colors.black12,
                                    filterQuality: FilterQuality.none,
                                    progressIndicatorBuilder:
                                        (context, url, progress) => Container(
                                            width: size.width * 0.1,
                                            height: size.width * 0.1,
                                            color: Colors.grey.withAlpha(10),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        value:
                                                            progress.progress,
                                                        color: Colors.orange))),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          color: Colors.red,
                                        )))),
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
                        ),
                      ])),
                  IconButton(
                      onPressed: () => onTapSaveEpisode(isSave, episode),
                      style: ButtonStyle(foregroundColor:
                          MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors
                              .white; // Color blanco cuando está seleccionado
                        }
                        return Colors.white.withOpacity(
                            0.5); // Blanco transparente cuando no está seleccionado
                      })),
                      isSelected: isSave,
                      icon: const Icon(CupertinoIcons.eye_slash_fill),
                      selectedIcon: const Icon(CupertinoIcons.eye_solid))
                ]))));
  }
}

class ListEpisodes extends StatelessWidget {
  final CompleteAnime anime;
  final List<Episode> episodes;
  final TextEditingController textController;
  final Function onTapSaveEpisode;
  final Widget? action;
  const ListEpisodes(
      {super.key,
      required this.anime,
      required this.episodes,
      required this.textController,
      required this.onTapSaveEpisode, this.action});

  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    return CustomScrollView(
      slivers: [
        SliverAppBarSearch(
          controller: textController,
          action: action
        ),
        SliverPadding(
            padding: const EdgeInsets.only(top: 20),
            sliver: SliverList.builder(
                itemCount: episodes.length,
                itemBuilder: (context, index) {
                  return BannerEpisode(
                    anime: anime,
                    episode: episodes[index],
                    orientation: data.orientation,
                    size: data.size,
                    onTapSaveEpisode: onTapSaveEpisode,
                  );
                }))
      ],
    );
  }
}
