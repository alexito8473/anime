import 'package:flutter/material.dart';

import '../widgets/button/button_selector_icon_text_widget.dart';
import '../widgets/image/image_avatar_widget.dart';

class ZoomDrawerScreen extends StatelessWidget {
  final Function(int index) changeIndex;

  const ZoomDrawerScreen({super.key, required this.changeIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                 Color(0xFF111827),
                 Color(0xFF0A0E17),
              ],
            ),
          ),
          child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: ImageAvatarWidget(),
                      ),
                      const SizedBox(height: 12),
                      _buildDrawerItem(Icons.home_rounded, 'Inicio', 0),
                      _buildDrawerItem(Icons.favorite_rounded, 'Mis animes', 1),
                      _buildDrawerItem(Icons.category_rounded, 'Tipos de animes', 2),
                      _buildDrawerItem(Icons.label_rounded, 'Géneros', 3),
                      _buildDrawerItem(Icons.settings_rounded, 'Opciones', 4),
                    ]),
              )),
        ));
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ButtonSelectorIconTextWidget(
        icon: icon,
        title: title,
        current: index,
        changeIndex: changeIndex,
      ),
    );
  }
}
