import 'package:anime/domain/bloc/configuration/configuration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/button/button_selector_icon_text_widget.dart';
import '../widgets/image/image_avatar_widget.dart';

class ZoomDrawerScreen extends StatelessWidget {
  final Function(int index) changeIndex;

  const ZoomDrawerScreen({super.key, required this.changeIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              const ImageAvatarWidget(),
              ButtonSelectorIconTextWidget(
                  icon: Icons.home,
                  title: 'Inicio',
                  current: 0,
                  changeIndex: changeIndex),
              ButtonSelectorIconTextWidget(
                  icon: Icons.favorite,
                  title: 'Mis animes',
                  current: 1,
                  changeIndex: changeIndex),
              ButtonSelectorIconTextWidget(
                  icon: Icons.category,
                  title: 'Tipos de animes',
                  current: 2,
                  changeIndex: changeIndex),
              ButtonSelectorIconTextWidget(
                  icon: Icons.label,
                  title: 'Géneros',
                  current: 3,
                  changeIndex: changeIndex),
              ButtonSelectorIconTextWidget(
                  icon: Icons.settings,
                  title: 'Opciones',
                  current: 4,
                  changeIndex: changeIndex)
            ])));
  }
}
