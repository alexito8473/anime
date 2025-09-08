import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/data/model/episode.dart';
import 'package:anime/domain/bloc/configuration/configuration_bloc.dart';
import 'package:anime/presentation/widgets/banner/banner_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/enums/type_my_animes.dart';
import '../../data/enums/types_vision.dart';
import '../widgets/animation/hero_animation_widget.dart';
import '../widgets/banner/episode_widget.dart';
import '../widgets/detail/deatil_widget.dart';
import '../widgets/title/title_widget.dart';

class DetailAnimeScreen extends StatelessWidget {
  final CompleteAnime anime;
  final Function onTap;
  final int currentPage;
  final List<Episode> allEpisode;
  final TextEditingController textController;
  final String? tag;
  final String textFiltered;
  final Function onTapSaveEpisode;
  final TypesVision typesVision;
  final bool isSave;
  final TypeMyAnimes miAnime;
  final Future<void> Function({required CompleteAnime anime}) openDialog;
  final void Function({required TypesVision? type}) changeTypeVision;
  final void Function() shareAnime;
  final void Function({required String id, String? tag, required String title})
      navigation;
  final List<Episode> Function(
      {required List<Episode> list,
      required String text,
      required bool isConfig}) filteredList;

  const DetailAnimeScreen(
      {super.key,
      required this.anime,
      required this.onTap,
      required this.currentPage,
      required this.allEpisode,
      required this.textController,
      required this.tag,
      required this.onTapSaveEpisode,
      required this.filteredList,
      required this.textFiltered,
      required this.navigation,
      required this.typesVision,
      required this.changeTypeVision,
      required this.isSave,
      required this.openDialog,
      required this.miAnime,
      required this.shareAnime});

  int countTabBar() {
    int count = 1;
    if (anime.synopsis.isNotEmpty) {
      count++;
    }
    if (anime.listAnimeRelated.isNotEmpty) {
      count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final ThemeData theme = Theme.of(context);
    final bool isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final double padding08 = size.width * 0.08;
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
              AppBarDetailAnime(
                  anime: anime,
                  tag: tag,
                  safeAnime: Row(children: [
                    if (isSave)
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(miAnime.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold))),
                    IconButton(
                        onPressed: () => openDialog(anime: anime),
                        isSelected: isSave,
                        style: const ButtonStyle(
                            elevation: WidgetStatePropertyAll(200)),
                        selectedIcon:
                            const Icon(Icons.autorenew, color: Colors.orange),
                        icon: const Icon(CupertinoIcons.heart,
                            color: Colors.white)),
                    IconButton(
                        onPressed: shareAnime, icon: const Icon(Icons.share))
                  ])),
              SliverToBoxAdapter(
                  child: Material(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.only(right: padding08, left: padding08),
                    padding: EdgeInsets.only(right: padding08, left: padding08),
                    child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runAlignment: WrapAlignment.center,
                        alignment: WrapAlignment.spaceBetween,
                        direction: Axis.horizontal,
                        spacing: 10,
                        children: [
                          SubTilesAnime(
                              title: 'Estado',
                              subtitle: anime.debut,
                              size: size),
                          SubTilesAnime(
                              title: 'Tipo', subtitle: anime.type, size: size),
                          HeroAnimationWidget(
                              tag: tag,
                              heroTag: anime.rating + anime.title,
                              child: SubTilesAnime(
                                  title: 'Valoración',
                                  subtitle: anime.rating,
                                  size: size)),
                          if (anime.genres.isNotEmpty)
                            SubTilesAnime(
                                title: 'Géneros',
                                subtitle: anime.genres.join(', ').toUpperCase(),
                                size: size)
                        ])),
              ))
            ],
        body: Material(
          child: SafeArea(
              minimum: EdgeInsets.only(top: size.height * 0.1),
              child: DefaultTabController(
                  length: countTabBar(),
                  initialIndex: currentPage,
                  child: Column(children: [
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: TabBar(
                            onTap: (value) => onTap(value),
                            dividerColor: Colors.transparent,
                            labelColor: Colors.white,
                            // Color del texto seleccionado
                            unselectedLabelColor: Colors.grey.withAlpha(80),
                            // Color del texto no seleccionado
                            tabs: [
                              Tab(
                                  icon: const Icon(Icons.tv),
                                  text: 'Episodios (${anime.episodes.length})'),
                              if (anime.synopsis.isNotEmpty)
                                const Tab(
                                    icon: Icon(Icons.description_sharp),
                                    text: 'Synopsis'),
                              if (anime.listAnimeRelated.isNotEmpty)
                                const Tab(
                                    icon: Icon(Icons.movie),
                                    text: 'Relacionados')
                            ])),
                    Expanded(
                        child: TabBarView(children: [
                      BlocSelector<ConfigurationBloc, ConfigurationState, bool>(
                        selector: (state) => state.isUpwardList,
                        builder: (context, state) {
                          return ListEpisodesWidget(
                              anime: anime,
                              episodes: filteredList(
                                  text: textFiltered,
                                  isConfig: state,
                                  list: allEpisode),
                              textController: textController,
                              action: Row(children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 5),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade900,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: IconButton(
                                    onPressed: () => context
                                        .read<ConfigurationBloc>()
                                        .add(ChangeOrderList()),
                                    color: Colors.white,
                                    isSelected: context
                                        .read<ConfigurationBloc>()
                                        .state
                                        .isUpwardList,
                                    icon: const Icon(Icons.arrow_downward),
                                    selectedIcon:
                                        const Icon(Icons.arrow_upward),
                                  ),
                                ),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade900,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: DropdownButton<TypesVision>(
                                        value: typesVision,
                                        underline: const SizedBox(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                        borderRadius: BorderRadius.circular(15),
                                        dropdownColor: Colors.grey.shade900,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.orange),
                                        items: TypesVision.values
                                            .map((vision) => DropdownMenuItem(
                                                value: vision,
                                                child: Text(vision.content,
                                                    style: const TextStyle(
                                                        color: Colors.white))))
                                            .toList(),
                                        onChanged: (value) =>
                                            changeTypeVision(type: value)))
                              ]),
                              onTapSaveEpisode: onTapSaveEpisode);
                        },
                      ),
                      if (anime.synopsis.isNotEmpty)
                        SynopsysWidget(title: anime.synopsis),
                      if (anime.listAnimeRelated.isNotEmpty)
                        CustomScrollView(slivers: [
                          SliverPadding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: padding08),
                              sliver: SliverGrid.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 220,
                                          crossAxisSpacing: 30,
                                          mainAxisExtent: 280,
                                          mainAxisSpacing: 30),
                                  itemCount: anime.listAnimeRelated.length,
                                  itemBuilder: (context, index) => BannerAnime(
                                      size: size,
                                      theme: theme,
                                      isPortrait: isPortrait,
                                      anime: anime.listAnimeRelated[index],
                                      tag: 'animeSearch',
                                      onTapElement: navigation)))
                        ])
                    ]))
                  ]))),
        ));
  }
}
