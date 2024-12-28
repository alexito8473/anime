import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/anime.dart';
import '../title/title_widget.dart';

class AppBarDetailAnime extends StatelessWidget {
  final Anime anime;
  const AppBarDetailAnime({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SliverAppBar(
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
                        Colors.black,
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
              child: SafeArea(
                  right: false,
                  left: false,
                  bottom: false,
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
                            Hero(
                                tag: anime.poster,
                                child: ClipRRect(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TitleWidget(
                                              title: anime.title,
                                              maxLines: 3,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!,
                                              tag: anime.title),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SubTilesAnime(
                                                  title: "Debut",
                                                  subtitle: anime.debut,
                                                  size: size,
                                                ),
                                                SubTilesAnime(
                                                  title: "Type",
                                                  subtitle: anime.type,
                                                  size: size,
                                                ),
                                                Hero(
                                                    tag: anime.rating +
                                                        anime.title,
                                                    child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: SubTilesAnime(
                                                          title: "Rating",
                                                          subtitle:
                                                              anime.rating,
                                                          size: size,
                                                        ))),
                                              ]),
                                          SubTilesAnime(
                                            title: "Genres",
                                            subtitle: anime.genres
                                                .join(", ")
                                                .toUpperCase(),
                                            size: size,
                                          )
                                        ])))
                          ]))))
        ]));
  }
}
