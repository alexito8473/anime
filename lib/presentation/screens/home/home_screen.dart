import 'package:anime/data/enums/type_data.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/anime.dart';
import '../../../data/model/basic_anime.dart';
import '../../../data/model/last_episode.dart';
import '../../widgets/banner/banner_widget.dart';
import '../../widgets/title/title_widget.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey? targetKey;
  final void Function({required String id, String? tag, required String title})
      onTapElement;

  const HomeScreen({super.key, this.targetKey, required this.onTapElement});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      BlocSelector<AnimeBloc, AnimeState, List<LastEpisode>>(
          selector: (state) => state.lastEpisodes,
          builder: (context, state) => SliverMainImage(
              anime: state.first, key: targetKey, onTapElement: onTapElement)),
      if (context.watch<AnimeBloc>().state.lastEpisodes.isNotEmpty)
        BlocSelector<AnimeBloc, AnimeState, List<LastEpisode>>(
            selector: (state) => state.lastEpisodes,
            builder: (context, state) => ListBannerAnime(
                listAnime: state.sublist(1),
                tag: 'episodeos',
                title: 'Últimos episodeos agregados',
                typeAnime: TypeAnime.episode,
                colorTitle: Colors.orange,
                onTapElement: onTapElement)),
      BlocSelector<AnimeBloc, AnimeState, List<Anime>>(
          selector: (state) => state.lastAnimesAdd,
          builder: (context, state) => ListBannerAnime(
              listAnime: state,
              tag: 'agregados',
              title: 'Últimos animes agregados',
              typeAnime: TypeAnime.anime,
              colorTitle: Colors.blueAccent,
              onTapElement: onTapElement)),
      const SliverTitle(),
      BlocSelector<AnimeBloc, AnimeState, List<BasicAnime>>(
          selector: (state) => state.listAringAnime,
          builder: (context, state) => ListAiringAnime(
              listAiringAnime: state, onTapElement: onTapElement))
    ]);
  }
}
