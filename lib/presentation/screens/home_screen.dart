import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/banner/banner_widget.dart';
import '../widgets/title/title_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () {
          context.read<AnimeBloc>().add(ObtainData(context: context));
          return Future.value();
        },
        child: const CustomScrollView(
            slivers: [
              BannerWidget(),
              ListBannerAnimeAddWidget(),
              ListAnimeSaveWidget(),
              SliverTitle(),
              ListAiringAnime()
            ]));
  }
}
