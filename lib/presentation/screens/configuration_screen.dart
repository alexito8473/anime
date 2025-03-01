import 'package:anime/domain/bloc/configuration/configuration_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<ConfigurationBloc, ConfigurationState>(
        builder: (context, state) {
      return CustomScrollView(slivers: [
        SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: size.width * .1),
            sliver:
                SliverToBoxAdapter(child: Text("Versión : ${state.version}")))
      ]);
    });
  }
}
