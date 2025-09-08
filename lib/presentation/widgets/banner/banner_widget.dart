import 'dart:ui';
import 'package:anime/data/enums/type_data.dart';
import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

import '../../../data/enums/gender.dart';
import '../../../data/interface/anime_interface.dart';
import '../../../data/model/anime.dart';
import '../../../data/model/basic_anime.dart';
import '../../../data/model/last_episode.dart';
import '../animation/hero_animation_widget.dart';
import '../button/button_widget.dart';
import '../load/load_widget.dart';
import '../title/title_widget.dart';

class SliverMainImage extends StatelessWidget {
  final AnimeBanner anime;
  final void Function({required String id, String? tag, required String title})
      onTapElement;

  const SliverMainImage(
      {super.key, required this.anime, required this.onTapElement});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SliverToBoxAdapter(
        child: SizedBox(
      width: size.width,
      height: size.height * 0.7,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
              child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black, Colors.transparent])
                      .createShader(bounds),
                  blendMode: BlendMode.srcOver,
                  child: Padding(
                      padding:
                          EdgeInsetsGeometry.only(bottom: size.height * 0.05),
                      child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: CachedNetworkImage(
                              imageUrl: anime.getImage(),
                              fit: BoxFit.cover,
                              color: Colors.black45,
                              colorBlendMode: BlendMode.darken,
                              filterQuality: FilterQuality.high))))),
          SafeArea(
              child: Container(
                  margin: EdgeInsets.only(
                    bottom: size.height * 0.05,
                    left: size.width * 0.1,
                    right: size.width * 0.1,
                  ),
                  width: size.width,
                  height: size.height * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Colors.white, blurRadius: 10)
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(20),
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: CachedNetworkImage(
                                imageUrl: anime.getImage(),
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high)),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 20,
                            children: [
                              ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.white70),
                                ),
                                onPressed: () => onTapElement(
                                  title: anime.getTitle(),
                                  id: anime.idAnime(),
                                  tag: null,
                                ),
                                child: const AutoSizeText('Ver ultimo anime'),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  bottom: size.height * 0.02,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.1,
                                    vertical: size.height * 0.02),
                                child: AutoSizeText(
                                  anime.getTitle(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(shadows: [
                                    const Shadow(
                                        color: Colors.black,
                                        blurRadius: 5,
                                        offset: Offset(2, 2))
                                  ]),
                                  maxLines: 3,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )))

          /// Imagen principal sin blur
          ,
        ],
      ),
    ));
  }
}

class BannerWidget extends StatelessWidget {
  final List<LastEpisode> lastEpisodes;
  final Size size;
  final Orientation orientation;
  final void Function({required String id, String? tag, required String title})
      onTapElement;

  const BannerWidget(
      {super.key,
      required this.lastEpisodes,
      required this.size,
      required this.orientation,
      required this.onTapElement});

