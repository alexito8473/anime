import 'package:anime/data/enums/type_version_anime.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/anime.dart';
import '../../data/model/list_type_anime_page.dart';
import '../widgets/banner/banner_widget.dart';

class ListTypeScreen extends StatelessWidget {
  final GlobalKey? targetKey;
  final TypeVersionAnime type;
  final ScrollController scrollController;
  final void Function({required String id, String? tag, required String title})
  onTapElement;

  const ListTypeScreen({super.key,
    this.targetKey,
    required this.scrollController,
    required this.type,
    required this.onTapElement});

  final String tag = 'typeScreen';

  @override
  Widget build(BuildContext context) {
    final ListTypeAnimePage listTypeAnimePage =
    context
        .watch<AnimeBloc>()
        .state
        .mapPageAnimes[type]!;

    return CustomScrollView(controller: scrollController, slivers: [
      SliverToBoxAdapter(key: targetKey),
      SliverAppBarListTypeAnimeWidget(
          asset: type.getImage(),
          text: listTypeAnimePage.typeVersionAnime.getTitle()),
      SliverGridTypeAnimeWidget(
          listAnime: listTypeAnimePage.listAnime,
          onTapElement: onTapElement,
          tag: tag)
    ]);
  }
}

class SliverGridTypeAnimeWidget extends StatelessWidget {
  final List<Anime> listAnime;
  final String tag;
  final void Function({required String id, String? tag, required String title})
  onTapElement;

  const SliverGridTypeAnimeWidget({super.key,
    required this.listAnime,
    required this.tag,
    required this.onTapElement});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final ThemeData theme = Theme.of(context);
    final bool isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return SliverPadding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.05),
        sliver: SliverGrid.builder(
            addRepaintBoundaries: true,
            itemCount: listAnime.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisExtent: 250,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                maxCrossAxisExtent: 130),
            itemBuilder: (context, index) {
              return BannerAnime(
                  size: size,
                  theme: theme,
                  isPortrait: isPortrait,
                  anime: listAnime[index],
                  tag: tag,
                  onTapElement: onTapElement);
            }));
  }
}

class SliverAppBarListTypeAnimeWidget extends StatelessWidget {
  final String asset;
  final String text;

  const SliverAppBarListTypeAnimeWidget(
      {super.key, required this.asset, required this.text});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final ThemeData theme = Theme.of(context);
    return SliverAppBar.large(
        centerTitle: true,
        expandedHeight: size.height * 0.15,
        flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            stretchModes: StretchMode.values,
            background: ShaderMask(
                shaderCallback: (bounds) =>
                    const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black])
                        .createShader(bounds),
                blendMode: BlendMode.darken,
                child: Image.asset(asset,
                    filterQuality: FilterQuality.none, fit: BoxFit.cover)),
            title: Text(text,
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 20))));
  }
}
