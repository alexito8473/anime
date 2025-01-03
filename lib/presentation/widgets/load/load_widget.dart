import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/anime_bloc.dart';

class LoadWidget extends StatelessWidget {
  const LoadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black54,
        child: const Center(
            child: CircularProgressIndicator(
                backgroundColor: Colors.red,
                strokeWidth: 10,
                strokeAlign: 3,
                color: Colors.orange)));
  }
}

class AnimationLoadPage extends StatelessWidget {
  final Widget child;
  const AnimationLoadPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnimeBloc, AnimeState>(builder: (context, state) {
      return Stack(fit: StackFit.expand, children: [
        Positioned.fill(child: child),
        if (state.initLoad) const Positioned.fill(child: LoadWidget())
      ]);
    });
  }
}