  @override
  Widget build(BuildContext context) {
    final double height =
        orientation == Orientation.portrait ? size.height * 0.5 : 300;
    if (lastEpisodes.isEmpty) {
      return SliverToBoxAdapter(
          child: Container(
              constraints: const BoxConstraints(minHeight: 300),
              height: height,
              child: Stack(children: [
                Positioned.fill(
                    child: FlutterCarousel(
                        items: Gender.values.sublist(1, 7).map((gender) {
                          return ShaderMask(
                              shaderCallback: (bounds) {
                                return const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black54,
                                      Colors.black
                                    ]).createShader(bounds);
                              },
                              blendMode: BlendMode.darken,
                              child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                      tileMode: TileMode.decal,
                                      sigmaX: 4,
                                      sigmaY: 4),
                                  child: Image.asset(gender.getImage(),
                                      filterQuality: FilterQuality.none,
                                      isAntiAlias: false,
                                      color: Colors.black.withAlpha(130),
                                      width: size.width,
                                      colorBlendMode: BlendMode.darken,
                                      fit: BoxFit.cover)));
                        }).toList(),
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
                                title: 'Últimos episódeos agregados',
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

    return SliverToBoxAdapter(
        child: Container(
            constraints: const BoxConstraints(minHeight: 300),
            height: height,
            child: Stack(children: [
              Positioned.fill(
                  child: FlutterCarousel(
                      items: lastEpisodes
                          .map((lastEpisode) => RepaintBoundary(
                              child: BannerCarrouselAnime(
                                  lastEpisode: lastEpisode,
                                  onTapElement: onTapElement)))
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
                              title: 'Últimos episodeos agregados',
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
  final void Function({required String id, String? tag, required String title})
      onTapElement;

  const BannerCarrouselAnime(
      {super.key, required this.lastEpisode, required this.onTapElement});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
        onTap: () => onTapElement(
            id: lastEpisode.idAnime(),
            title: lastEpisode.getTitle(),
            tag: null),
        child: Stack(children: [
          Positioned.fill(
              child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        tileMode: TileMode.repeated,
                        colors: [
                          Colors.transparent,
                          Colors.black12,
                          Colors.black
                        ]).createShader(bounds);
                  },
                  blendMode: BlendMode.darken,
                  child: CachedNetworkImage(
                      imageUrl: lastEpisode.imagePreview,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      filterQuality: FilterQuality.high,
                      errorWidget: (context, child, loadingProgress) =>
                          const Center(child: CircularProgressIndicator())))),
          Positioned(
              bottom: size.height * 0.05,
              left: size.width * 0.05,
              right: size.width * 0.05,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: size.width * 0.95,
                        child: Text(lastEpisode.anime,
                            style: Theme.of(context).textTheme.titleMedium,
                            softWrap: true)),
                    Text('Episodeo : ${lastEpisode.episode}',
                        style: Theme.of(context).textTheme.titleMedium)
                  ]))
        ]));
  }
}

class ListBannerAnime extends StatelessWidget {
  final List<AnimeBanner> listAnime;
  final String tag;
  final String title;
  final TypeAnime typeAnime;
  final Color colorTitle;
  final void Function({required String id, String? tag, required String title})
      onTapElement;

  const ListBannerAnime(
      {super.key,
      required this.listAnime,
      required this.tag,
      required this.title,
      required this.typeAnime,
      required this.colorTitle,
      required this.onTapElement});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final ThemeData theme = Theme.of(context);
    final bool isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return SliverToBoxAdapter(
        child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Padding(
              padding: EdgeInsets.only(
                  right: size.width * 0.05,
                  left: size.width * 0.05,
                  top: size.height * 0.01),
              child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TitleBannerWidget(
                        tag: tag, title: title, color: colorTitle),
                    ButtonNavigateListAnimeWidget(
                        color: colorTitle,
                        animes: listAnime,
                        tag: tag,
                        title: title,
                        typeAnime: typeAnime,
                        colorTitle: colorTitle)
                  ])),
          listAnime.isEmpty
              ? SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.05,
                      horizontal: size.width * 0.05),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      spacing: size.width * 0.05,
                      children: Gender.values.sublist(9, 12).map(
                        (gender) {
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                      tileMode: TileMode.decal,
                                      sigmaX: 6,
                                      sigmaY: 6),
                                  child: Container(
                                      constraints:
                                          const BoxConstraints(minWidth: 150),
                                      width: size.width * 0.45,
                                      child: Column(
                                          spacing: size.height * 0.005,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                height: 180,
                                                child: Stack(children: [
                                                  Positioned(
                                                      top: 0,
                                                      left: 0,
                                                      right: 0,
                                                      bottom: 0,
                                                      child: Image.asset(
                                                          gender.getImage(),
                                                          fit: BoxFit.cover,
                                                          filterQuality:
                                                              FilterQuality
                                                                  .high)),
                                                  Positioned(
                                                      top: 15,
                                                      left: 8,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Text('5.0',
                                                            style: theme
                                                                .textTheme
                                                                .labelLarge
                                                                ?.copyWith(
                                                                    color: Colors
                                                                        .yellow)),
                                                      ))
                                                ]))
                                          ]))));
                        },
                      ).toList()))
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.01,
                      horizontal: size.width * 0.05),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: size.width * 0.05,
                      children: listAnime
                          .map((lastAnime) => BannerAnime(
                              anime: lastAnime,
                              theme: theme,
                              isPortrait: isPortrait,
                              size: size,
                              tag: tag,
                              onTapElement: onTapElement))
                          .toList()))
        ]));
  }
}

class BannerBlur extends StatelessWidget {
  final String text;
  final String image;

  const BannerBlur({super.key, required this.text, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Image.asset(image,
                  width: double.infinity,
                  height: double.infinity,
                  filterQuality: FilterQuality.none,
                  isAntiAlias: false,
                  color: Colors.black.withAlpha(120),
                  colorBlendMode: BlendMode.darken,
                  fit: BoxFit.cover))),
      Text(text,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold,shadows: [
                Shadow(color: Colors.black,blurRadius: 10)
          ]),)
    ]);
  }
}

class BannerAnime extends StatelessWidget {
  final AnimeBanner anime;
  final String? tag;
  final Size size;
  final ThemeData theme;
  final bool isPortrait;
  final void Function({required String id, String? tag, required String title})
      onTapElement;

  const BannerAnime(
      {super.key,
      required this.anime,
      required this.tag,
      required this.size,
      required this.theme,
      required this.isPortrait,
      required this.onTapElement});

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.orientationOf(context);
    final BorderRadius borderRadius = BorderRadius.circular(20);
    return GestureDetector(
        onTap: () => onTapElement(
            id: anime.idAnime(), tag: tag, title: anime.getTitle()),
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
                                heroTag: anime.getImage(),
                                child: ClipRRect(
                                    borderRadius: borderRadius,
                                    child: CachedNetworkImage(
                                        imageUrl: anime.getImage(),
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, progress) {
                                          return const LoadWidget();
                                        },
                                        filterQuality: FilterQuality.high)))),
                        if (!(anime.getRating() == '0'))
                          Positioned(
                              top: 15,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: borderRadius),
                                child: AutoSizeText(anime.getRating(),
                                    maxLines: 3,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: Colors.yellow)),
                              ))
                      ])),
                  TitleWidget(
                      title: anime.getTitle(),
                      maxLines: 3,
                      textStyle: theme.textTheme.titleSmall!,
                      tag: tag)
                ])));
  }
}

