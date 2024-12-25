import 'package:anime/data/last_episode.dart';
import 'package:anime/domain/cubit/anime_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:go_router/go_router.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<AnimeCubit, AnimeState>(builder: (context, state) {
      return SliverToBoxAdapter(
          child: SizedBox(
              height: size.height * 0.4,
              child: FlutterCarousel(
                  items: state.lastEpisodes.map((lastEpisode) {
                    return BannerCarrouselAnime(lastEpisode: lastEpisode);
                  }).toList(),
                  options: FlutterCarouselOptions(
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      viewportFraction: 1,
                      autoPlayCurve: Curves.bounceInOut,
                      allowImplicitScrolling: true,
                      height: size.height * 0.4,
                      showIndicator: true))));
    });
  }
}

class BannerCarrouselAnime extends StatelessWidget {
  final LastEpisode lastEpisode;
  const BannerCarrouselAnime({super.key, required this.lastEpisode});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () async{
        context.push('anime/');
        Navigator.pushNamed(context, 'anime/${lastEpisode.anime}');
      },
      child: Stack(children: [
        Positioned.fill(
            child: Image.network(
                color: Colors.black54,
                colorBlendMode: BlendMode.darken,
                lastEpisode.imagePreview,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                })),
        Positioned(
            bottom: size.height * 0.05,
            left: size.width * 0.05,
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                  width: size.width * 0.95,
                  child: Text(lastEpisode.anime,
                      style: Theme.of(context).textTheme.titleLarge,
                      softWrap: true)),
              Text("Episode : ${lastEpisode.episode}",
                  style: Theme.of(context).textTheme.titleMedium)
            ]))
      ]),
    ) ;
  }
}
