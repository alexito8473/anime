import 'package:anime/data/enums/type_version_anime.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/list_type_anime_page.dart';
import '../widgets/banner/banner_widget.dart';

class ListTypeScreen extends StatelessWidget {
  final GlobalKey? targetKey;
  final TypeVersionAnime type;
  final ScrollController scrollController;

  const ListTypeScreen(
      {super.key,
      this.targetKey,
      required this.scrollController,
      required this.type});

  final String tag = "typeScreen";

  @override
  Widget build(BuildContext context) {
    ListTypeAnimePage listTypeAnimePage =
        context.watch<AnimeBloc>().state.mapPageAnimes[type]!;
    Size size = MediaQuery.sizeOf(context);

    return CustomScrollView(controller: scrollController, slivers: [
      SliverAppBar(
          key: targetKey,
          centerTitle: true,
          collapsedHeight: size.height * 0.1,
          expandedHeight: size.height * 0.2,
          toolbarHeight: size.height * 0.1,
          flexibleSpace: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black12, Colors.black]).createShader(bounds),
              blendMode: BlendMode.darken,
              child: Image.asset(type.getImage(),
                  filterQuality: FilterQuality.none, fit: BoxFit.cover)),
          title: Text(listTypeAnimePage.typeVersionAnime.getTitle(),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 30))),
      SliverPadding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05, vertical: size.height * 0.05),
          sliver: SliverGrid.builder(
              addRepaintBoundaries: true,
              itemCount: listTypeAnimePage.listAnime.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisExtent: 300,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  maxCrossAxisExtent: 150),
              itemBuilder: (context, index) => BannerAnime(
                  anime: listTypeAnimePage.listAnime[index], tag: tag)))
    ]);
  }
}
