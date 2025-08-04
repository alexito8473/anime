import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/enums/type_my_animes.dart';
import '../../../data/model/complete_anime.dart';
import '../../../domain/bloc/anime/anime_bloc.dart';
import '../../widgets/banner/banner_widget.dart';
import 'package:lottie/lottie.dart';

class SaveScreen extends StatelessWidget {
  final void Function({required String id, String? tag, required String title})
      onTapElement;
  final List<TypeMyAnimes> animeTypes;
  final TabController tabController;

  const SaveScreen(
      {super.key,
      required this.onTapElement,
      required this.animeTypes,
      required this.tabController});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return DefaultTabController(
        length: tabController.length,
        initialIndex: tabController.index,
        child: Column(children: [
          TabBar(
              controller: tabController,
              indicatorAnimation: TabIndicatorAnimation.linear,
              physics: const ClampingScrollPhysics(),
              isScrollable: true,
              indicatorColor: Colors.orangeAccent,
              tabAlignment: TabAlignment.start,
              labelColor: Colors.yellowAccent,
              dividerColor: Colors.orangeAccent.withAlpha(100),
              tabs: animeTypes
                  .map((e) => Tab(icon: Icon(e.getIcon()), text: e.name))
                  .toList()),
          BlocSelector<AnimeBloc, AnimeState,
              Map<TypeMyAnimes, List<CompleteAnime>>>(
            selector: (state) => state.mapAnimesLoad,
            builder: (context, state) {
              return Expanded(
                  child: TabBarView(
                      controller: tabController,
                      children: animeTypes.map((e) {
                        final animeList = state[e] ?? [];
                        if(animeList.isEmpty){
                          return Padding(padding: EdgeInsets.symmetric(
                            horizontal: size.width*0.1,
                            vertical: size.height*0.1
                          ),
                          child: Column(
                            children: [
                              Text('No tienes animes guardados en ${e.name}',

                              style: Theme.of(context).textTheme.labelLarge),
                              Lottie.asset('assets/lottie/animeLoading.json',
                                  height: size.height*0.3),

                            ],
                          ));
                        }
                        return GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                              vertical: size.height * 0.02,
                            ),
                            itemCount: animeList.length,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 220,
                                    crossAxisSpacing: 30,
                                    mainAxisExtent: 280),
                            itemBuilder: (context, index) {
                              return BannerAnimeAndEpisodes(
                                  completeAnime: animeList[index],
                                  tag: 'animeSearch',
                                  onTapElement: onTapElement);
                            });
                      }).toList()));
            },
          )
        ]));
  }
}
