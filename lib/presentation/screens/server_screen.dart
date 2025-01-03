import 'package:anime/data/model/complete_anime.dart';
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
  const ServerScreen(
      {super.key,
      required this.episode,
      required this.currentPage,
      required this.onTap,
      required this.inAppWebViewSettings,
      required this.onWebViewCreated,
      required this.anime,
      required this.onTapLeft,
      required this.onTapRight});
  Widget navigatorButton(
      {required Size size, required bool isLeft, required Function onTap, required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: size.width * 0.1,
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
            ? const Icon(Icons.arrow_back_sharp)
            : const Icon(Icons.arrow_forward_sharp),
      ),
    );
  }

  Widget navigationButton({required Size size, required BuildContext context}) {
    return Padding(
        padding: EdgeInsets.only(left: size.width * 0.05),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10,
            children: [
              if (episode.episode > 1)
                navigatorButton(size: size, isLeft: true, onTap: onTapLeft, context: context),
              if (anime.episodes.length - 1 > episode.episode)
                navigatorButton(size: size, isLeft: false, onTap: onTapRight, context: context)
            ]));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        appBar: AppBar(
            title: TitleWidget(
                title: episode.id.replaceAll("-", " "),
                maxLines: 3,
                textStyle: Theme.of(context).textTheme.titleLarge!,
                tag: episode.id)),
        body: SingleChildScrollView(
            child: SizedBox(
                width: size.width,
                height: size.height * .8,
                child: Column(children: [
                  SafeArea(
                      child: BottomNavigationBar(
                          iconSize: 0,
                          currentIndex: currentPage,
                          onTap: (value) {
                            onTap(value, episode);
                          },
                          showSelectedLabels: true,
                          showUnselectedLabels: true,
                          items: (episode.servers
                              .map((server) => BottomNavigationBarItem(
                                  icon: const Icon(Icons.add),
                                  label: server.title))
                              .toList()))),
                  Expanded(
                      child: episode.servers[currentPage].code == null
                          ? const CircularProgressIndicator()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.05,
                                  vertical: size.height * 0.05),
                              child: InAppWebView(
                                  initialSettings: inAppWebViewSettings,
                                  shouldOverrideUrlLoading:
                                      (controller, navigationAction) async {
                                    if (navigationAction.request.url
                                        .toString()
                                        .contains("hlsflast.com")) {
                                      return NavigationActionPolicy.ALLOW;
                                    }
                                    if (episode.servers[currentPage].code!
                                        .contains(navigationAction.request.url
                                            .toString())) {
                                      return NavigationActionPolicy
                                          .ALLOW; // Bloquea la carga del enlace
                                    }
                                    return NavigationActionPolicy.CANCEL;
                                  },
                                  onWebViewCreated: (controller) =>
                                      onWebViewCreated(controller),
                                  initialUrlRequest: URLRequest(
                                      url: WebUri(episode
                                          .servers[currentPage].code!))))),
                  navigationButton(size: size, context: context)
                ]))));
  }
}
