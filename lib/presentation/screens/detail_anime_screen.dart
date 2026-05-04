import 'package:anime/data/model/complete_anime.dart';
import 'package:anime/data/model/episode.dart';
import 'package:anime/domain/bloc/configuration/configuration_bloc.dart';
import 'package:anime/presentation/widgets/banner/banner_widget.dart';
import 'package:anime/utils/responsive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/enums/type_my_animes.dart';
import '../../data/enums/types_vision.dart';
import '../widgets/banner/episode_widget.dart';
import '../widgets/detail/detail_widget.dart';

class DetailAnimeScreen extends StatefulWidget {
  final CompleteAnime anime;
  final Function onTap;
  final int currentPage;
  final List<Episode> allEpisode;
  final TextEditingController textController;
  final String? tag;
  final String textFiltered;
  final Function onTapSaveEpisode;
  final TypesVision typesVision;
  final bool isSave;
  final TypeMyAnimes miAnime;
  final Future<void> Function({required CompleteAnime anime}) openDialog;
  final void Function({required TypesVision? type}) changeTypeVision;
  final void Function() shareAnime;
  final void Function({required String id, String? tag, required String title})
      navigation;
  final List<Episode> Function(
      {required List<Episode> list,
      required String text,
      required bool isConfig}) filteredList;

  const DetailAnimeScreen({
    super.key,
    required this.anime,
    required this.onTap,
    required this.currentPage,
    required this.allEpisode,
    required this.textController,
    required this.tag,
    required this.onTapSaveEpisode,
    required this.filteredList,
    required this.textFiltered,
    required this.navigation,
    required this.typesVision,
    required this.changeTypeVision,
    required this.isSave,
    required this.openDialog,
    required this.miAnime,
    required this.shareAnime,
  });

  @override
  State<DetailAnimeScreen> createState() => _DetailAnimeScreenState();
}

