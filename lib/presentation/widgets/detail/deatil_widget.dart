import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/model/complete_anime.dart';
import '../animation/hero_animation_widget.dart';
import '../title/title_widget.dart';

class AppBarDetailAnime extends StatelessWidget {
  final CompleteAnime anime;
  final String? tag;
  final Widget safeAnime;

  const AppBarDetailAnime(
      {super.key,
      required this.anime,
      required this.tag,
      required this.safeAnime});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    Orientation orientation = MediaQuery.orientationOf(context);
    return SliverAppBar.large(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.back, color: Colors.white)),
        actions: [safeAnime],
        collapsedHeight: size.height*0.1,
        expandedHeight: size.height * 0.45,
        title: Text(anime.title,style: Theme.of(context).textTheme.titleLarge),
        flexibleSpace:FlexibleSpaceBar(
          background: Stack(children: [
            Positioned.fill(
                child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return RadialGradient(
                              center: Alignment.topRight,
                              radius: 1.05,
                              colors: [
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black38,
                                Colors.black54,
                                Colors.black
                              ]).createShader(bounds);
                        },
                        blendMode: BlendMode.darken,
                        child: CachedNetworkImage(
                            alignment: Alignment.topCenter,
                            color: Colors.black12,
                            colorBlendMode: BlendMode.darken,
                            imageUrl: anime.isNotBannerCorrect
                                ? anime.poster
                                : anime.banner,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.cover))),
            Positioned.fill(
                child: Container(
                    height: size.height * 0.4,
                    width: size.width,
                    padding: EdgeInsets.only(
                        top: size.height * 0.1,
                        bottom: size.height * 0.02,
                        right: size.width * .05,
                        left: size.width * .05),
                    child: Row(
                        spacing: size.width * .04,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        verticalDirection: VerticalDirection.down,
                        children: [
                          HeroAnimationWidget(
                              tag: tag,
                              heroTag: anime.poster,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: anime.poster,
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.contain,
                                    height: orientation == Orientation.portrait
                                        ? size.height * 0.27
                                        : size.height * 0.5,
                                  ))),
                          Expanded(
                              child:
                              TitleWidget(
                                  title: anime.title,
                                  maxLines: 8,
                                  textStyle:
                                  Theme.of(context).textTheme.titleLarge!,
                                  tag: tag)
                          )
                        ])))
          ]),
        ) );
  }
}

class SynopsysWidget extends StatelessWidget {
  final String title;

  const SynopsysWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              AutoSizeText(title, style: Theme.of(context).textTheme.labelLarge)
            ]));
  }
}
