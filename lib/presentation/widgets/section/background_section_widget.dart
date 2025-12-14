import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/configuration/configuration_bloc.dart';

class BackgroundSectionWidget extends StatelessWidget {
  const BackgroundSectionWidget({super.key});

  void openImageBackGroundSelector(
      BuildContext context, String imageCurrent) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    // Filtrar solo los archivos dentro del directorio deseado
    final List<String> assets = manifestMap.keys
        .where((key) => key.startsWith('assets/backgroundImage/'))
        .toList();
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
                        children: assets.map((imageUrl) {
                          return GestureDetector(
                              onTap: () {
                                context.read<ConfigurationBloc>().add(
                                    ChangeImageBackground(image: imageUrl));
                                Navigator.pop(context);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: imageUrl == imageCurrent
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
    return BlocSelector<ConfigurationBloc, ConfigurationState, String>(
        selector: (state) => state.imageBackGround,
        builder: (context, state) {
          return SliverToBoxAdapter(
              child: Column(spacing: 10, children: [
                Text('Cambiar imagen del fondo',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white)),
                GestureDetector(
                    onTap: () => openImageBackGroundSelector(context, state),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white10, width: 3),
                            borderRadius: BorderRadius.circular(10)),
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(state,
                                width: 120, height: 120, fit: BoxFit.cover))))
              ]));
        });
  }
}