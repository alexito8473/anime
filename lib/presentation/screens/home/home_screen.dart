import 'package:anime/data/enums/type_data.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/banner/banner_widget.dart';
import '../../widgets/title/title_widget.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey? targetKey;
  final void Function({required String id, String? tag, required String title})
      onTapElement;

  const HomeScreen({super.key, this.targetKey, required this.onTapElement});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final Orientation orientation = MediaQuery.orientationOf(context);
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
                  orientation: orientation,
                  onTapElement: onTapElement),
              ListBannerAnime(
                  listAnime: state.lastAnimesAdd,
                  size: size,
                  tag: 'agregados',
                  title: 'Últimos animes agregados',
                  typeAnime: TypeAnime.add,
                  colorTitle: Colors.blueAccent,
                  onTapElement:onTapElement),
              const SliverTitle(),
              ListAiringAnime(
                  listAringAnime: state.listAringAnime,
                  size: size,
                  onTapElement: onTapElement),
            ]));
      },
    );
  }
}
