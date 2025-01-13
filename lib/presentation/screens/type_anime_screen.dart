import 'package:anime/presentation/widgets/sliver/sliver_widget.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import '../../data/model/list_type_anime_page.dart';
import '../widgets/banner/banner_widget.dart';

class ListTypeScreen extends StatelessWidget {
  final GlobalKey? targetKey;
  final ListTypeAnimePage pageAnime;

  const ListTypeScreen({super.key, required this.pageAnime, this.targetKey});

  final String tag = "typeScreen";

  Future<void> task() {
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return CustomMaterialIndicator.adaptive(
        onRefresh: task, // Your refresh logic
        backgroundColor: Colors.white,
        autoRebuild: true,
        notificationPredicate: (notification) {
          final metrics = notification.metrics;
          if (metrics.pixels >= metrics.maxScrollExtent) {
            print("ahora ahora");
            //  _loadMoreAnimes();
          }
          return false;
        },
        leadingScrollIndicatorVisible: false,
        trailingScrollIndicatorVisible: false,
        child: CustomScrollView(slivers: [
          SliverAppBar(
              key: targetKey,
              backgroundColor: Colors.grey.shade900,
              centerTitle: true,
              collapsedHeight: size.height * 0.1,
              expandedHeight: size.height * 0.15,
              toolbarHeight: size.height * 0.1,
              flexibleSpace: ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black])
                        .createShader(bounds);
                  },
                  blendMode: BlendMode.darken,
                  child: Image.asset(pageAnime.typeVersionAnime.getImage(),
                      fit: BoxFit.cover)),
              title: Text(pageAnime.typeVersionAnime.getTitle(),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 30))),
          SliverAppBarSearch(
              controller: TextEditingController(), canIcon: false),
          SliverPadding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: size.height * 0.05),
              sliver: SliverGrid.builder(
                  addRepaintBoundaries: true,
                  itemCount: pageAnime.listAnime.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisExtent: 300,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      maxCrossAxisExtent: 150),
                  itemBuilder: (context, index) =>
                      BannerAnime(anime: pageAnime.listAnime[index], tag: tag)))
        ]));
  }
}
