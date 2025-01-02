import 'package:anime/data/complete_anime.dart';
import 'package:flutter/material.dart';
import '../../data/episode.dart';
import '../widgets/banner/episode_widget.dart';
import '../widgets/detail_anime_widget/deatil_widget.dart';
import '../widgets/sliver/sliver_widget.dart';

class DetailAnimeScreen extends StatelessWidget {
  final CompleteAnime anime;
  final Size size;
  final Function onTap;
  final int currentPage;
  final Function obSubmit;
  final List<Episode> listAnimeFilter;
  final TextEditingController textController;
  final String? tag;
  const DetailAnimeScreen(
      {super.key,
      required this.anime,
      required this.size,
      required this.onTap,
      required this.currentPage,
      required this.obSubmit,
      required this.listAnimeFilter,
      required this.textController,
      required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          AppBarDetailAnime(anime: anime, tag: tag),
          if (anime.synopsis.isNotEmpty)
            SliverToBoxAdapter(
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: BottomNavigationBar(
                            iconSize: 20,
                            onTap: (value) => onTap(value),
                            currentIndex: currentPage,
                            items: [
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.tv),
                                  label: "Episódeos(${anime.episodes.length})"),
                              if (anime.synopsis.isNotEmpty)
                                const BottomNavigationBarItem(
                                    icon: Icon(Icons.description_sharp),
                                    label: "Synopsis")
                            ])))),
          if (currentPage == 0)
            SliverAppBarSearch(controller: textController, onSubmit: obSubmit),
          if (currentPage == 0)
            if (listAnimeFilter.isNotEmpty)
              ListEpisodes(anime: anime, episodes: listAnimeFilter),
          if (listAnimeFilter.isEmpty)
            const SliverFillRemaining(
                child: Center(child: Text("No se encontraron episodios"))),
          if (currentPage == 1 && anime.synopsis.isNotEmpty)
            SynopsysWidget(title: anime.synopsis)
        ],
      ),
    );
  }
}
