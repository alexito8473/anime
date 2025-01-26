import 'dart:io';

import 'package:anime/data/typeAnime/type_data.dart';
import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import '../../../data/model/basic_anime.dart';
import '../../../data/model/anime.dart';
import '../../../data/model/last_episode.dart';
import '../animation/hero_animation_widget.dart';
import '../button/button_widget.dart';
import '../load/load_widget.dart';
import '../title/title_widget.dart';

class BannerWidget extends StatelessWidget {
  final List<LastEpisode> lastEpisodes;
  final Size size;
  final Orientation orientation;
  const BannerWidget(
      {super.key,
      required this.lastEpisodes,
      required this.size,
      required this.orientation});

  @override
  Widget build(BuildContext context) {
    double height =
        orientation == Orientation.portrait ? size.height * 0.4 : 300;
    if (lastEpisodes.isEmpty) {
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
        child: Container(
            constraints: const BoxConstraints(minHeight: 300),
            child: Stack(children: [
              Positioned.fill(
                  child: FlutterCarousel(
                      items: lastEpisodes
                          .map((lastEpisode) =>
                              BannerCarrouselAnime(lastEpisode: lastEpisode))
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
                              left: size.width * 0.05, top: size.height * 0.01),
                          child: const TitleBannerWidget(
                              title: "Últimos episódeos agregados",
                              color: Colors.orange,
                              shadows: [
                                Shadow(
                                    offset: Offset(
                                        2.0, 3.0), // Desplazamiento en X e Y
                                    blurRadius: 5.0, // Difuminado
                                    color: Colors.black)
                              ]))))
            ])));
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

class ListBannerAnime extends StatelessWidget {
  final List<Anime> listAnime;
  final Size size;
  final String tag;
  final String title;
  final TypeAnime typeAnime;
  final Color colorTitle;
  const ListBannerAnime(
      {super.key,
      required this.listAnime,
      required this.size,
      required this.tag,
      required this.title,
      required this.typeAnime,
      required this.colorTitle});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Column(
            spacing: 20,
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
                        tag: tag, title: title, color: colorTitle),
                    ButtonNavigateListAnime(
                        color: colorTitle,
                        animes: listAnime,
                        tag: tag,
                        title: title,
                        typeAnime: typeAnime,
                        colorTitle: colorTitle)
                  ])),
          if (Platform.isWindows || Platform.isMacOS)
            SizedBox(
                width: size.width,
                height: 300,
                child: DragCarousel(listAnime: listAnime, tag: tag)),
          if (Platform.isAndroid || Platform.isIOS)
            SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.05,
                    horizontal: size.width * 0.05),
                scrollDirection: Axis.horizontal,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: size.width * 0.05,
                    children: listAnime
                        .map((lastAnime) =>
                            BannerAnime(anime: lastAnime, tag: tag))
                        .toList()))
        ]));
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
        child: Container(
          constraints: const BoxConstraints(minWidth: 150),
            width: orientation == Orientation.portrait
                ? size.width * 0.4
                : size.width * 0.15,
            child: Column(
                spacing: size.height * 0.005,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 180,
                      child: Stack(children: [
                        Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: HeroAnimationWidget(
                                tag: tag,
                                heroTag: anime.poster,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                        imageUrl: anime.poster,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, progress) {
                                          return const LoadWidget();
                                        },
                                        filterQuality: FilterQuality.high)))),
                        Positioned(
                            top: 15,
                            left: 8,
                            child: HeroAnimationWidget(
                                tag: tag,
                                heroTag: anime.rating + anime.title,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(anime.rating,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(color: Colors.yellow)),
                                )))
                      ])),
                  TitleWidget(
                      title: anime.title,
                      maxLines: 3,
                      textStyle: Theme.of(context).textTheme.titleSmall!,
                      tag: tag)
                ])));
  }
}

class BannerAnimeReload extends StatelessWidget {
  const BannerAnimeReload({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    return SizedBox(
      width: orientation == Orientation.portrait
          ? size.width * 0.3
          : size.width * 0.15,
      child: Column(
          spacing: size.height * 0.005,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: orientation == Orientation.portrait
                    ? size.width * 0.3
                    : size.width * 0.1,
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
  final List<BasicAnime> listAringAnime;
  final Size size;
  const ListAiringAnime(
      {super.key, required this.listAringAnime, required this.size});
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
        padding: EdgeInsets.only(
            left: size.width * 0.05,
            right: size.width * 0.05,
            bottom: size.height * 0.1),
        sliver: SliverList.builder(
            itemBuilder: (context, index) => BannerAiringAnime(
                size: size, aringAnime: listAringAnime[index]),
            itemCount: listAringAnime.length));
  }
}

class DragCarousel extends StatefulWidget {
  final List<Anime> listAnime;
  final String? tag;
  const DragCarousel({super.key, required this.listAnime, required this.tag});

  @override
  _DragCarouselState createState() => _DragCarouselState();
}

class _DragCarouselState extends State<DragCarousel> {
  final ScrollController _scrollController = ScrollController();
  Offset? _dragStartOffset;
  double _initialScrollOffset = 0.0;
  double _lastDragDelta = 0.0;
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.sizeOf(context);
    return Listener(
        onPointerDown: (event) {
          // Guarda la posición inicial del clic y el desplazamiento actual del scroll
          _dragStartOffset = event.position;
          _initialScrollOffset = _scrollController.offset;
          _lastDragDelta = 0.0; // Resetea el delta al iniciar el arrastre
        },
        onPointerMove: (event) {
          if (_dragStartOffset != null) {
            final dragDelta = event.position.dx - _dragStartOffset!.dx;
            _lastDragDelta = dragDelta; // Guarda el último delta registrado

            // Actualiza la posición del scroll en tiempo real
            _scrollController.jumpTo((_initialScrollOffset - dragDelta).clamp(
              0.0,
              _scrollController.position.maxScrollExtent,
            ));
          }
        },
        onPointerUp: (event) {
          if (_lastDragDelta.abs() > 5) {
            final direction =
                _lastDragDelta > 0 ? -1 : 1; // Determina la dirección
            final extraScroll =
                direction * 100; // Define cuánto más desplazarse

            _scrollController.animateTo(
              (_scrollController.offset + extraScroll).clamp(
                0.0,
                _scrollController.position.maxScrollExtent,
              ),
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear,
            );
          }
          // Reinicia el estado
          _dragStartOffset = null;
          _lastDragDelta = 0.0;
        },
        child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.listAnime.length,
            separatorBuilder: (context, index) {
              return Container(width: 50);
            },
            itemBuilder: (context, index) {
              return BannerAnime(
                  anime: widget.listAnime[index], tag: widget.tag);
            }));
  }
}
