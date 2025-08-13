import 'package:anime/data/enums/type_version_anime.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/list_type_anime_page.dart';
import '../widgets/banner/banner_widget.dart';

class ListTypeScreen extends StatelessWidget {
  final GlobalKey? targetKey;
  final TypeVersionAnime type;
  final ScrollController scrollController;
  final void Function({required String id, String? tag, required String title})
      onTapElement;

  const ListTypeScreen(
      {super.key,
      this.targetKey,
      required this.scrollController,
      required this.type,
      required this.onTapElement});

  final String tag = 'typeScreen';

  @override
  Widget build(BuildContext context) {
    final ListTypeAnimePage listTypeAnimePage =
        context.watch<AnimeBloc>().state.mapPageAnimes[type]!;
    final Size size = MediaQuery.sizeOf(context);
    final ThemeData theme = Theme.of(context);
    final bool isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    return CustomScrollView(controller: scrollController, slivers: [
      SliverToBoxAdapter(key: targetKey),
      SliverAppBar.large(
          centerTitle: true,
          expandedHeight: size.height * 0.15,
          flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              stretchModes: StretchMode.values,
              background: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black])
                      .createShader(bounds),
                  blendMode: BlendMode.darken,
                  child: Image.asset(type.getImage(),
                      filterQuality: FilterQuality.none, fit: BoxFit.cover)),
              title: Text(listTypeAnimePage.typeVersionAnime.getTitle(),
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 20)))),
      SliverPadding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.height * 0.05),
          sliver: SliverGrid.builder(
              addRepaintBoundaries: true,
              itemCount: listTypeAnimePage.listAnime.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisExtent: 250,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  maxCrossAxisExtent: 130),
              itemBuilder: (context, index) => BannerAnime(
                  size: size,
                  theme: theme,
                  isPortrait: isPortrait,
                  anime: listTypeAnimePage.listAnime[index],
                  tag: tag,
                  onTapElement: onTapElement)))
    ]);
  }
}