class BannerAnimeAndEpisodes extends StatelessWidget {
  final CompleteAnime completeAnime;
  final String? tag;
  final void Function({required String id, String? tag, required String title})
      onTapElement;

  const BannerAnimeAndEpisodes(
      {super.key,
      required this.completeAnime,
      required this.tag,
      required this.onTapElement});

  int calculateEpisodeView({required BuildContext context}) {
    return completeAnime.episodes
        .where((element) => context
            .read<AnimeBloc>()
            .state
            .listEpisodesView
            .contains(element.id))
        .length;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final Orientation orientation = MediaQuery.orientationOf(context);
    return GestureDetector(
        onTap: () => onTapElement(
            id: completeAnime.id, tag: tag, title: completeAnime.title),
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
                                heroTag: completeAnime.poster,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                        imageUrl: completeAnime.poster,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder:
                                            (context, url, progress) =>
                                                const LoadWidget(),
                                        filterQuality: FilterQuality.high)))),
                        Positioned(
                            top: 15,
                            left: 8,
                            child: HeroAnimationWidget(
                                tag: tag,
                                heroTag:
                                    completeAnime.rating + completeAnime.title,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(completeAnime.rating,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(color: Colors.yellow)),
                                )))
                      ])),
                  Wrap(children: [
                    TitleWidget(
                        title: 'Episodeos vistos: ',
                        maxLines: 1,
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.orange),
                        tag: null),
                    TitleWidget(
                        title:
                            '${calculateEpisodeView(context: context)} / ${completeAnime.episodes.length}',
                        maxLines: 1,
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.orangeAccent),
                        tag: null)
                  ]),
                  TitleWidget(
                      title: completeAnime.title,
                      maxLines: 3,
                      textStyle: Theme.of(context).textTheme.titleSmall!,
                      tag: tag),
                ])));
  }
}

class BannerAnimeReload extends StatelessWidget {
  const BannerAnimeReload({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final Orientation orientation = MediaQuery.orientationOf(context);
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
                title: ' ',
                maxLines: 3,
                textStyle: Theme.of(context).textTheme.titleSmall!,
                tag: null),
            const Text('Rating : ')
          ]),
    );
  }
}

class BannerAiringAnime extends StatelessWidget {
  final BasicAnime airingAnime;
  final Size size;
  final void Function({required String id, String? tag, required String title})
      onTap;

  const BannerAiringAnime(
      {super.key,
      required this.airingAnime,
      required this.size,
      required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => onTap(title: airingAnime.title, id: airingAnime.id),
      child: Card(
          color: Colors.grey.withOpacity(0.2),
          child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: size.height * 0.01),
              child: Row(spacing: 10, children: [
                Expanded(
                    child: AutoSizeText(airingAnime.title,
                        style: Theme.of(context).textTheme.labelLarge,
                        maxLines: 3)),
                AutoSizeText('(${airingAnime.type})',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: Colors.orange),
                    maxLines: 3),
                const Icon(Icons.arrow_right_outlined, size: 40)
              ]))));
}

class ListAiringAnime extends StatelessWidget {
  final List<BasicAnime> listAiringAnime;
  final void Function({required String id, String? tag, required String title})
      onTapElement;

  const ListAiringAnime(
      {super.key, required this.listAiringAnime, required this.onTapElement});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SliverPadding(
        padding: EdgeInsets.only(
            left: size.width * 0.05,
            right: size.width * 0.05,
            bottom: size.height * 0.1),
        sliver: listAiringAnime.isEmpty
            ? const Text('No se han podidio obtener sus datos')
            : SliverList.builder(
                itemBuilder: (context, index) => BannerAiringAnime(
                    size: size,
                    airingAnime: listAiringAnime[index],
                    onTap: onTapElement),
                itemCount: listAiringAnime.length));
  }
}

class DragCarousel extends StatefulWidget {
  final List<Anime> listAnime;
  final String? tag;
  final void Function(String id, String? tag) onTapElement;

  const DragCarousel(
      {super.key,
      required this.listAnime,
      required this.tag,
      required this.onTapElement});

  @override
  State<DragCarousel> createState() => _DragCarouselState();
}

class _DragCarouselState extends State<DragCarousel> {
  final ScrollController _scrollController = ScrollController();
  Offset? _dragStartOffset;
  double _initialScrollOffset = 0.0;
  double _lastDragDelta = 0.0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final ThemeData theme = Theme.of(context);
    final bool isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
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
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.listAnime.length,
            separatorBuilder: (context, index) {
              return Container(width: 50);
            },
            itemBuilder: (context, index) {
              return BannerAnime(
                size: size,
                isPortrait: isPortrait,
                theme: theme,
                anime: widget.listAnime[index],
                tag: widget.tag,
                onTapElement: ({required id, tag, required title}) {},
              );
            }));
  }
}
