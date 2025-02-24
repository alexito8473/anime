import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/bloc/anime/anime_bloc.dart';

class LoadWidget extends StatelessWidget {
  final double? height;

  const LoadWidget({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
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
    return Stack(children: [
      Positioned.fill(child: child),
      if (context.watch<AnimeBloc>().state.initLoad)
        const Positioned.fill(child: LoadWidget()),
    ]);
  }
}
