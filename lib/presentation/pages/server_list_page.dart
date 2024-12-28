import 'package:anime/data/episode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../widgets/title/title_widget.dart';

class ServerListPage extends StatefulWidget {
  final Episode episode;
  const ServerListPage({super.key, required this.episode});

  @override
  State<ServerListPage> createState() => _ServerListPageState();
}

class _ServerListPageState extends State<ServerListPage> {
  int _currentPage = 0;
  InAppWebViewController? webViewController;
  final InAppWebViewSettings inAppWebViewSettings = InAppWebViewSettings(
      useHybridComposition: true,
      allowsInlineMediaPlayback: true, // Permite reproducción en línea.
      mixedContentMode: MixedContentMode
          .MIXED_CONTENT_ALWAYS_ALLOW, // Permite contenido mixto (HTTP y HTTPS).
      disableDefaultErrorPage: true);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        appBar: AppBar(
            title: TitleWidget(
                title: widget.episode.id
                    .replaceAll("-", " ")
                    .substring(0, widget.episode.id.length - 1),
                maxLines: 2,
                textStyle: Theme.of(context).textTheme.titleLarge!,
                tag: widget.episode.id)),
        body: SingleChildScrollView(
            child: SizedBox(
                width: size.width,
                height: size.height * .8,
                child: Column(children: [
                  SafeArea(
                      child: BottomNavigationBar(
                          iconSize: 0,
                          currentIndex: _currentPage,
                          onTap: (value) {
                            setState(() => _currentPage = value);
                            setState(() async =>
                                await webViewController?.loadUrl(
                                    urlRequest: URLRequest(
                                        allowsExpensiveNetworkAccess: false,
                                        url: WebUri(widget.episode
                                            .servers[_currentPage].code!))));
                          },
                          showSelectedLabels: true,
                          showUnselectedLabels: true,
                          items: (widget.episode.servers
                              .map((server) => BottomNavigationBarItem(
                                  icon: const Icon(Icons.add),
                                  label: server.title))
                              .toList()))),
                  Expanded(
                      child: widget.episode.servers[_currentPage].code == null
                          ? const CircularProgressIndicator()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.05,
                                  vertical: size.height * 0.05),
                              child: InAppWebView(
                                  initialSettings: inAppWebViewSettings,
                                  shouldOverrideUrlLoading:
                                      (controller, navigationAction) async {
                                    if (widget
                                        .episode.servers[_currentPage].code!
                                        .contains(navigationAction.request.url
                                            .toString())) {
                                      return NavigationActionPolicy
                                          .ALLOW; // Bloquea la carga del enlace
                                    }
                                    return NavigationActionPolicy.CANCEL;
                                  },
                                  onWebViewCreated: (controller) =>
                                      webViewController = controller,
                                  initialUrlRequest: URLRequest(
                                      url: WebUri(widget.episode
                                          .servers[_currentPage].code!))))),
                ]))));
  }
}
