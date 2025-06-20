import 'dart:io';

import 'package:anime/domain/bloc/update/update_bloc.dart';
import 'package:anime/presentation/pages/explore_page.dart';
import 'package:anime/presentation/screens/home/types_anime_screen.dart';
import 'package:anime/presentation/screens/home/save_screen.dart';
import 'package:anime/presentation/screens/home/home_screen.dart';
import 'package:anime/presentation/screens/zoom_drawer_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../../data/enums/type_my_animes.dart';
import '../../data/enums/type_version_anime.dart';
import '../../domain/bloc/anime/anime_bloc.dart';
import '../../domain/bloc/configuration/configuration_bloc.dart';
import '../screens/home/configuration_screen.dart';
import '../screens/home/gender_anime_screen.dart';
import '../screens/type_anime_screen.dart';
import '../widgets/load/load_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ZoomDrawerController zoomDrawerController = ZoomDrawerController();
  int _currentIndex = 0;
  int _currentIndexTypeAnimePage = 0;
  final List<TypeMyAnimes> animeTypes = TypeMyAnimes.values.sublist(1);
  late final TabController tabController;

  final List<bool> _canUpdate =
      List.generate(TypeVersionAnime.values.length, (_) => true);

  final List<GlobalKey> _targetKeyList =
      List.generate(TypeVersionAnime.values.length, (_) => GlobalKey());

  late final List<Widget> listScreenTypePage = List.generate(
      TypeVersionAnime.values.length,
      (index) => ListTypeScreen(
          scrollController: _scrollControllers[index],
          type: TypeVersionAnime.values[index],
          targetKey: _targetKeyList[index],
          onTapElement: navigation));

  final List<ScrollController> _scrollControllers =
      List.generate(TypeVersionAnime.values.length, (_) => ScrollController());

  @override
  void initState() {
    super.initState();
    final animeBloc = context.read<AnimeBloc>().state.mapPageAnimes;
    for (var key in animeBloc.keys) {
      _scrollControllers[key.index].addListener(() => loadMore(key: key));
    }
    tabController = TabController(length: animeTypes.length, vsync: this);
    context.read<ConfigurationBloc>().add(ObtainDataVersion());
    if (!kIsWeb && Platform.isAndroid) {
      context.read<UpdateBloc>().add(CanUpdateMobileEvent());
    }
  }

  @override
  void dispose() {
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void loadMore({required TypeVersionAnime key}) {
    final scrollController = _scrollControllers[key.index];
    final page = context.read<AnimeBloc>().state.mapPageAnimes[key];

    if (page == null || page.isObtainAllData) {
      if (_canUpdate[key.index]) {
        setState(() => _canUpdate[key.index] = false);
      }
      return;
    }
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      final currentScrollPosition = scrollController.position.pixels;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(currentScrollPosition - 100);
      });
      context.read<AnimeBloc>().add(UpdatePage(typeVersionAnime: key));
    }
  }

  void moveScroll(GlobalKey globalKey) {
    Scrollable.ensureVisible(globalKey.currentContext!,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  void changeIndexTypeAnimePage({required int index}) {
    _currentIndexTypeAnimePage == index
        ? moveScroll(_targetKeyList[index])
        : setState(() => _currentIndexTypeAnimePage = index);
  }

  void navigateToSearch() {
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ExplorePage(),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                  position: animation.drive(
                    Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.linear)),
                  ),
                  child: child);
            }));
  }

  void changeIndex(int index) {
    setState(() => _currentIndex = index);
    zoomDrawerController.toggle?.call();
  }

  void navigation({required String id, String? tag, required String title}) {
    context
        .read<AnimeBloc>()
        .add(ObtainDataAnime(context: context, id: id, tag: tag, title: title));
  }

  void showModelUpdate(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    showDialog(
        context: context,
        barrierColor: Colors.black87,
        builder: (context) => AlertDialog(
                backgroundColor: Colors.grey.shade900,
                shadowColor: Colors.white54,
                title: Text(
                  'Nueva actualización disponible',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'Se ha encontrado una nueva versión de la aplicación. ¿Deseas actualizar ahora?',
                  style: theme.textTheme.bodyMedium,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Más tarde',
                        style: theme.textTheme.labelLarge!.copyWith(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600)),
                  ),
                  TextButton(
                      onPressed: () {
                        context.read<UpdateBloc>().add(UpdateMobileEvent());
                        Navigator.of(context).pop();
                      },
                      child: Text('Actualizar',
                          style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.bold)))
                ]));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final orientation = MediaQuery.orientationOf(context);
    return BlocListener<UpdateBloc, UpdateState>(
        listener: (context, state) {
          if (state.canUpdate) {
            showModelUpdate(context);
          }
        },
        child: AnimationLoadPage(
            child: Stack(children: [
          BlocSelector<ConfigurationBloc, ConfigurationState, String>(
            selector: (state) => state.imageBackGround,
            builder: (context, state) {
              return Positioned.fill(
                  child: Image.asset(state,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.none,
                      colorBlendMode: BlendMode.darken,
                      color: Colors.black54,
                      alignment: Alignment.topCenter));
            },
          ),
          ZoomDrawer(
              controller: zoomDrawerController,
              drawerShadowsBackgroundColor: Colors.grey.shade800,
              slideWidth: orientation == Orientation.portrait
                  ? size.width * 0.65
                  : size.width * 0.35,
              angle: 0.0,
              menuBackgroundColor: Colors.transparent,
              disableDragGesture: false,
              closeCurve: Curves.linear,
              overlayBlend: BlendMode.darken,
              openCurve: Curves.linear,
              showShadow: true,
              menuScreen:
                  ZoomDrawerScreen(changeIndex: (index) => changeIndex(index)),
              mainScreen: Scaffold(
                  appBar: AppBar(
                      title: BlocSelector<UpdateBloc, UpdateState, String>(
                          selector: (state) => state.advance,
                          builder: (context, state) {
                            return state!=''
                                ? Text(
                                    'Descargando : $state%')
                                : const Text('');
                          }),
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      leading: IconButton(
                          onPressed: () => zoomDrawerController.toggle?.call(),
                          icon: const Icon(Icons.menu)),
                      actions: [
                        IconButton(
                            onPressed: () => navigateToSearch(),
                            icon: const Icon(Icons.search))
                      ]),
                  body: [
                    HomeScreen(onTapElement: navigation),
                    SaveScreen(
                        onTapElement: navigation,
                        animeTypes: animeTypes,
                        tabController: tabController),
                    TypesAnimePage(
                        currentIndex: _currentIndexTypeAnimePage,
                        listScreenTypePage: listScreenTypePage,
                        changeIndex: changeIndexTypeAnimePage,
                        canUpdate: _canUpdate,
                        scrollControllers: _scrollControllers,
                        loadMore: loadMore),
                    const GenderAnimeScreen(),
                    const ConfigurationScreen()
                  ][_currentIndex]))
        ])));
  }
}
