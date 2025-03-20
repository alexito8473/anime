import 'package:anime/domain/bloc/configuration/configuration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZoomDrawerScreen extends StatelessWidget {
  final Function changeIndex;

  const ZoomDrawerScreen({super.key, required this.changeIndex});

  Widget createButtonDrawer(
      {required String title,
      required int current,
      required Size size,
      required BuildContext context}) {
    return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: ElevatedButton(
            onPressed: () => changeIndex(index: current),
            style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 10,
                    // Sombra elevada
                    shadowColor: Colors.transparent)
                .copyWith(
                    overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.blueGrey.shade900; // Efecto al presionar
              }
              return null;
            })),
            child: SizedBox(
                width: size.width * 0.55,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium
                ))));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Container(
                  padding: const EdgeInsets.only(top: 50, left: 10),
                  alignment: Alignment.centerLeft,
                  child: SafeArea(
                      child: CircleAvatar(
                          maxRadius: 45,
                          minRadius: 40,
                          backgroundImage:
                              Image.asset(context.watch<ConfigurationBloc>().state.imagePerson)
                                  .image))),
              createButtonDrawer(
                  title: "Inicio", current: 0, size: size, context: context),
              createButtonDrawer(
                  title: "Mis animes",
                  current: 1,
                  size: size,
                  context: context),
              createButtonDrawer(
                  title: "Tipos de animes",
                  current: 2,
                  size: size,
                  context: context),
              createButtonDrawer(
                  title: "Géneros", current: 3, size: size, context: context),
              createButtonDrawer(
                  title: "Opciones", current: 4, size: size, context: context),
            ])));
  }
}
