import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliverAppBarSearch extends StatelessWidget {
  final TextEditingController controller;
  final Function onSubmit;
  const SliverAppBarSearch(
      {super.key, required this.controller, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SliverAppBar(
        floating: true,
        snap: true,
        pinned: true,
        automaticallyImplyLeading: false,
        expandedHeight: size.height * 0.02,
        backgroundColor: Colors.black,
        flexibleSpace: FlexibleSpaceBar(
            stretchModes: StretchMode.values,
            titlePadding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            title: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[850], // Fondo oscuro para el buscador
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                    controller: controller,
                    onSubmitted: (value) {
                      onSubmit();
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'Buscar...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        icon: IconButton(
                            onPressed: () => onSubmit(),
                            icon:
                                const Icon(Icons.search, color: Colors.orange)),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10))))));
  }
}
