import 'dart:convert';
import 'dart:io';

import 'package:anime/domain/bloc/configuration/configuration_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/update/update_bloc.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

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

  Widget _buildVersionCard(BuildContext context, ConfigurationState state) {
    return SliverToBoxAdapter(
        child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text('Versión Actual',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(state.version,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.orange, fontWeight: FontWeight.w600))
                ])));
  }

  Widget _buildAvatarSection(BuildContext context, ConfigurationState state) {
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
                  onTap: () => openImageSelector(context, state.imagePerson),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white10, width: 3),
                          borderRadius: BorderRadius.circular(10)),
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(state.imagePerson,
                              width: 120, height: 120, fit: BoxFit.cover))))
            ])));
  }

  Widget _buildBackGroundSection(
      BuildContext context, ConfigurationState state) {
    return SliverToBoxAdapter(
        child: Column(spacing: 10, children: [
      Text('Cambiar imagen del fondo',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white)),
      GestureDetector(
          onTap: () =>
              openImageBackGroundSelector(context, state.imageBackGround),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white10, width: 3),
                  borderRadius: BorderRadius.circular(10)),
              width: 120,
              height: 120,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(state.imageBackGround,
                      width: 120, height: 120, fit: BoxFit.cover))))
    ]));
  }

  Widget _buildUpdateCard(BuildContext context) {
    final bool canUpdate = context.watch<UpdateBloc>().state.canUpdate;
    return SliverToBoxAdapter(
        child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.grey.shade800, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            canUpdate
                ? '¡Nueva versión disponible!'
                : 'Tienes la última versión',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.white),
          ),
          if (canUpdate)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () => {
                  if (!kIsWeb && Platform.isAndroid)
                    {context.read<UpdateBloc>().add(CanUpdateMobileEvent())}
                },
                child: const Text('Actualizar ahora',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
        builder: (context, state) {
      return SafeArea(child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * .1),
          child: CustomScrollView(slivers: [
            _buildVersionCard(context, state),
            _buildUpdateCard(context),
            _buildAvatarSection(context, state),
            _buildBackGroundSection(context, state),
          ])));
    });
  }
}
