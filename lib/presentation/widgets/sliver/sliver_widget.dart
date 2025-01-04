import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/model/anime.dart';
import '../banner/banner_widget.dart';

class SliverAppBarSearch extends StatelessWidget {
  final TextEditingController controller;
  final Function? onSubmit;
  final bool snapFloatingPinned;
  final bool isFlexibleSpaceBar;
  const SliverAppBarSearch(
      {super.key,
      required this.controller,
      this.onSubmit,
      this.snapFloatingPinned = true,
      this.isFlexibleSpaceBar = true});

  Widget textField(Size size) {
    return Container(
        margin: isFlexibleSpaceBar
            ? EdgeInsets.zero
            : EdgeInsets.symmetric(horizontal: size.width * 0.05),
        decoration: BoxDecoration(
            color: Colors.grey[850], // Fondo oscuro para el buscador
            borderRadius: BorderRadius.circular(20)),
        child: TextField(
            controller: controller,
            onSubmitted: (value) {
              if (onSubmit != null) {
                onSubmit!();
              }
            },
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: 'Buscar...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                icon: IconButton(
                    onPressed: () {
                      if (onSubmit != null) {
                        onSubmit!();
                      }
                    },
                    icon: const Icon(Icons.search, color: Colors.orange)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10))));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SliverAppBar(
        floating: snapFloatingPinned,
        snap: snapFloatingPinned,
        pinned: snapFloatingPinned,
        automaticallyImplyLeading: false,
        expandedHeight: size.height * 0.02,
        backgroundColor: Colors.transparent,
        flexibleSpace: isFlexibleSpaceBar
            ? FlexibleSpaceBar(
                stretchModes: StretchMode.values,
                titlePadding:
                    EdgeInsets.symmetric(horizontal: size.width * 0.05),
                title: textField(size))
            : textField(size));
  }
}


