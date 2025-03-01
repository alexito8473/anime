import 'dart:io';

import 'package:anime/domain/bloc/update/update_bloc.dart';
import 'package:anime/presentation/pages/explore_page.dart';
import 'package:anime/presentation/pages/save_page.dart';
import 'package:anime/presentation/pages/types_anime_page.dart';
import 'package:anime/presentation/screens/home_screen.dart';
import 'package:anime/presentation/screens/zoom_drawer_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../screens/configuration_screen.dart';
import '../widgets/load/load_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final zoomDrawerController = ZoomDrawerController();
  int _currentIndex = 0;
  late final List<Widget> listScreenPage = [
    const HomeScreen(),
    const SavePage(),
    const TypesAnimePage(),
    const ConfigurationScreen()
  ];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.initState();
    if (!kIsWeb && Platform.isAndroid) {
      context.read<UpdateBloc>().add(CanUpdateMobileEvent());
    }
  }

  void navigateToSearch() {
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ExplorePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var offsetAnimation = animation.drive(
                  Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.linear)));
              return SlideTransition(position: offsetAnimation, child: child);
            }));
  }

  void changeIndex({required int index}) {
    setState(() => _currentIndex = index);
    zoomDrawerController.toggle?.call();
  }

  void mostrarDialogoActualizacion(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: Colors.black87,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.grey.shade900,
              shadowColor: Colors.white54,
              title: Text("Nueva actualización disponible",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              content: Text(
                  "Se ha encontrado una nueva versión de la aplicación. ¿Deseas actualizar ahora?",
                  style: Theme.of(context).textTheme.bodyMedium),
              actions: [
                TextButton(
                    child: Text("Más tarde",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600)),
                    onPressed: () => Navigator.of(context).pop()),
                TextButton(
                    child: Text("Actualizar",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      context.read<UpdateBloc>().add(UpdateMobileEvent());
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    Orientation orientation = MediaQuery.orientationOf(context);
    return BlocConsumer<UpdateBloc, UpdateState>(listener: (context, state) {
      if (state.canUpdate) {
        mostrarDialogoActualizacion(context);
      }
    }, builder: (context, state) {
      return AnimationLoadPage(
          child: Stack(children: [
        Positioned.fill(
            child: Image.asset("assets/wallpaper/wallpaper2.webp",
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none,
                colorBlendMode: BlendMode.darken,
                color: Colors.black54,
                alignment: Alignment.topCenter)),
        ZoomDrawer(
            controller: zoomDrawerController,
            drawerShadowsBackgroundColor: Colors.grey.shade800,
            slideWidth: orientation == Orientation.portrait
                ? size.width * 0.55
                : size.width * 0.35,
            angle: 0.0,
            menuBackgroundColor: Colors.transparent,
            disableDragGesture: false,
            closeCurve: Curves.linear,
            overlayBlend: BlendMode.darken,
            openCurve: Curves.linear,
            showShadow: true,
            menuScreen: ZoomDrawerScreen(changeIndex: changeIndex),
            mainScreen: Scaffold(
                appBar: AppBar(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    title: context.read<UpdateBloc>().state.isUpdating
                        ? Text(
                            "Descargando : ${context.read<UpdateBloc>().state.advance}%")
                        : null,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    leading: IconButton(
                        onPressed: () => zoomDrawerController.toggle?.call(),
                        icon: const Icon(Icons.menu)),
                    actions: [
                      IconButton(
                          onPressed: () {
                            navigateToSearch();
                          },
                          icon: const Icon(Icons.search))
                    ]),
                body: listScreenPage[_currentIndex])),
      ]));
    });
  }
}
