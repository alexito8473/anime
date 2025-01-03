import 'package:animate_do/animate_do.dart';
import 'package:anime/data/typeAnime/type_data.dart';
import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import '../../../data/model/basic_anime.dart';
import '../../../data/model/anime.dart';
import '../../../data/model/last_episode.dart';
import '../animation/hero_animation_widget.dart';
import '../button/button_widget.dart';
import '../title/title_widget.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    double height = MediaQuery.of(context).orientation == Orientation.portrait
        ? size.height * 0.4
        : 300;

    return BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      if (state.lastEpisodes.isEmpty) {
        return SliverToBoxAdapter(
            child: Container(
                height: size.height * 0.5,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
                constraints: const BoxConstraints(minHeight: 300),
                child: const Center(
                    child: LinearProgressIndicator(
                        backgroundColor: Colors.blueAccent))));
      }

      return SliverToBoxAdapter(
          child: FadeIn(
              duration: const Duration(milliseconds: 700),
              curve: Curves.linear,
              child: Container(
                  height: size.height * 0.4,
                  constraints: const BoxConstraints(minHeight: 300),
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
                                height: height,
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
                  ]))));
    });
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
      bool isInferior = state.countAnimeSave <= 5;
      if (state.countAnimeSave == 0) {
        return const SliverToBoxAdapter(child: SizedBox(height: 1, width: 1));
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
                                colorTitle: Colors.amber,
                                typeAnime: TypeAnime.SAVE,
                              )
                            ])),
                    SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.05,
                            horizontal: size.width * 0.05),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: size.width * 0.1,
                            children: List.generate(
                                isInferior ? state.countAnimeSave : 5, (index) {
                              if (index < state.listAnimeSave.length) {
                                return BannerAnime(
                                    anime: state.listAnimeSave[index],
                                    tag: tag);
                              }

                              return const BannerAnimeReload();
                            })))
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
                                    typeAnime: TypeAnime.ADD,
                                    colorTitle: Colors.blueAccent)
                              ])),
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

  void onTap({required BuildContext context}) =>
      context.read<AnimeBloc>().add(ObtainDataAnime(
          tag: tag,
          context: context,
          id: anime.idAnime(),
          title: anime.getTitle()));

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    return GestureDetector(
        onTap: () => onTap(context: context),
        child: SizedBox(
          width: orientation == Orientation.portrait
              ? size.width * 0.3
              : size.width * 0.15,
          child: Column(
              spacing: size.height * 0.005,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeroAnimationWidget(
                    tag: tag,
                    heroTag: anime.poster,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                            imageUrl: anime.poster,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.high))),
                TitleWidget(
                    title: anime.title,
                    maxLines: 3,
                    textStyle: Theme.of(context).textTheme.titleSmall!,
                    tag: tag),
                HeroAnimationWidget(
                    tag: tag,
                    heroTag: anime.rating + anime.title,
                    child: Text("Rating : ${anime.rating}"))
              ]),
        ));
  }
}
class BannerAnimeReload extends StatelessWidget {
  const BannerAnimeReload({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    return  SizedBox(
          width: orientation == Orientation.portrait
              ? size.width * 0.3
              : size.width * 0.15,
          child: Column(
              spacing: size.height * 0.005,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: orientation==Orientation.portrait ? size.width * 0.3 : size.width * 0.1,
                    height: 180,
                    decoration: BoxDecoration(
                        color: Colors.grey.withAlpha(30),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ))),
                TitleWidget(
                    title: " ",
                    maxLines: 3,
                    textStyle: Theme.of(context).textTheme.titleSmall!,
                    tag: null),
                const Text("Rating : ")
              ]),
        );
  }
}

class BannerAiringAnime extends StatelessWidget {
  final BasicAnime aringAnime;
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
