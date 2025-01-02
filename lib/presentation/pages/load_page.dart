import 'dart:math';

import 'package:anime/domain/bloc/anime_bloc.dart';
import 'package:anime/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> with TickerProviderStateMixin {
  late VideoPlayerController _controller;
  late AnimationController _zoomAnimationController;
  late AnimationController _darkAnimationController;
  late AnimationController _volumeAnimationController;
  late Animation<double> _zoomAnimation;
  late Animation<double> _darkAnimation;
  late Animation<double> _volumeAnimation;
  final Duration durationAnimation = const Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    List<String> listVideo = [
      'assets/video/video1.mp4',
      'assets/video/video2.mp4',
      'assets/video/video3.mp4',
      'assets/video/video4.mp4',
      'assets/video/video5.mp4',
      'assets/video/video6.mp4'
    ];
    _controller = VideoPlayerController.asset(
        listVideo[Random().nextInt(listVideo.length)])
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.setVolume(0.05);
        _controller.play();
      });
    _zoomAnimationController =
        AnimationController(vsync: this, duration: durationAnimation);
    _zoomAnimation = Tween<double>(begin: 1.5, end: 5.0).animate(
        CurvedAnimation(
            parent: _zoomAnimationController, curve: Curves.linear));
    _darkAnimationController =
        AnimationController(vsync: this, duration: durationAnimation);
    _darkAnimation = Tween<double>(begin: 0.0, end: 1).animate(CurvedAnimation(
        parent: _darkAnimationController, curve: Curves.linear));
    _volumeAnimationController =
        AnimationController(vsync: this, duration: durationAnimation);
    _volumeAnimation = Tween<double>(begin: 0.05, end: 0.0).animate(
        CurvedAnimation(
            parent: _volumeAnimationController, curve: Curves.linear));
    _volumeAnimation
        .addListener(() => _controller.setVolume(_volumeAnimation.value));
    context.read<AnimeBloc>().add(ObtainData(context: context));
  }

  @override
  void dispose() {
    _controller.dispose();
    _zoomAnimationController.dispose();
    _darkAnimationController.dispose();
    _volumeAnimationController.dispose();
    super.dispose();
  }

  Future<void> action() async {
    await Future.wait([
      _zoomAnimationController.forward(),
      _darkAnimationController.forward(),
      _volumeAnimationController.forward()
    ]);
  }

  void navigation() => Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child)),
      (route) => false);
  @override
  Widget build(BuildContext context) {
    return BlocListener<AnimeBloc, AnimeState>(
        listener: (context, state) async {
          if (state.isObtainAllData) {
            await action().whenComplete(() => navigation());
          }
        },
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(children: [
              Center(
                  child: AnimatedBuilder(
                      animation: _zoomAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                            scale: _zoomAnimation.value,
                            child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller)));
                      })),
              AnimatedBuilder(
                  animation: _darkAnimation,
                  builder: (context, child) {
                    return Container(
                        color: Colors.black.withOpacity(_darkAnimation.value));
                  })
            ])));
  }
}
