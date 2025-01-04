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
  bool isComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _initializeAnimations();
    context.read<AnimeBloc>().add(ObtainData(context: context));
  }

  void _initializeVideo() {
    final List<String> listVideo = [
      'assets/video/video1.mp4',
      'assets/video/video2.mp4',
      'assets/video/video3.mp4',
      'assets/video/video4.mp4',
      'assets/video/video5.mp4',
      'assets/video/video6.mp4'
    ];
    _controller = VideoPlayerController.asset(
      listVideo[Random().nextInt(listVideo.length)],
    )..initialize().then((_) {
        _controller
          ..setLooping(true)
          ..setVolume(0.05)
          ..play();
        setState(() {}); // Reconstruir solo después de inicializar el video
      });
  }

  void _initializeAnimations() {
    _zoomAnimationController =
        AnimationController(vsync: this, duration: durationAnimation);
    _zoomAnimation = Tween<double>(begin: 1.5, end: 5.0).animate(
      CurvedAnimation(parent: _zoomAnimationController, curve: Curves.linear),
    );

    _darkAnimationController =
        AnimationController(vsync: this, duration: durationAnimation);
    _darkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _darkAnimationController, curve: Curves.linear),
    );

    _volumeAnimationController =
        AnimationController(vsync: this, duration: durationAnimation);
    _volumeAnimation = Tween<double>(begin: 0.05, end: 0.0).animate(
      CurvedAnimation(parent: _volumeAnimationController, curve: Curves.linear),
    );

    _volumeAnimationController.addListener(() {
      _controller.setVolume(_volumeAnimation.value);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _zoomAnimationController.dispose();
    _darkAnimationController.dispose();
    _volumeAnimationController.dispose();
    super.dispose();
  }

  Future<void> _action() async {
    await Future.wait([
      _zoomAnimationController.forward(),
      _darkAnimationController.forward(),
      _volumeAnimationController.forward(),
    ]);
  }

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AnimeBloc, AnimeState>(
        listener: (context, state) async {
          if (state.isObtainAllData && !isComplete) {
            isComplete = true;
            await _action().whenComplete(() => _navigateToHome());
          }
        },
        child: Stack(children: [
          Center(
              child: AnimatedBuilder(
                  animation: _zoomAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                        scale: _zoomAnimation.value,
                        child: AspectRatio(
                            aspectRatio: _controller.value.isInitialized
                                ? _controller.value.aspectRatio
                                : 16 / 9,
                            child: VideoPlayer(_controller)));
                  })),
          AnimatedBuilder(
              animation: _darkAnimation,
              builder: (context, child) {
                return Container(
                    color: Colors.black.withOpacity(_darkAnimation.value));
              })
        ]));
  }
}
