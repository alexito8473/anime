import 'package:flutter/material.dart';
import '../../data/anime.dart';
import '../../data/episode.dart';
import '../widgets/banner/episode_widget.dart';
import '../widgets/detail_anime_widget/deatil_widget.dart';

class DetailAnimePage extends StatefulWidget {
  final Anime anime;
  const DetailAnimePage({super.key, required this.anime});
  @override
  State<DetailAnimePage> createState() => _DetailAnimePageState();
}

class _DetailAnimePageState extends State<DetailAnimePage> {
  late List<Episode> listAnimeFilter;
  final TextEditingController _controller = TextEditingController();
  int _currentPage = 0;
  @override
  void initState() {
    listAnimeFilter = List.from(widget.anime.episodes);
    super.initState();
  }

  void onSubmit() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        listAnimeFilter = widget.anime.episodes
            .where((element) =>
                element.episode.toString().contains(_controller.text))
            .toList();
      });
    } else {
      listAnimeFilter = List.from(widget.anime.episodes);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AppBarDetailAnime(anime: widget.anime),
          if (widget.anime.synopsis.isNotEmpty)
            SliverToBoxAdapter(
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: BottomNavigationBar(
                            iconSize: 20,
                            onTap: (value) =>
                                setState(() => _currentPage = value),
                            currentIndex: _currentPage,
                            items: [
                              BottomNavigationBarItem(
                                  icon: const Icon(Icons.tv),
                                  label:
                                      "Episodeos(${widget.anime.episodes.length})"),
                              if (widget.anime.synopsis.isNotEmpty)
                                const BottomNavigationBarItem(
                                    icon: Icon(Icons.description_sharp),
                                    label: "Synopsis")
                            ])))),
          if (_currentPage == 0)
            SliverAppBar(
                floating: true,
                snap: true,
                pinned: true,
                automaticallyImplyLeading: false,
                expandedHeight: size.height * 0.02,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                    stretchModes: StretchMode.values,
                    titlePadding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    title: Container(
                        decoration: BoxDecoration(
                            color: Colors
                                .grey[850], // Fondo oscuro para el buscador
                            borderRadius: BorderRadius.circular(20)),
                        child: TextField(
                            controller: _controller,
                            onSubmitted: (value) {
                              onSubmit();
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: 'Buscar...',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                icon: IconButton(
                                    onPressed: () {
                                      onSubmit();
                                    },
                                    icon: const Icon(Icons.search,
                                        color: Colors.orange)),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10)))))),
          if (_currentPage == 0)
            if (listAnimeFilter.isNotEmpty)
              ListEpisodes(anime: widget.anime, episodes: listAnimeFilter),
          if (listAnimeFilter.isEmpty)
            const SliverFillRemaining(
                child: Center(child: Text("No se encontraron episodios"))),
          if (_currentPage == 1 && widget.anime.synopsis.isNotEmpty)
            SynopsysWidget(title: widget.anime.synopsis)
        ],
      ),
    );
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
