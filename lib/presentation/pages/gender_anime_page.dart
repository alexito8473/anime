import 'package:anime/data/enums/gender.dart';
import 'package:anime/domain/bloc/anime/anime_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/gender_anime_screen.dart';

class GenderAnimePage extends StatefulWidget {
  const GenderAnimePage({super.key});

  @override
  State<GenderAnimePage> createState() => _GenderAnimePageState();
}

class _GenderAnimePageState extends State<GenderAnimePage> {
  void navigatePage(Gender gender) {
    context
        .read<AnimeBloc>()
        .add(ObtainDataGender(context: context, gender: gender));
  }

  @override
  Widget build(BuildContext context) {
    return GenderAnimeScreen(navigation: navigatePage);
  }
}
