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
        headerSliverBuilder: (context, innerBoxIsScrolled) => isPortrait
            ? HeaderDetailAnimePortraitWidget.build(
                anime: anime,
                isSave: isSave,
                changeTypeVision: changeTypeVision,
                shareAnime: shareAnime,
                openDialog: openDialog,
                miAnime: miAnime,
                tag: tag,
              )
            : HeaderDetailAnimeLandscapeWidget.build(
                anime: anime,
                isSave: isSave,
                changeTypeVision: changeTypeVision,
                shareAnime: shareAnime,
                openDialog: openDialog,
                miAnime: miAnime,
                tag: tag,
              ),
        body: Material(
          child: SafeArea(
              child: DefaultTabController(
                  length: countTabBar(),
                  initialIndex: currentPage,
                  child: Column(children: [
                    TabBar(
                            onTap: (value) => onTap(value),
                            dividerColor: Colors.transparent,
                            labelColor: Colors.white,
    
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
                            ]),
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
