import 'package:anime/data/enums/type_data.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/banner/banner_widget.dart';
import '../widgets/title/title_widget.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey? targetKey;

  const HomeScreen({super.key, this.targetKey});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    Orientation orientation = MediaQuery.orientationOf(context);
    return BlocBuilder<AnimeBloc, AnimeState>(
      builder: (context, state) {
        return RefreshIndicator(
            onRefresh: () {
              context.read<AnimeBloc>().add(ObtainData(context: context));
              return Future.value();
            },
            child: CustomScrollView(slivers: [
              BannerWidget(
                  key: targetKey,
                  lastEpisodes: state.lastEpisodes,
                  size: size,
                  orientation: orientation),
              ListBannerAnime(
                  listAnime: state.lastAnimesAdd,
                  size: size,
                  tag: 'agregados',
                  title: 'Últimos animes agregados',
                  typeAnime: TypeAnime.ADD,
                  colorTitle: Colors.blueAccent),
              const SliverTitle(),
              ListAiringAnime(
                  listAringAnime: state.listAringAnime,
                  size: size)
            ]));
      },
    );
  }
}
