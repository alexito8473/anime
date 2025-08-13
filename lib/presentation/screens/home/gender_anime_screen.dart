import 'package:anime/data/enums/gender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/anime/anime_bloc.dart';
import '../../widgets/banner/banner_widget.dart';


class GenderAnimeScreen extends StatelessWidget {
  const GenderAnimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    void navigatePage(Gender gender) {
      context
          .read<AnimeBloc>()
          .add(ObtainDataGender(context: context, gender: gender));
    }
    return SafeArea(child: CustomScrollView(slivers: [
      SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.03,
            vertical: size.height * 0.01,
          ),
          sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                  maxCrossAxisExtent: 170),
              itemCount: Gender.values.length,
              itemBuilder: (context, index) {
                final gender = Gender.values[index];
                return GestureDetector(
                    onTap: () => navigatePage(gender),
                    child: Hero(
                        tag: gender.name,
                        child: BannerBlur(
                            image: gender.getImage(), text: gender.name)));
              }))
    ]));
  }
}
