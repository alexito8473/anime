import 'package:anime/data/airing_anime.dart';
import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import '../../../data/last/last_anime.dart';
import '../../../data/last/last_episode.dart';
import '../title/title_widget.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      return SliverToBoxAdapter(
          child: SizedBox(
              height: size.height * 0.4,
              child: Stack(
                children: [
                  Positioned.fill(
                      child: FlutterCarousel(
                          items: state.lastEpisodes
                              .map((lastEpisode) => BannerCarrouselAnime(
                                  lastEpisode: lastEpisode))
                              .toList(),
                          options: FlutterCarouselOptions(
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              viewportFraction: 1,
                              autoPlayCurve: Curves.bounceInOut,
                              allowImplicitScrolling: true,
                              height: size.height * 0.4,
                              showIndicator: true))),
                  Positioned(
                      child: SafeArea(
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: size.width * 0.05,
                                  top: size.height * 0.01),
                              child: Text("Ultimos episodeos agregados",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          shadows: [
                                        const Shadow(
                                            offset: Offset(2.0,
                                                3.0), // Desplazamiento en X e Y
                                            blurRadius: 5.0, // Difuminado
                                            color: Colors.black)
                                      ],
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold)))))
                ],
              )));
    });
  }
}

class BannerCarrouselAnime extends StatelessWidget {
  final LastEpisode lastEpisode;
  const BannerCarrouselAnime({super.key, required this.lastEpisode});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
        onTap: () async {
          context.read<AnimeBloc>().add(ObtainDataAnime(
              context: context,
              title: lastEpisode.getTitle(),
              id: lastEpisode.idAnime()));
        },
        child: Stack(children: [
          Positioned.fill(
              child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black38,
                        Colors.black45,
                        Colors.black87,
                        Colors.black
                      ],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.darken,
                  child: CachedNetworkImage(
                      imageUrl: lastEpisode.imagePreview,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      errorWidget: (context, child, loadingProgress) {
                        return const Center(child: CircularProgressIndicator());
                      }))),
          Positioned(
              bottom: size.height * 0.05,
              left: size.width * 0.05,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: size.width * 0.95,
                        child: Text(lastEpisode.anime,
                            style: Theme.of(context).textTheme.titleLarge,
                            softWrap: true)),
                    Text("Episode : ${lastEpisode.episode}",
                        style: Theme.of(context).textTheme.titleMedium)
                  ]))
        ]));
  }
}

class ListBannerAnimeAddWidget extends StatelessWidget {
  const ListBannerAnimeAddWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      return SliverToBoxAdapter(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.05, top: size.height * 0.05),
            child: AutoSizeText("Últimos animes agregados",
                maxLines: 1,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold))),
        SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                vertical: size.height * 0.05, horizontal: size.width * 0.05),
            scrollDirection: Axis.horizontal,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: size.width * 0.1,
                children: state.lastAnimesAdd.map((lastAnime) {
                  return BannerLastAnime(lastAnime: lastAnime);
                }).toList()))
      ]));
    });
  }
}

class BannerLastAnime extends StatelessWidget {
  final LastAnime lastAnime;
  const BannerLastAnime({super.key, required this.lastAnime});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
        onTap: () async {
          context.read<AnimeBloc>().add(ObtainDataAnime(
              context: context,
              id: lastAnime.idAnime(),
              title: lastAnime.getTitle()));
        },
        child: SizedBox(
            width: size.width * 0.3,
            child: Column(
                spacing: size.height * 0.005,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                      tag: lastAnime.poster,
                      child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                  imageUrl: lastAnime.poster,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high)))),
                  TitleWidget(
                      title: lastAnime.title,
                      maxLines: 2,
                      textStyle: Theme.of(context).textTheme.titleSmall!,
                      tag: lastAnime.title),
                  Hero(
                    tag: lastAnime.rating + lastAnime.title,
                    child: Material(
                        color: Colors.transparent,
                        child: Text("Rating : ${lastAnime.rating}")),
                  )
                ])));
  }
}

class BannerAiringAnime extends StatelessWidget {
  final AiringAnime aringAnime;
  final Size size;

  const BannerAiringAnime(
      {super.key, required this.aringAnime, required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.read<AnimeBloc>().add(ObtainDataAnime(
              title: aringAnime.title, id: aringAnime.id, context: context));
        },
        child: Card(
            color: Colors.grey.withOpacity(0.2),
            child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: size.height * 0.01),
                child: Row(spacing: 10, children: [
                  Expanded(
                      child: AutoSizeText(aringAnime.title,
                          style: Theme.of(context).textTheme.labelLarge,
                          maxLines: 3)),
                  AutoSizeText("(${aringAnime.type})",
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: Colors.orange),
                      maxLines: 3),
                  const Icon(Icons.arrow_right_outlined, size: 40)
                ]))));
  }
}

class ListAiringAnime extends StatelessWidget {
  const ListAiringAnime({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      return SliverPadding(
          padding: EdgeInsets.only(
              left: size.width * 0.05,
              right: size.width * 0.05,
              bottom: size.height * 0.2),
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                  childCount: state.listAringAnime.length, (context, index) {
            return BannerAiringAnime(
                size: size, aringAnime: state.listAringAnime[index]);
          })));
    });
  }
}
