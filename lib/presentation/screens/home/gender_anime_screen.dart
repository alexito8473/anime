import 'package:anime/data/enums/gender.dart';
import 'package:anime/domain/bloc/configuration/configuration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constansT.dart';
import '../../../domain/bloc/anime/anime_bloc.dart';
import '../../widgets/banner/banner_widget.dart';

class GenderAnimeScreen extends StatelessWidget {
  const GenderAnimeScreen({super.key});

  void navigatePage({required BuildContext context, required Gender gender}) {
    context
        .read<AnimeBloc>()
        .add(ObtainDataGender(context: context, gender: gender));
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SafeArea(
        child: CustomScrollView(slivers: [
      SliverAppBar(
        title: const Text(Constants.gender),
        floating: true,
        actions: [
          BlocSelector<ConfigurationBloc, ConfigurationState, bool>(
              selector: (state) => state.genderActiveList,
              builder: (context, state) {
                return IconButton(
                  isSelected: state,
                  onPressed: () {
                    context.read<ConfigurationBloc>().add(ChangeGenderList());
                  },
                  icon: const Icon(Icons.grid_on),
                  selectedIcon: const Icon(Icons.list),
                );
              }),
        ],
      ),
      SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.03,
          vertical: size.height * 0.01,
        ),
        sliver: BlocSelector<ConfigurationBloc, ConfigurationState, bool>(
            selector: (state) => state.genderActiveList,
            builder: (context, state) {
              if (state) {
                return SliverListGenderWidget(clickGender: navigatePage);
              }
              return SliverGridGenderWidget(clickGender: navigatePage);
            }),
      )
    ]));
  }
}

class BoxGenderBlurAndGestureWidget extends StatelessWidget {
  final Gender gender;
  final Function({required Gender gender, required BuildContext context}) click;

  const BoxGenderBlurAndGestureWidget(
      {super.key, required this.click, required this.gender});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () => click(context: context, gender: gender),
      child: SizedBox(
          width: size.width,
          height: size.height * .15,
          child: Hero(
              tag: gender.name,
              child: BannerBlur(image: gender.getImage(), text: gender.name))),
    );
  }
}

class SliverListGenderWidget extends StatelessWidget {
  final Function({required Gender gender, required BuildContext context})
      clickGender;

  const SliverListGenderWidget({super.key, required this.clickGender});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return SliverList.separated(
        separatorBuilder: (context, index) =>
            Container(height: size.height * 0.02),
        addRepaintBoundaries: true,
        addSemanticIndexes: false,
        addAutomaticKeepAlives: false,
        itemCount: Gender.values.length,
        itemBuilder: (context, index) {
          return BoxGenderBlurAndGestureWidget(
              click: clickGender, gender: Gender.values[index]);
        });
  }
}

class SliverGridGenderWidget extends StatelessWidget {
  final Function({required Gender gender, required BuildContext context})
      clickGender;

  const SliverGridGenderWidget({super.key, required this.clickGender});

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
        addRepaintBoundaries: true,
        addSemanticIndexes: false,
        addAutomaticKeepAlives: false,
        itemCount: Gender.values.length,
        itemBuilder: (context, index) {
          return BoxGenderBlurAndGestureWidget(
              click: clickGender, gender: Gender.values[index]);
        });
  }
}
