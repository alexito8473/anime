import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/data/model/episode.dart';
import 'package:anime/presentation/widgets/banner/banner_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/banner/episode_widget.dart';
import '../widgets/detail/deatil_widget.dart';

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
      required this.safeAnime});

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
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  AppBarDetailAnime(
                      anime: anime, tag: tag, safeAnime: safeAnime)
                ],
            body: SafeArea(
                child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(30), // Bordes redondeados
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
                                  unselectedLabelColor:
                                      Colors.grey.withAlpha(80),
                                  // Color del texto no seleccionado
                                  tabs: [
                                    Tab(
                                        icon: const Icon(Icons.tv),
                                        text:
                                            "Episodios (${anime.episodes.length})"),
                                    if (anime.synopsis.isNotEmpty)
                                      const Tab(
                                          icon: Icon(Icons.description_sharp),
                                          text: "Synopsis"),
                                    if (anime.listAnimeRelated.isNotEmpty)
                                      const Tab(
                                          icon: Icon(Icons.movie),
                                          text: "Relacionados")
                                  ])),
                          Expanded(
                              child: TabBarView(children: [
                            ListEpisodes(
                                anime: anime,
                                episodes: listAnimeFilter,
                                textController: textController,
                                action: action,
                                onTapSaveEpisode: onTapSaveEpisode),
                            if (anime.synopsis.isNotEmpty)
                              SynopsysWidget(title: anime.synopsis),
                            if (anime.listAnimeRelated.isNotEmpty)
                              CustomScrollView(
                                slivers: [
                                  SliverPadding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.width * 0.08),
                                      sliver: SliverGrid.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 220,
                                                  crossAxisSpacing: 30,
                                                  mainAxisExtent: 280,
                                                  mainAxisSpacing: 30),
                                          itemCount:
                                              anime.listAnimeRelated.length,
                                          itemBuilder: (context, index) =>
                                              BannerAnime(
                                                  anime: anime
                                                      .listAnimeRelated[index],
                                                  tag: 'animeSearch')))
                                ],
                              )
                          ]))
                        ]))))));
  }
}
