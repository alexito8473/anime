import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../data/model/episode.dart';
import '../widgets/title/title_widget.dart';

class ServerScreen extends StatelessWidget {
  final Episode episode;
  final CompleteAnime anime;
  final int currentPage;
  final Function onTap;
  final InAppWebViewSettings inAppWebViewSettings;
  final Function onWebViewCreated;
  final Function onTapLeft;
  final Function onTapRight;
  final Function onTapSaveEpisode;
  final bool isSave;
  final Widget web;
  final Widget? button;

  const ServerScreen(
      {super.key,
      required this.episode,
      required this.currentPage,
      required this.onTap,
      required this.inAppWebViewSettings,
      required this.onWebViewCreated,
      required this.anime,
      required this.onTapLeft,
      required this.onTapRight,
      required this.onTapSaveEpisode,
      required this.isSave,
      required this.web,
      this.button});

  Widget navigatorButton(
      {required Size size,
      required bool isLeft,
      required Function onTap,
      required BuildContext context}) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    final iconSize = ResponsiveUtils.getIconSize(context);

    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        width: deviceType == DeviceType.desktop ? size.width * 0.08 : size.width * 0.1,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          border: Border.all(color: Colors.white.withAlpha(40)),
          borderRadius: !isLeft
              ? const BorderRadius.only(
                  topRight: Radius.circular(100),
                  bottomRight: Radius.circular(100))
              : const BorderRadius.only(
                  topLeft: Radius.circular(100),
                  bottomLeft: Radius.circular(100)),
        ),
        child: isLeft
            ? Icon(Icons.arrow_back_sharp, size: iconSize)
            : Icon(Icons.arrow_forward_sharp, size: iconSize),
      ),
    );
  }

  Widget navigationButton({required Size size, required BuildContext context}) {
    final deviceType = ResponsiveUtils.getDeviceType(context);
    final horizontalPadding = ResponsiveUtils.getPaddingHorizontal(context);

    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          if (episode.episode > 1)
            navigatorButton(
              size: size,
              isLeft: true,
              onTap: onTapLeft,
              context: context,
            ),
          GestureDetector(
            onTap: () => onTapSaveEpisode(isSave, episode),
            child: Container(
              width: deviceType == DeviceType.desktop ? 120 : 100,
              height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                border: Border.all(color: Colors.white.withAlpha(40)),
              ),
              child: Text(
                isSave ? 'Visto' : 'No visto',
                style: TextStyle(
                  fontSize: deviceType == DeviceType.desktop ? 16 : 14,
                ),
              ),
            ),
          ),
          if (anime.episodes.length > episode.episode)
            navigatorButton(
              size: size,
              isLeft: false,
              onTap: onTapRight,
              context: context,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final deviceType = ResponsiveUtils.getDeviceType(context);
    final isLandscape = ResponsiveUtils.isLandscape(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: deviceType == DeviceType.desktop ? 80 : 100,
        actions: [
          if (button != null) button!,
          IconButton(
            onPressed: () => onTapSaveEpisode(isSave, episode),
            isSelected: isSave,
            style: const ButtonStyle(elevation: WidgetStatePropertyAll(200)),
            selectedIcon: const Icon(CupertinoIcons.heart_fill, color: Colors.orange),
            icon: const Icon(CupertinoIcons.heart, color: Colors.white),
          ),
        ],
        title: TitleWidget(
          title: '${anime.title} - Episodio: ${episode.episode}',
          maxLines: 3,
          textStyle: Theme.of(context).textTheme.titleMedium!,
          tag: episode.id,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              child: BottomNavigationBar(
                iconSize: deviceType == DeviceType.desktop ? 28 : 24,
                currentIndex: currentPage,
                onTap: (value) {
                  onTap(value, episode);
                },
                showSelectedLabels: true,
                showUnselectedLabels: true,
                items: episode.servers
                    .map((server) => BottomNavigationBarItem(
                          icon: const Icon(Icons.add),
                          label: server.title,
                        ))
                    .toList(),
              ),
            ),
          ),
          SliverToBoxAdapter(child: web),
          SliverToBoxAdapter(
            child: navigationButton(size: size, context: context),
          ),
        ],
      ),
    );
  }
}
