import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reload_system_admin/src/core/constants/app_colors.dart';
import 'package:smart_reload_system_admin/src/core/presentation/effects/arc_painter.dart';
import 'package:smart_reload_system_admin/src/core/router/route.constants.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/session.cubit.dart';
import 'package:smart_reload_system_admin/src/feature/auth/presentation/bloc/session.state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _squareController;
  late final Animation<double> _squareScale;

  late final AnimationController _dropController;
  late final Animation<double> _arcOffsetY;
  late final Animation<double> _arcOpacity;

  late final AnimationController _tiltController;
  late final Animation<double> _tiltAngle; // radians

  bool _animationFinished = false;
  SessionState? _pendingSessionState;

  @override
  void initState() {
    super.initState();
    ///Fetch Data
    _buildAnimations();
    _runSequence();
    _tiltController.addStatusListener(_onAnimationStatusChanged);
  }

  void _buildAnimations()  {
    // await Future.delayed(const Duration(seconds: 1));

    _squareController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _squareScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _squareController, curve: Curves.easeOutBack),
    );

    _dropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _arcOffsetY = Tween<double>(begin: -100.0, end: 0.0).animate(
      CurvedAnimation(parent: _dropController, curve: Curves.bounceOut),
    );

    _arcOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _dropController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    // ── Phase 3 ─────────────────────────────────────────────────────────────
    _tiltController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _tiltAngle = Tween<double>(
      begin: 0.0,
      end: 5 * math.pi / 180, // 5°
    ).animate(
      CurvedAnimation(parent: _tiltController, curve: Curves.easeInOut),
    );
  }

  Future<void> _runSequence() async {
    // Small initial pause so the screen is visible before animation starts
    await Future.delayed(const Duration(milliseconds: 300));

    // Phase 1 – square pops in
    await _squareController.forward();

    // Phase 2 – arc drops in
    await _dropController.forward();

    // Phase 3 – whole logo tilts 5° from bottom-left corner
    await _tiltController.forward();

    // Future.delayed(const Duration(seconds: 1)).then((value) {
    //   if (mounted) {
    //     Navigator.pushNamedAndRemoveUntil(context, RouteConstants.loginClientScreen, (route) => false);
    //   }
    // });
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animationFinished = true;
      _tryNavigate();
    }
  }

  void _tryNavigate() {

    if (!_animationFinished || _pendingSessionState == null) return;

    final state = _pendingSessionState!;
    if (state is SessionAuthenticated) {
      Navigator.of(context).pushReplacementNamed(RouteConstants.mainScreen);
    } else if (state is SessionUnauthenticated) {
      Navigator.of(context).pushReplacementNamed(RouteConstants.loginScreen);
    }
  }

  @override
  void dispose() {
    _squareController.dispose();
    _dropController.dispose();
    _tiltController.dispose();

    _tiltController.removeStatusListener(_onAnimationStatusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    const squareSize = 60.0;
    const borderRadius = 12.0;
    return BlocListener<SessionCubit, SessionState>(
      listener: (context, state) {

        if (state is SessionAuthenticated || state is SessionUnauthenticated) {
          _pendingSessionState = state;
          _tryNavigate();
        }

        // SessionInitial: keep waiting, nothing to store yet
      },
      child: Scaffold(

        backgroundColor: const Color(0xFF0D0D14),
        body: Center(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _squareController,
              _dropController,
              _tiltController,
            ]),
            builder: (context, child) {
              return Transform(
                alignment: Alignment.bottomLeft,
                transform: Matrix4.rotationZ(_tiltAngle.value),
                child: _buildLogo(squareSize, borderRadius),
              );
            },
          ),
        ),
      ),
    );
  }


  Widget _buildLogo(double squareSize, double borderRadius) {
    return AnimatedBuilder(
      animation: _squareController,
      builder: (context, child) {
        return Transform.scale(
          scale: _squareScale.value,
          child: SizedBox(
            width: squareSize,
            height: squareSize,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: squareSize,
                  height: squareSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    gradient: AppColors.linerGradient,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9B59B6).withValues(alpha: 0.45),
                        blurRadius: 24,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                ),

                AnimatedBuilder(
                  animation: _dropController,
                  builder: (context, _) {
                    return Positioned.fill(
                      top: _arcOffsetY.value, // animates from -100 → 0
                      child: Opacity(
                        opacity: _arcOpacity.value,
                        child: const CustomPaint(
                          painter: ArcPainter(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}