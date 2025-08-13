import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/configuration/configuration_bloc.dart';

class ImageBackgroundWidget extends StatelessWidget {
  const ImageBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ConfigurationBloc, ConfigurationState, String>(
      selector: (state) => state.imageBackGround,
      builder: (context, state) {
        return  Image.asset(state,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none,
                colorBlendMode: BlendMode.darken,
                color: Colors.black54,
                alignment: Alignment.topCenter);
      },
    );
  }
}