class _DetailAnimeScreenState extends State<DetailAnimeScreen>
    with TickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: _countTabs,
      initialIndex: widget.currentPage,
      vsync: this,
    );
  }

  int get _countTabs {
    int count = 1;
    if (widget.anime.synopsis.isNotEmpty) count++;
    if (widget.anime.listAnimeRelated.isNotEmpty) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    final deviceType = ResponsiveUtils.getDeviceType(context);
    final padding08 = ResponsiveUtils.getPaddingHorizontal(context);

    final useLandscapeLayout = deviceType == DeviceType.desktop || !isPortrait;

    final baseHeader = useLandscapeLayout
        ? HeaderDetailAnimeLandscapeWidget.build(
            anime: widget.anime,
            isSave: widget.isSave,
            changeTypeVision: widget.changeTypeVision,
            shareAnime: widget.shareAnime,
            openDialog: widget.openDialog,
            miAnime: widget.miAnime,
            tag: widget.tag,
          )
        : HeaderDetailAnimePortraitWidget.build(
            anime: widget.anime,
            isSave: widget.isSave,
            changeTypeVision: widget.changeTypeVision,
            shareAnime: widget.shareAnime,
            openDialog: widget.openDialog,
            miAnime: widget.miAnime,
            tag: widget.tag,
          );

    final headerSlivers = [
      ...baseHeader,
      SliverPersistentHeader(
        pinned: true,
        delegate: _TabBarDelegate(
          tabController: tabController,
          tabs: _buildTabs(context),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration:const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.68,1],
            colors: [

              Colors.black,

              Color(0xFF0A0E17),

            ],
          ),
        ),
        child: DefaultTabController(
          length: _countTabs,
          initialIndex: widget.currentPage,
          child: NestedScrollView(
            headerSliverBuilder: (_, __) => headerSlivers,
            body: TabBarView(
              controller: tabController,
              children: [
                _EpisodesTab(
                  anime: widget.anime,
                  allEpisode: widget.allEpisode,
                  textFiltered: widget.textFiltered,
                  textController: widget.textController,
                  filteredList: widget.filteredList,
                  typesVision: widget.typesVision,
                  changeTypeVision: widget.changeTypeVision,
                  onTapSaveEpisode: widget.onTapSaveEpisode,
                ),
                if (widget.anime.synopsis.isNotEmpty)
                  SingleChildScrollView(
                    child: SynopsysWidget(title: widget.anime.synopsis),
                  ),
                if (widget.anime.listAnimeRelated.isNotEmpty)
                  _RelatedTab(
                    anime: widget.anime,
                    padding08: padding08,
                    navigation: widget.navigation,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTabs(BuildContext context) {
    return [
      const Tab(icon: Icon(Icons.tv), text: 'Episodios'),
      if (widget.anime.synopsis.isNotEmpty)
        const Tab(icon: Icon(Icons.description_sharp), text: 'Synopsis'),
      if (widget.anime.listAnimeRelated.isNotEmpty)
        const Tab(icon: Icon(Icons.movie), text: 'Relacionados'),
    ];
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final List<Widget> tabs;

  const _TabBarDelegate({
    required this.tabController,
    required this.tabs,
  });

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.only(bottom: 0),
      child: TabBar(
        controller: tabController,
        isScrollable: MediaQuery.sizeOf(context).width < 600,
        dividerColor: Colors.transparent,
        labelColor: const Color(0xFF7C4DFF),
        overlayColor: const WidgetStatePropertyAll( Color(0xFF7C4DFF)),
        unselectedLabelColor: const Color(0xFF64748B),
        indicatorColor: const Color(0xFF7C4DFF),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: tabs,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return tabController != oldDelegate.tabController;
  }
}

class _EpisodesTab extends StatefulWidget {
  final CompleteAnime anime;
  final List<Episode> allEpisode;
  final String textFiltered;
  final TextEditingController textController;
  final List<Episode> Function(
      {required List<Episode> list,
      required String text,
      required bool isConfig}) filteredList;
  final TypesVision typesVision;
  final void Function({required TypesVision? type}) changeTypeVision;
  final Function onTapSaveEpisode;

  const _EpisodesTab({
    required this.anime,
    required this.allEpisode,
    required this.textFiltered,
    required this.textController,
    required this.filteredList,
    required this.typesVision,
    required this.changeTypeVision,
    required this.onTapSaveEpisode,
  });

  @override
  State<_EpisodesTab> createState() => _EpisodesTabState();
}

class _EpisodesTabState extends State<_EpisodesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocSelector<ConfigurationBloc, ConfigurationState, bool>(
      selector: (state) => state.isUpwardList,
      builder: (context, isUpward) {
        final filteredEpisodes = widget.filteredList(
          text: widget.textFiltered,
          isConfig: isUpward,
          list: widget.allEpisode,
        );

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _SearchBarField(
                  controller: widget.textController,
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _ToolbarDelegate(
                child: _ToolbarEpisodes(
                  isUpward: isUpward,
                  typesVision: widget.typesVision,
                  changeTypeVision: widget.changeTypeVision,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              sliver: SliverList.builder(
                itemCount: filteredEpisodes.length,
                itemBuilder: (context, index) {
                  final episode = filteredEpisodes[index];
                  final size = MediaQuery.sizeOf(context);
                  final orientation = MediaQuery.orientationOf(context);
                  return BannerEpisode(
                    anime: widget.anime,
                    episode: episode,
                    orientation: orientation,
                    size: size,
                    onTapSaveEpisode: widget.onTapSaveEpisode,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SearchBarField extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBarField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF334155),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: const InputDecoration(
          hintText: 'Buscar episodio...',
          hintStyle: TextStyle(color: Color(0xFF64748B)),
          prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF7C4DFF)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }
}

class _ToolbarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  const _ToolbarDelegate({required this.child});
  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(



      padding: const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _ToolbarDelegate oldDelegate) => false;
}

class _RelatedTab extends StatelessWidget {
  final CompleteAnime anime;
  final double padding08;
  final void Function({required String id, String? tag, required String title})
      navigation;

  const _RelatedTab({
    required this.anime,
    required this.padding08,
    required this.navigation,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: padding08),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220,
              crossAxisSpacing: 30,
              mainAxisExtent: 280,
              mainAxisSpacing: 30,
            ),
            itemCount: anime.listAnimeRelated.length,
            itemBuilder: (context, index) => BannerAnime(
              size: size,
              theme: theme,
              isPortrait: isPortrait,
              anime: anime.listAnimeRelated[index],
              tag: 'animeSearch',
              onTapElement: navigation,
            ),
          ),
        ),
      ],
    );
  }
}

class _ToolbarEpisodes extends StatelessWidget {
  final bool isUpward;
  final TypesVision typesVision;
  final void Function({required TypesVision? type}) changeTypeVision;

  const _ToolbarEpisodes({
    required this.isUpward,
    required this.typesVision,
    required this.changeTypeVision,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconButton(
            onPressed: () =>
                context.read<ConfigurationBloc>().add(ChangeOrderList()),
            color: Colors.white,
            isSelected: isUpward,
            icon: const Icon(Icons.arrow_downward),
            selectedIcon: const Icon(Icons.arrow_upward),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(15),
          ),
          child: DropdownButton<TypesVision>(
            value: typesVision,
            underline: const SizedBox(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            borderRadius: BorderRadius.circular(15),
            dropdownColor: const Color(0xFF1E293B),
            icon: const Icon(Icons.keyboard_arrow_down,
                color: Color(0xFF7C4DFF)),
            items: _dropdownItems,
            onChanged: (value) => changeTypeVision(type: value),
          ),
        ),
      ],
    );
  }

  static final _dropdownItems = TypesVision.values
      .map((vision) => DropdownMenuItem(
            value: vision,
            child: Text(
              vision.content,
              style: const TextStyle(color: Colors.white),
            ),
          ))
      .toList();
}
