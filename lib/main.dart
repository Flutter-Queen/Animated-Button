import 'package:flutter/material.dart';

import 'constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animated Button',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ButtonScreen(),
    );
  }
}

class ButtonScreen extends StatefulWidget {
  const ButtonScreen({Key? key}) : super(key: key);

  @override
  State<ButtonScreen> createState() => _ButtonScreenState();
}

class _ButtonScreenState extends State<ButtonScreen>
    with TickerProviderStateMixin {
  /// when playing, animation will be played
  bool playing = false;

  /// animation controller for the play pause button
  late AnimationController _playPauseAnimationController;

  /// animation & animation controller for the top-left and bottom-right bubbles
  late Animation<double> _topBottomAnimation;
  late AnimationController _topBottomAnimationController;

  /// animation & animation controller for the top-right and bottom-left bubbles
  late Animation<double> _leftRightAnimation;
  late AnimationController _leftRightAnimationController;

  @override
  void initState() {
    super.initState();
    _playPauseAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _topBottomAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _leftRightAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _topBottomAnimation = CurvedAnimation(
            parent: _topBottomAnimationController, curve: Curves.decelerate)
        .drive(Tween<double>(begin: 5, end: -5));
    _leftRightAnimation = CurvedAnimation(
            parent: _leftRightAnimationController, curve: Curves.easeInOut)
        .drive(Tween<double>(begin: 5, end: -5));

    _leftRightAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _leftRightAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _leftRightAnimationController.forward();
      }
    });

    _topBottomAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _topBottomAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _topBottomAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _playPauseAnimationController.dispose();
    _topBottomAnimationController.dispose();
    _leftRightAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = 150;
    double height = 150;

    return Scaffold(
      backgroundColor: darkBlue,
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   title: const Text('Animated Button'),
      //   centerTitle: true,
      //   elevation: 0.1,

      // ),
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // bottom right yellow
            AnimatedBuilder(
              animation: _topBottomAnimation,
              builder: (context, _) {
                return Positioned(
                  bottom: _topBottomAnimation.value,
                  right: _topBottomAnimation.value,
                  child: Container(
                    width: width * 0.9,
                    height: height * 0.9,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [yellow, blue],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: yellow.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // top left blue
            AnimatedBuilder(
                animation: _topBottomAnimation,
                builder: (context, _) {
                  return Positioned(
                    top: _topBottomAnimation.value,
                    left: _topBottomAnimation.value,
                    child: Container(
                      width: width * 0.9,
                      height: height * 0.9,
                      decoration: BoxDecoration(
                        color: yellow.withOpacity(0.5),
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [yellow, blue],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: playing
                            ? [
                                BoxShadow(
                                  color: yellow.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                ),
                              ]
                            : [],
                      ),
                    ),
                  );
                }), // light yellow
            // bottom left blue
            AnimatedBuilder(
                animation: _leftRightAnimation,
                builder: (context, _) {
                  return Positioned(
                    bottom: _leftRightAnimation.value,
                    left: _leftRightAnimation.value,
                    child: Container(
                      width: width * 0.9,
                      height: height * 0.9,
                      decoration: BoxDecoration(
                        color: blue,
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [blue, yellow],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: blue.withOpacity(0.5),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            // top right dark blue
            AnimatedBuilder(
              animation: _leftRightAnimation,
              builder: (context, _) {
                return Positioned(
                  top: _leftRightAnimation.value,
                  right: _leftRightAnimation.value,
                  child: Container(
                    width: width * 0.9,
                    height: height * 0.9,
                    decoration: BoxDecoration(
                      color: blue,
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [yellow, blue],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: playing
                          ? [
                              BoxShadow(
                                color: blue.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 5,
                              ),
                            ]
                          : [],
                    ),
                  ),
                );
              },
            ),
            // play button
            GestureDetector(
              onTap: () {
                playing = !playing;

                if (playing) {
                  _playPauseAnimationController.forward();
                  _topBottomAnimationController.forward();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    _leftRightAnimationController.forward();
                  });
                } else {
                  _playPauseAnimationController.reverse();
                  _topBottomAnimationController.stop();
                  _leftRightAnimationController.stop();
                }
              },
              child: Container(
                width: width,
                height: height,
                decoration: const BoxDecoration(
                  color: darkBlue,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _playPauseAnimationController,
                    size: 100,
                    color: white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
