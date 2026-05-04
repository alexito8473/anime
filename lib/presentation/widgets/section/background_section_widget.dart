import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/configuration/configuration_bloc.dart';

class BackgroundSectionWidget extends StatelessWidget {
  const BackgroundSectionWidget({super.key});

  void openImageBackGroundSelector(
      BuildContext context, String imageCurrent) async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assets = manifest
        .listAssets()
        .where((key) => key.startsWith('assets/backgroundImage/'))
        .toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // 🔥 clave para hacerlo más alto
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85, // 🔥 más alto
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white24,
                    blurRadius: 15,
                    spreadRadius: -5,
                  )
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  /// 🔥 HANDLE BAR
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// TITLE
                  Text(
                    'Selecciona una imagen',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),

                  const SizedBox(height: 20),

                  /// GRID
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: assets.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final imageUrl = assets[index];

                        return GestureDetector(
                          onTap: () {
                            context.read<ConfigurationBloc>().add(
                                  ChangeImageBackground(image: imageUrl),
                                );
                            Navigator.pop(context);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: imageUrl == imageCurrent
                                  ? Border.all(
                                      color: Colors.blueAccent,
                                      width: 3,
                                    )
                                  : Border.all(
                                      color: Colors.transparent,
                                    ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
