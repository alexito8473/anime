import 'package:anime/data/enums/gender.dart';
import 'package:flutter/material.dart';

import '../widgets/banner/banner_widget.dart';

class GenderAnimeScreen extends StatelessWidget {
  final Function navigation;

  const GenderAnimeScreen({super.key, required this.navigation});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return CustomScrollView(
      slivers: [
        SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    maxCrossAxisExtent: 170),

                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        navigation(Gender.values[index]);
                      },
                      child: Hero(
                          tag: Gender.values[index].name,
                          child: BannerBlur(
                            image: Gender.values[index].getImage(),
                            text: Gender.values[index].name,
                          )));
                },
                itemCount: Gender.values.length)),
      ],
    );
  }
}
