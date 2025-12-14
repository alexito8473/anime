import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/configuration/configuration_bloc.dart';

class AvatarSectionWidget extends StatelessWidget {
  const AvatarSectionWidget({super.key});

  void openImageSelector(BuildContext context, String imagePerson) {
    final Size size = MediaQuery.sizeOf(context);
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) {
          return Container(
              decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white70, blurRadius: 10, spreadRadius: -3)
                  ]),
              padding: EdgeInsets.only(
                  top: 30, right: size.width * 0.05, left: size.width * 0.05),
              height: size.height * 0.6,
              child: Column(spacing: size.height * 0.02, children: [
                Text('Selecciona una imagen',
                    style: Theme.of(context).textTheme.titleLarge),
                Expanded(
                    child: GridView.count(
                        crossAxisSpacing: size.width * 0.05,
                        mainAxisSpacing: size.height * 0.02,
                        crossAxisCount: 3,
                        children: [
                          'assets/wallpaper/saitama.webp',
                          'assets/wallpaper/imagen2.webp',
                          'assets/wallpaper/imagen3.webp',
                          'assets/wallpaper/imagen4.jpg',
                          'assets/wallpaper/imagen5.webp',
                          'assets/wallpaper/imagen6.webp',
                          'assets/wallpaper/imagen7.webp',
                          'assets/wallpaper/imagen8.webp'
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
                                          fit: BoxFit.cover))));
                        }).toList()))
              ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ConfigurationBloc, ConfigurationState, String>(
      selector: (state) => state.imagePerson,
      builder: (context, state) {
        return SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(spacing: 10, children: [
                  Text('Cambiar imagen del avatar',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white)),
                  GestureDetector(
                      onTap: () => openImageSelector(context, state),
                      child: Container(
                          decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.white10, width: 3),
                              borderRadius: BorderRadius.circular(10)),
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(state,
                                  width: 120, height: 120, fit: BoxFit.cover))))
                ])));
      },
    );
  }
}
