import 'package:anime/data/enums/type_my_animes.dart';
import 'package:anime/data/enums/types_vision.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/model/complete_anime.dart';
import '../animation/hero_animation_widget.dart';
import '../title/title_widget.dart';

class HeaderDetailAnimePortraitWidget {
  static List<Widget> build({
    required CompleteAnime anime,
    required bool isSave,
    required TypeMyAnimes miAnime,
    required Future<void> Function({required CompleteAnime anime}) openDialog,
    required void Function({required TypesVision? type}) changeTypeVision,
    required void Function() shareAnime,
    String? tag,
  }) {
    return [
      /// ✅ ESTO ES UN SLIVER → NO VA EN SliverToBoxAdapter
      _AppBarDetailAnime(
        anime: anime,
        tag: tag,
        safeAnime: Builder(
          builder: (context) {
            final ThemeData theme = Theme.of(context);

            return Row(
              children: [
                if (isSave)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      miAnime.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: () => openDialog(anime: anime),
                  isSelected: isSave,
                  style: const ButtonStyle(
                    elevation: WidgetStatePropertyAll(200),
                  ),
                  selectedIcon:
                      const Icon(Icons.autorenew, color: Colors.orange),
                  icon: const Icon(
                    CupertinoIcons.heart,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: shareAnime,
                  icon: const Icon(Icons.share),
                ),
              ],
            );
          },
        ),
      ),

      /// ✅ ESTO SÍ VA EN SliverToBoxAdapter
      SliverToBoxAdapter(
        child: Builder(
          builder: (context) {
            final Size size = MediaQuery.sizeOf(context);
            final double padding08 = size.width * 0.08;

            return Material(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.symmetric(horizontal: padding08),
                padding: EdgeInsets.symmetric(horizontal: padding08),
                child: Wrap(
                  spacing: 10,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    SubTilesAnime(
                      title: 'Estado',
                      subtitle: anime.debut,
                      size: size,
                    ),
                    SubTilesAnime(
                      title: 'Tipo',
                      subtitle: anime.type,
                      size: size,
                    ),
                    HeroAnimationWidget(
                      tag: tag,
                      heroTag: anime.rating + anime.title,
                      child: SubTilesAnime(
                        title: 'Valoración',
                        subtitle: anime.rating,
                        size: size,
                      ),
                    ),
                    if (anime.genres.isNotEmpty)
                      SubTilesAnime(
                        title: 'Géneros',
                        subtitle: anime.genres.join(', ').toUpperCase(),
                        size: size,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ];
  }
}

class HeaderDetailAnimeLandscapeWidget {
  static List<Widget> build({
    required CompleteAnime anime,
    required bool isSave,
    required TypeMyAnimes miAnime,
    required Future<void> Function({required CompleteAnime anime}) openDialog,
    required void Function({required TypesVision? type}) changeTypeVision,
    required void Function() shareAnime,
    String? tag,
  }) {
    return [
      _AppBarDetailAnimeLandscapeWidget(
        anime: anime,
        tag: tag,
        safeAnime: Builder(
          builder: (context) {
            final ThemeData theme = Theme.of(context);
            return Row(
              children: [
                if (isSave)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      miAnime.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: () => openDialog(anime: anime),
                  isSelected: isSave,
                  style: const ButtonStyle(
                    elevation: WidgetStatePropertyAll(200),
                  ),
                  selectedIcon:
                      const Icon(Icons.autorenew, color: Colors.orange),
                  icon: const Icon(
                    CupertinoIcons.heart,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: shareAnime,
                  icon: const Icon(Icons.share),
                ),
              ],
            );
          },
        ),
      ),
    ];
  }
}

class _AppBarDetailAnime extends StatelessWidget {
  final CompleteAnime anime;
  final String? tag;
  final Widget safeAnime;

  const _AppBarDetailAnime({
    required this.anime,
    required this.tag,
    required this.safeAnime,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final imageUrl = anime.isNotBannerCorrect ? anime.poster : anime.banner;
    final EdgeInsets paddingTop = MediaQuery.paddingOf(context);
    return SliverAppBar.large(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(CupertinoIcons.back, color: Colors.white)),
        actions: [safeAnime],
        collapsedHeight: paddingTop.top + (size.height * .05),
        toolbarHeight: paddingTop.top + (size.height * .05),
        expandedHeight: paddingTop.top + (size.height * .4),
        title: Text(anime.title, style: Theme.of(context).textTheme.titleLarge),
        flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: Stack(children: [
              Positioned.fill(
                  child: ShaderMask(
                      shaderCallback: (Rect bounds) => const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black54,
                              Colors.black87,
                              Colors.black,
                            ],
                          ).createShader(bounds),
                      blendMode: BlendMode.darken,
                      child: CachedNetworkImage(
                          alignment: Alignment.topCenter,
                          imageUrl: imageUrl,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover))),
              SafeArea(
                  child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                          horizontal: size.width * 0.02,
                          vertical: size.height * 0.07),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 8, // Takes 40% of the available width
                            child: HeroAnimationWidget(
                              tag: tag,
                              heroTag: anime.poster,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: anime.poster,
                                  fit: BoxFit.cover,
                                  // Changed to cover to ensure it fills the box
                                  height: size.height * 0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 6, // Takes 60% of the available width
                            child: TitleWidget(
                              title: anime.title,
                              maxLines: 8,
                              textStyle:
                                  Theme.of(context).textTheme.titleLarge!,
                              tag: tag,
                            ),
                          ),
                        ],
                      )))
            ])));
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
              const Text('Synopsis',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
              AutoSizeText(title, style: const TextStyle(fontSize: 16))
            ]));
  }
}

