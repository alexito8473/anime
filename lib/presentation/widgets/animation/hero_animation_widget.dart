import 'package:flutter/material.dart';

class HeroAnimationWidget extends StatelessWidget {
  final String? tag;
  final String? heroTag;
  final Widget child;

  const HeroAnimationWidget({super.key, this.tag, this.heroTag, required this.child});

  @override
  Widget build(BuildContext context) {
    return tag == null
        ? child
        : Hero(tag: '$tag$heroTag', child: child);
  }
}
