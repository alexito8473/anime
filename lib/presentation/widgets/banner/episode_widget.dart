import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/data/model/episode.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/anime/anime_bloc.dart';
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
    final bool isSave =
        context.watch<AnimeBloc>().state.listEpisodesView.contains(episode.id);
    return GestureDetector(
        onTap: () {
          context.read<AnimeBloc>().add(ObtainVideoSever(
              anime: anime,
              episode: episode,
              context: context,
              isNavigationReplacement: false));
        },
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.04, vertical: size.height * 0.008),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color(0xFF1E293B).withAlpha(230),
                const Color(0xFF1E293B).withAlpha(180),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF334155).withAlpha(120),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(40),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.height * 0.01),
              child: Row(spacing: size.width * 0.03, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                      constraints:
                          const BoxConstraints(minWidth: 80, maxHeight: 80),
                      width: size.width * 0.12,
                      height: size.height * 0.12,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C4DFF).withAlpha(40),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                              imageUrl: episode.imagePreview,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.medium,
                              progressIndicatorBuilder:
                                  (context, url, progress) => Container(
                                      color: const Color(0xFF1E293B),
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              value: progress.progress,
                                              color: const Color(0xFF7C4DFF)))),
                              errorWidget: (context, url, error) =>
                                  CachedNetworkImage(
                                      imageUrl: anime.poster,
                                      fit: BoxFit.cover,
                                      colorBlendMode: BlendMode.darken,
                                      color: Colors.black26,
                                      filterQuality: FilterQuality.medium,
                                      progressIndicatorBuilder:
                                          (context, url, progress) => Container(
                                              color: const Color(0xFF1E293B),
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          value:
                                                              progress.progress,
                                                          color: const Color(
                                                              0xFF7C4DFF)))),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                            color: const Color(0xFF1E293B),
                                            child: const Center(
                                                child: Icon(
                                                    Icons.broken_image_rounded,
                                                    color: Color(0xFF64748B))),
                                          ))),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(180),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Ep. ${episode.episode}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                Expanded(
                    child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      TitleWidget(
                          title: anime.title,
                          maxLines: 2,
                          tag: episode.id,
                          textStyle: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w600)),
                      if (episode.part != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C4DFF).withAlpha(50),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: AutoSizeText(
                            'Parte: ${episode.part}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB388FF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ])),
                _buildSaveButton(context, isSave),
              ])),
        ));
  }

  Widget _buildSaveButton(BuildContext context, bool isSave) {
    return Container(
      decoration: BoxDecoration(
        color: isSave
            ? const Color(0xFF7C4DFF).withAlpha(60)
            : Colors.white.withAlpha(20),
        shape: BoxShape.circle,
        border: Border.all(
          color: isSave
              ? const Color(0xFF7C4DFF).withAlpha(100)
              : Colors.white.withAlpha(30),
          width: 1,
        ),
      ),
      child: IconButton(
          onPressed: () => onTapSaveEpisode(isSave, episode),
          isSelected: isSave,
          icon: Icon(
            CupertinoIcons.eye_slash_fill,
            color: Colors.white.withAlpha(130),
            size: 18,
          ),
          selectedIcon: const Icon(
            CupertinoIcons.eye_solid,
            color: Color(0xFFB388FF),
            size: 18,
          )),
    );
  }
}

class ListEpisodesWidget extends StatelessWidget {
  final CompleteAnime anime;
  final List<Episode> episodes;
  final TextEditingController textController;
  final Function onTapSaveEpisode;
  final Widget? action;

  const ListEpisodesWidget(
      {super.key,
      required this.anime,
      required this.episodes,
      required this.textController,
      required this.onTapSaveEpisode,
      this.action});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final Orientation orientation = MediaQuery.orientationOf(context);
    return CustomScrollView(
      slivers: [
        SliverAppBarSearch(controller: textController),
        SliverAppBar(
            automaticallyImplyLeading: false,
            forceMaterialTransparency: true,
            pinned: true,
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: size.width * 0.05, top: 10),
                  child: action!)
            ]),
        SliverPadding(
            padding: const EdgeInsets.only(top: 12),
            sliver: SliverList.builder(
                itemCount: episodes.length,
                itemBuilder: (context, index) {
                  return BannerEpisode(
                      anime: anime,
                      episode: episodes[index],
                      orientation: orientation,
                      size: size,
                      onTapSaveEpisode: onTapSaveEpisode);
                }))
      ],
    );
  }
}
