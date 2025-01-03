import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/complete_anime.dart';
import '../animation/hero_animation_widget.dart';
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

  Widget buildContent({required Size size, required BuildContext context}) {
    return SizedBox(
        height: size.height * 0.27,
        child: Column(
            spacing: size.height * 0.005,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleWidget(
                  title: anime.title,
                  maxLines: 3,
                  textStyle: Theme.of(context).textTheme.titleLarge!,
                  tag: tag),
              Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.spaceBetween,
                  alignment: WrapAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  spacing: 10,
                  children: [
                    SubTilesAnime(
                        title: "Debut", subtitle: anime.debut, size: size),
                    SubTilesAnime(
                        title: "Type", subtitle: anime.type, size: size),
                    HeroAnimationWidget(
                        tag: tag,
                        heroTag: anime.rating + anime.title,
                        child: SubTilesAnime(
                            title: "Rating",
                            subtitle: anime.rating,
                            size: size)),
                    SubTilesAnime(
                        title: "Genres",
                        subtitle: anime.genres.join(", ").toUpperCase(),
                        size: size)
                  ]),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    bool isSave = isSaveAnime(context: context);
    return SliverAppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () => onPressed(context: context, isSave: isSave),
              isSelected: isSave,
              style: const ButtonStyle(elevation: WidgetStatePropertyAll(200)),
              selectedIcon:
                  const Icon(CupertinoIcons.heart_fill, color: Colors.orange),
              icon: const Icon(CupertinoIcons.heart, color: Colors.white))
        ],
        collapsedHeight: orientation == Orientation.portrait
            ? size.height * 0.25
            : size.height * 0.4,
        expandedHeight: orientation == Orientation.portrait
            ? size.height * 0.4
            : size.height * 0.5,
        flexibleSpace: Stack(children: [
          Positioned.fill(
              child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black12, Colors.black87, Colors.black],
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
                  width: size.width,
                  padding: EdgeInsets.only(
                      bottom: size.height * 0.02,
                      right: size.width * .05,
                      left: size.width * .05),
                  child: Row(
                      spacing: size.width * .05,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
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
                        if (orientation == Orientation.portrait)
                          Expanded(
                              child:
                                  buildContent(context: context, size: size)),
                        if (orientation == Orientation.landscape)
                          buildContent(context: context, size: size)
                      ])))
        ]));
  }
}

class SynopsysWidget extends StatelessWidget {
  final String title;
  const SynopsysWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            ]));
  }
}
