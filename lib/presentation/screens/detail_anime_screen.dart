import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/data/model/episode.dart';
import 'package:anime/presentation/widgets/banner/banner_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/animation/hero_animation_widget.dart';
import '../widgets/banner/episode_widget.dart';
import '../widgets/detail/deatil_widget.dart';
import '../widgets/title/title_widget.dart';

class DetailAnimeScreen extends StatelessWidget {
  final CompleteAnime anime;
  final Size size;
  final Function onTap;
  final int currentPage;
  final List<Episode> listAnimeFilter;
  final TextEditingController textController;
  final String? tag;
  final Function onTapSaveEpisode;
  final Widget action;
  final Widget safeAnime;
  final void Function(String id, String? tag) onTapElement;

  const DetailAnimeScreen(
      {super.key,
      required this.anime,
      required this.size,
      required this.onTap,
      required this.currentPage,
      required this.listAnimeFilter,
      required this.textController,
      required this.tag,
      required this.onTapSaveEpisode,
      required this.action,
      required this.safeAnime,
      required this.onTapElement});

  int countTabBar() {
    int count = 1;
    if (anime.synopsis.isNotEmpty) {
      count++;
    }
    if (anime.listAnimeRelated.isNotEmpty) {
      count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final ThemeData theme = Theme.of(context);
    final bool isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final double padding08 = size.width * 0.08;
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
              AppBarDetailAnime(anime: anime, tag: tag, safeAnime: safeAnime),
              SliverToBoxAdapter(
                      child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(20)),
                              margin:EdgeInsets.only(
                                  right: padding08, left: padding08),
                              padding: EdgeInsets.only(
                                  right: padding08, left: padding08),
                              child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  runAlignment: WrapAlignment.center,
                                  alignment: WrapAlignment.spaceBetween,
                                  direction: Axis.horizontal,
                                  spacing: 10,
                                  children: [
                                    SubTilesAnime(
                                        title: 'Estado',
                                        subtitle: anime.debut,
                                        size: size),
                                    SubTilesAnime(
                                        title: 'Tipo',
                                        subtitle: anime.type,
                                        size: size),
                                    HeroAnimationWidget(
                                        tag: tag,
                                        heroTag: anime.rating + anime.title,
                                        child: SubTilesAnime(
                                            title: 'Valoración',
                                            subtitle: anime.rating,
                                            size: size)),
                                    if (anime.genres.isNotEmpty)
                                      SubTilesAnime(
                                          title: 'Géneros',
                                          subtitle: anime.genres
                                              .join(', ')
                                              .toUpperCase(),
                                          size: size)
                                  ])))
            ],
        body: Material(
            child: SafeArea(
                minimum: EdgeInsets.only(top: size.height * 0.1),
                child: DefaultTabController(
                    length: countTabBar(),
                    initialIndex: currentPage,
                    child: Column(children: [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05),
                          child: TabBar(
                              onTap: (value) => onTap(value),
                              dividerColor: Colors.transparent,
                              labelColor: Colors.white,
                              // Color del texto seleccionado
                              unselectedLabelColor: Colors.grey.withAlpha(80),
                              // Color del texto no seleccionado
                              tabs: [
                                Tab(
                                    icon: const Icon(Icons.tv),
                                    text:
                                        'Episodios (${anime.episodes.length})'),
                                if (anime.synopsis.isNotEmpty)
                                  const Tab(
                                      icon: Icon(Icons.description_sharp),
                                      text: 'Synopsis'),
                                if (anime.listAnimeRelated.isNotEmpty)
                                  const Tab(
                                      icon: Icon(Icons.movie),
                                      text: 'Relacionados')
                              ])),
                      Expanded(
                          child: TabBarView(children: [
                        ListEpisodesWidget(
                            anime: anime,
                            episodes: listAnimeFilter,
                            textController: textController,
                            action: action,
                            onTapSaveEpisode: onTapSaveEpisode),
                        if (anime.synopsis.isNotEmpty)
                          SynopsysWidget(title: anime.synopsis),
                        if (anime.listAnimeRelated.isNotEmpty)
                          CustomScrollView(slivers: [
                            SliverPadding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: padding08),
                                sliver: SliverGrid.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 220,
                                            crossAxisSpacing: 30,
                                            mainAxisExtent: 280,
                                            mainAxisSpacing: 30),
                                    itemCount: anime.listAnimeRelated.length,
                                    itemBuilder: (context, index) =>
                                        BannerAnime(
                                          size: size,
                                          theme: theme,
                                          isPortrait: isPortrait,
                                          anime: anime.listAnimeRelated[index],
                                          tag: 'animeSearch',
                                          onTapElement:
                                              ({required id, tag, required title}) =>   onTapElement(id, tag),

                                        )))
                          ])
                      ]))
                    ])))));
  }
}
