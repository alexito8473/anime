import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/configuration/configuration_bloc.dart';

class AvatarSectionWidget extends StatelessWidget {
  const AvatarSectionWidget({super.key});
  void openImageSelector(BuildContext context, String imagePerson) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // 🔥 importante
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        final size = MediaQuery.sizeOf(context);

        final List<String> images = [
          'assets/wallpaper/saitama.webp',
          'assets/wallpaper/imagen2.webp',
          'assets/wallpaper/imagen3.webp',
          'assets/wallpaper/imagen4.jpg',
          'assets/wallpaper/imagen5.webp',
          'assets/wallpaper/imagen6.webp',
          'assets/wallpaper/imagen7.webp',
          'assets/wallpaper/imagen8.webp',
        ];

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

                  /// HANDLE BAR
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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 20),

                  /// GRID
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                      ),
                      itemCount: images.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final imageUrl = images[index];

                        return GestureDetector(
                          onTap: () {
                            context.read<ConfigurationBloc>().add(
                                  ChangeImagePerson(image: imageUrl),
                                );
                            Navigator.pop(context);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: imageUrl == imagePerson
                                  ? Border.all(
                                      color: Colors.blueAccent,
                                      width: 3,
                                    )
                                  : Border.all(color: Colors.transparent),
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
