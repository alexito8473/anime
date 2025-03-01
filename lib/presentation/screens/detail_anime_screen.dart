import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/data/model/episode.dart';
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
                        length: anime.synopsis.isNotEmpty ? 2 : 1,
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
                                          text: "Synopsis")
                                  ])),
                          Expanded(
                              child: TabBarView(children: [
                            ListEpisodes(
                                anime: anime,
                                episodes: listAnimeFilter,
                                textController: textController,
                                action: action,
                                onTapSaveEpisode: onTapSaveEpisode),
                            SynopsysWidget(title: anime.synopsis)
                          ]))
                        ]))))));
  }
}
