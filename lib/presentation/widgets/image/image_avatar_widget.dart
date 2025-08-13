import 'package:anime/domain/bloc/configuration/configuration_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageAvatarWidget extends StatelessWidget {
  const ImageAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ConfigurationBloc, ConfigurationState, String>(
      selector: (state) => state.imagePerson,
      builder: (context, state) {
        return Container(
            padding: const EdgeInsets.only(top: 50, left: 10),
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
                maxRadius: 45,
                minRadius: 40,
                backgroundImage: Image.asset(
                        context.watch<ConfigurationBloc>().state.imagePerson)
                    .image));
      },
    );
  }
}