class _AppBarDetailAnimeLandscapeWidget extends StatelessWidget {
  final CompleteAnime anime;
  final String? tag;
  final Widget safeAnime;

  const _AppBarDetailAnimeLandscapeWidget({
    required this.anime,
    required this.tag,
    required this.safeAnime,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);

    return SliverAppBar.large(
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(CupertinoIcons.back, color: Colors.white),
      ),
      actions: [safeAnime],
      collapsedHeight: padding.top + (size.height * 0.18),
      toolbarHeight: padding.top + (size.height * 0.18),
      expandedHeight: size.height * 0.7,
      title: Text(
        anime.title,
        style: Theme.of(context).textTheme.titleLarge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;

            return SizedBox(
              width: width,
              height: height,
              child: Row(
                spacing: 10,
                children: [
                  SizedBox(
                    width: width * 0.35,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.2,
                        left: width * 0.05,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: HeroAnimationWidget(
                          tag: tag,
                          heroTag: anime.poster,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: CachedNetworkImage(
                              imageUrl: anime.poster,
                              width: width * 0.3,
                              height: height * 0.9,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.2,
                        right: padding.right,
                      ),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleWidget(
                            title: anime.title,
                            maxLines: 1,
                            textStyle: Theme.of(context).textTheme.titleLarge!,
                            tag: tag,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Wrap(
                              spacing: 10,
                              children: [
                                SubTilesAnime(
                                  minHeight: 70,
                                  title: 'Estado',
                                  subtitle: anime.debut,
                                  size: Size(width, height),
                                ),
                                SubTilesAnime(
                                  minHeight: 70,
                                  title: 'Estado',
                                  subtitle: anime.debut,
                                  size: Size(width, height),
                                ),
                                SubTilesAnime(
                                  minHeight: 70,
                                  title: 'Tipo',
                                  subtitle: anime.type,
                                  size: Size(width, height),
                                ),
                                SubTilesAnime(
                                  minHeight: 70,
                                  title: 'Valoración',
                                  subtitle: anime.rating,
                                  size: Size(width, height),
                                ),
                                if (anime.genres.isNotEmpty)
                                  SubTilesAnime(
                                    minHeight: 70,
                                    title: 'Géneros',
                                    subtitle:
                                        anime.genres.join(', ').toUpperCase(),
                                    size: Size(width, height),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
