import 'package:anime/utils/responsive_utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../data/model/anime.dart';
import '../widgets/banner/banner_widget.dart';
import '../widgets/sliver/sliver_widget.dart';

class ExploreScreen extends StatelessWidget {
  final TextEditingController controller;
  final Function onSubmit;
  final List<Anime> listAnime;
  final void Function({required String id, String? tag, required String title}) onTapElement;
  const ExploreScreen(
      {super.key,
      required this.controller,
      required this.onSubmit,
      required this.listAnime, required this.onTapElement});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final ThemeData theme = Theme.of(context);
    final bool isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    final DeviceType deviceType = ResponsiveUtils.getDeviceType(context);

    double maxCrossAxisExtent;
    double mainAxisExtent;
    double crossAxisSpacing;

    if (deviceType == DeviceType.desktop) {
      maxCrossAxisExtent = 180;
      mainAxisExtent = 320;
      crossAxisSpacing = 20;
    } else if (deviceType == DeviceType.tablet) {
      maxCrossAxisExtent = 160;
      mainAxisExtent = 300;
      crossAxisSpacing = 15;
    } else {
      maxCrossAxisExtent = 150;
      mainAxisExtent = 280;
      crossAxisSpacing = 10;
    }

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: Colors.grey.shade900,
          title: const AutoSizeText('Buscador de anime'),
        ),
        SliverPadding(
          padding: EdgeInsets.only(top: size.height * 0.01),
          sliver: SliverAppBarSearch(
            isFlexibleSpaceBar: false,
            snapFloatingPinned: false,
            controller: controller,
            onSubmit: () => onSubmit(),
          ),
        ),
        if (listAnime.isEmpty)
          SliverToBoxAdapter(
            child: SizedBox(
              height: size.height * 0.8,
              child: const Center(
                child: Text('No se encontraron resultados'),
              ),
            ),
          ),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getPaddingHorizontal(context),
            vertical: size.height * 0.02,
          ),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              childCount: listAnime.length,
              (context, index) {
                return BannerAnime(
                  size: size,
                  theme: theme,
                  isPortrait: isPortrait,
                  anime: listAnime[index],
                  tag: 'animeSearch',
                  onTapElement: onTapElement,
                );
              },
            ),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              crossAxisSpacing: crossAxisSpacing,
              maxCrossAxisExtent: maxCrossAxisExtent,
              mainAxisExtent: mainAxisExtent,
            ),
          ),
        ),
      ]),
    );
  }
}
