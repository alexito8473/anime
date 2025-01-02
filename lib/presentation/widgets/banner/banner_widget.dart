import 'package:animate_do/animate_do.dart';
import 'package:anime/data/airing_anime.dart';
import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import '../../../data/last/anime.dart';
import '../../../data/last/last_episode.dart';
import '../button/button_widget.dart';
import '../title/title_widget.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<AnimeBloc, AnimeState>(
        builder: (context, state) => SliverToBoxAdapter(
            child: FadeIn(
                duration: const Duration(milliseconds: 700),
                curve: Curves.linear,
                child: SizedBox(
                    height: size.height * 0.4,
                    child: Stack(children: [
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
                                  autoPlayCurve: Curves.linear,
                                  allowImplicitScrolling: true,
                                  height: size.height * 0.4,
                                  showIndicator: true))),
                      Positioned(
                          child: SafeArea(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: size.width * 0.05,
                                      top: size.height * 0.01),
                                  child: const TitleBannerWidget(
                                      title: "Últimos episódeos agregados",
                                      color: Colors.orange,
                                      shadows: [
                                        Shadow(
                                            offset: Offset(2.0,
                                                3.0), // Desplazamiento en X e Y
                                            blurRadius: 5.0, // Difuminado
                                            color: Colors.black)
                                      ]))))
                    ])))));
  }
}

class BannerCarrouselAnime extends StatelessWidget {
  final LastEpisode lastEpisode;
  const BannerCarrouselAnime({super.key, required this.lastEpisode});

  void obtainData({required BuildContext context}) =>
      context.read<AnimeBloc>().add(ObtainDataAnime(
          context: context,
          title: lastEpisode.getTitle(),
          id: lastEpisode.idAnime(),
          tag: null));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
        onTap: () => obtainData(context: context),
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
                      errorWidget: (context, child, loadingProgress) =>
                          const Center(child: CircularProgressIndicator())))),
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

class ListAnimeSaveWidget extends StatelessWidget {
  const ListAnimeSaveWidget({super.key});

  final String tag = "favoritos";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      if (state.listAnimeSave.isEmpty) {
        return const SliverToBoxAdapter();
      }
      return SliverToBoxAdapter(
          child: FadeIn(
              duration: const Duration(milliseconds: 700),
              curve: Curves.linear,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            right: size.width * 0.05,
                            left: size.width * 0.05,
                            top: size.height * 0.05),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            TitleBannerWidget(
                                tag: tag,
                                title: "Ánimes favoritos",
                                color: Colors.amber),
                            ButtonNavigateListAnime(
                                color: Colors.orangeAccent,
                                animes: state.listAnimeSave,
                                tag: tag,
                                title: "Ánimes favoritos",
                                colorTitle: Colors.amber)
                          ],
                        )),
                    SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.05,
                            horizontal: size.width * 0.05),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: size.width * 0.1,
                            children: state.listAnimeSave
                                .map((lastAnime) =>
                                    BannerAnime(anime: lastAnime, tag: tag))
                                .toList()))
                  ])));
    });
  }
}

class ListBannerAnimeAddWidget extends StatelessWidget {
  const ListBannerAnimeAddWidget({super.key});
  final String tag = 'agregados';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<AnimeBloc, AnimeState>(
        builder: (context, state) => SliverToBoxAdapter(
            child: FadeIn(
                duration: const Duration(milliseconds: 700),
                curve: Curves.linear,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              right: size.width * 0.05,
                              left: size.width * 0.05,
                              top: size.height * 0.05),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              TitleBannerWidget(
                                  tag: tag,
                                  title: "Últimos animes agregados",
                                  color: Colors.blueAccent),
                              ButtonNavigateListAnime(
                                  color: Colors.lightBlue,
                                  animes: state.lastAnimesAdd,
                                  tag: tag,
                                  title: "Últimos animes agregados",
                                  colorTitle: Colors.blueAccent)
                            ],
                          )),
                      SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.05,
                              horizontal: size.width * 0.05),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: size.width * 0.1,
                              children: state.lastAnimesAdd
                                  .map((lastAnime) =>
                                      BannerAnime(anime: lastAnime, tag: tag))
                                  .toList()))
                    ]))));
  }
}

class BannerAnime extends StatelessWidget {
  final Anime anime;
  final String? tag;
  const BannerAnime({super.key, required this.anime, required this.tag});

  Widget buildImg() => AspectRatio(
      aspectRatio: 3 / 4,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
              imageUrl: anime.poster,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high)));

  Widget buildText() => Text("Rating : ${anime.rating}");

  void onTap({required BuildContext context}) =>
      context.read<AnimeBloc>().add(ObtainDataAnime(
          tag: tag,
          context: context,
          id: anime.idAnime(),
          title: anime.getTitle()));
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
        onTap: () => onTap(context: context),
        child: SizedBox(
            width: size.width * 0.3,
            child: Column(
                spacing: size.height * 0.005,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tag != null
                      ? Hero(
                          tag: tag.toString() + anime.poster, child: buildImg())
                      : buildImg(),
                  TitleWidget(
                      title: anime.title,
                      maxLines: 3,
                      textStyle: Theme.of(context).textTheme.titleSmall!,
                      tag: tag),
                  tag != null
                      ? Hero(
                          tag: tag.toString() + anime.rating + anime.title,
                          child: Material(
                              color: Colors.transparent, child: buildText()))
                      : buildText()
                ])));
  }
}

class BannerAiringAnime extends StatelessWidget {
  final AiringAnime aringAnime;
  final Size size;

  const BannerAiringAnime(
      {super.key, required this.aringAnime, required this.size});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => context.read<AnimeBloc>().add(ObtainDataAnime(
          title: aringAnime.title,
          id: aringAnime.id,
          context: context,
          tag: null)),
      child: Card(
          color: Colors.grey.withOpacity(0.2),
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: size.height * 0.01),
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

class ListAiringAnime extends StatelessWidget {
  const ListAiringAnime({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<AnimeBloc, AnimeState>(
        builder: (context, state) => SliverPadding(
            padding: EdgeInsets.only(
                left: size.width * 0.05,
                right: size.width * 0.05,
                bottom: size.height * 0.2),
            sliver: SliverList.builder(
                itemBuilder: (context, index) => BannerAiringAnime(
                    size: size, aringAnime: state.listAringAnime[index]),
                itemCount: state.listAringAnime.length)));
  }
}
