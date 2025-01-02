import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/complete_anime.dart';
import '../title/title_widget.dart';

class AppBarDetailAnime extends StatelessWidget {
  final CompleteAnime anime;
  final String? tag;
  const AppBarDetailAnime({super.key, required this.anime, required this.tag});

  bool isSaveAnime({required BuildContext context}) => context
      .watch<AnimeBloc>()
      .state
      .listAnimeSave
      .any((element) => element.title == anime.title);

  void onPressed({required BuildContext context, required bool isSave}) =>
      context.read<AnimeBloc>().add(SaveAnime(anime: anime, isSave: isSave));

  Widget buildHeroImage({required Widget image}) {
    if (tag == null) {
      return image;
    }
    return Hero(tag: tag.toString() + anime.poster, child: image);
  }

  Widget buildHeroSubTitle({required Widget subTitle}) {
    if (tag == null) {
      return subTitle;
    }
    return Hero(
        tag: tag.toString() + anime.rating + anime.title,
        child: Material(color: Colors.transparent, child: subTitle));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    bool isSave = isSaveAnime(context: context);
    return SliverAppBar(
        actions: [
          IconButton(
              onPressed: () => onPressed(context: context, isSave: isSave),
              isSelected: isSave,
              style: const ButtonStyle(elevation: WidgetStatePropertyAll(200)),
              selectedIcon: const Icon(CupertinoIcons.heart_fill),
              icon: const Icon(CupertinoIcons.heart))
        ],
        collapsedHeight: size.height * 0.25,
        expandedHeight: size.height * 0.4,
        flexibleSpace: Stack(children: [
          Positioned.fill(
              child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black87,
                        Colors.black
                      ],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.darken,
                  child: CachedNetworkImage(
                      imageUrl: anime.isNotBannerCorrect
                          ? anime.poster
                          : anime.banner,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover))),
          Positioned.fill(
              child: Container(
                  height: size.height * 0.4,
                  padding: EdgeInsets.only(
                      bottom: size.height * 0.02,
                      right: size.width * .05,
                      left: size.width * .05),
                  child: Row(
                      spacing: size.width * .05,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        buildHeroImage(
                            image: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                    imageUrl: anime.poster,
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.contain,
                                    height: size.height * 0.27))),
                        Expanded(
                            child: SizedBox(
                                height: size.height * 0.27,
                                child: Column(
                                    spacing: size.height * 0.005,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TitleWidget(
                                          title: anime.title,
                                          maxLines: 3,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .titleLarge!,
                                          tag: tag),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SubTilesAnime(
                                                title: "Debut",
                                                subtitle: anime.debut,
                                                size: size),
                                            SubTilesAnime(
                                                title: "Type",
                                                subtitle: anime.type,
                                                size: size),
                                            buildHeroSubTitle(
                                                subTitle: SubTilesAnime(
                                                    title: "Rating",
                                                    subtitle: anime.rating,
                                                    size: size)),
                                          ]),
                                      SubTilesAnime(
                                          title: "Genres",
                                          subtitle: anime.genres
                                              .join(", ")
                                              .toUpperCase(),
                                          size: size)
                                    ])))
                      ])))
        ]));
  }
}

class SynopsysWidget extends StatelessWidget {
  final String title;
  const SynopsysWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Synopsis",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.blue)),
                  Text(title)
                ])));
  }
}
