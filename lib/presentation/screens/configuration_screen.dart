import 'package:anime/domain/bloc/configuration/configuration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  void openImageSelector(BuildContext context, String imagePerson) {
    Size size = MediaQuery.sizeOf(context);
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        // Fondo transparente para suavizar bordes
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white70, blurRadius: 10, spreadRadius: -3)
                ],
              ),
              padding: EdgeInsets.only(
                  top: 30, right: size.width * 0.05, left: size.width * 0.05),
              height: size.height * 0.6,
              child: Column(spacing: size.height * 0.02, children: [
                Text("Selecciona una imagen",
                    style: Theme.of(context).textTheme.titleLarge),
                Expanded(
                    child: GridView.count(
                        crossAxisSpacing: size.width * 0.05,
                        mainAxisSpacing: size.height * 0.02,
                        crossAxisCount: 3,
                        children: [
                          "assets/wallpaper/saitama.webp",
                          "assets/wallpaper/imagen2.webp",
                          "assets/wallpaper/imagen3.webp",
                          "assets/wallpaper/imagen4.jpg",
                          "assets/wallpaper/imagen5.webp",
                          "assets/wallpaper/imagen6.webp",
                          "assets/wallpaper/imagen7.webp",
                          "assets/wallpaper/imagen8.webp"
                        ].map((imageUrl) {
                          return GestureDetector(
                              onTap: () {
                                context
                                    .read<ConfigurationBloc>()
                                    .add(ChangeImagePerson(image: imageUrl));
                                Navigator.pop(context);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: imageUrl == imagePerson
                                        ? Border.all(
                                            color: Colors.blueAccent, width: 3)
                                        : null,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(imageUrl,
                                        fit: BoxFit.cover),
                                  )));
                        }).toList()))
              ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
        builder: (context, state) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * .1),
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(child: Text("Versión : ${state.version}")),
            SliverToBoxAdapter(
                child: Row(children: [
              Expanded(child: Text("Cambiar imagen del avatar: ")),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white10, width: 3),
                      borderRadius: BorderRadius.circular(5)),
                  width: 120,
                  height: 100,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        padding: WidgetStatePropertyAll(EdgeInsets.zero),
                        shadowColor: WidgetStatePropertyAll(Colors.white),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)))),
                    onPressed: () =>
                        openImageSelector(context, state.imagePerson),
                    child: Image.asset(state.imagePerson,
                        width: 120, height: 100, fit: BoxFit.cover),
                  ))
            ]))
          ]));
    });
  }
}
