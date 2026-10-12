
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/aqua_colors.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _ambientController;
  late final AnimationController _introController;

  bool _opening = false;

  @override
  void initState() {
    super.initState();

    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
  }

  @override
  void dispose() {
    _ambientController.dispose();
    _introController.dispose();
    super.dispose();
  }

  void _openWelcome() {
    if (_opening) return;
    _opening = true;

    Navigator.of(context)
        .push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 900),
        pageBuilder: (_, animation, secondaryAnimation) =>
        const WelcomeScreen(),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );

          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.035),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    )
        .then((_) {
      _opening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030817),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _ambientController,
          _introController,
        ]),
        builder: (context, child) {
          final t = _ambientController.value;
          final intro = Curves.easeOutCubic.transform(
            _introController.value,
          );

          final scale = 0.82 +
              0.18 *
                  Curves.easeOutBack.transform(
                    _introController.value,
                  );

          return Stack(
            fit: StackFit.expand,
            children: [
              // Continuously animated cosmic water environment.
              CustomPaint(
                painter: _AquaEnvironmentPainter(progress: t),
              ),

              // Soft moving light fields.
              Positioned(
                top: -130 + 24 * math.sin(t * math.pi * 2),
                right: -100,
                child: _Glow(
                  size: 300,
                  color: AquaColors.cyan.withValues(alpha: 0.13),
                ),
              ),

              Positioned(
                bottom: -150 + 20 * math.cos(t * math.pi * 2),
                left: -100,
                child: _Glow(
                  size: 350,
                  color: AquaColors.purple.withValues(alpha: 0.17),
                ),
              ),

              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 28,
                    ),
                    child: Opacity(
                      opacity: intro.clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: scale,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 440,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),

                              // Animated holographic AquaFlow core.
                              SizedBox(
                                width: 280,
                                height: 280,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CustomPaint(
                                      size: const Size(280, 280),
                                      painter: _EnergyCorePainter(
                                        progress: t,
                                      ),
                                    ),

                                    // Central luminous orb.
                                    Container(
                                      width: 112,
                                      height: 112,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const RadialGradient(
                                          center: Alignment(-0.35, -0.45),
                                          radius: 1.15,
                                          colors: [
                                            Color(0xFFE6FFFF),
                                            Color(0xFF53F4FF),
                                            Color(0xFF147CFA),
                                            Color(0xFF3420A8),
                                          ],
                                          stops: [0.0, 0.22, 0.63, 1.0],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AquaColors.cyan
                                                .withValues(alpha: 0.48),
                                            blurRadius:
                                            32 + 10 * math.sin(t * 6.28),
                                            spreadRadius: 4,
                                          ),
                                          BoxShadow(
                                            color: AquaColors.blue
                                                .withValues(alpha: 0.38),
                                            blurRadius: 65,
                                            spreadRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.water_drop_rounded,
                                        size: 57,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color: Color(0xFF00F5FF),
                                            blurRadius: 18,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Orbiting energy point.
                                    Transform.rotate(
                                      angle: t * math.pi * 2,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          width: 9,
                                          height: 9,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AquaColors.cyan,
                                                blurRadius: 16,
                                                spreadRadius: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Brand identity.
                              ShaderMask(
                                shaderCallback: (bounds) {
                                  return const LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Color(0xFF9AF8FF),
                                      Color(0xFF7C9DFF),
                                    ],
                                  ).createShader(bounds);
                                },
                                child: const Text(
                                  'AquaFlow',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 43,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 2.2,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 13),

                              const Text(
                                'REDEFINING THE DIGITAL FLOW',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 4.0,
                                  color: Color(0xFFA7DFF8),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 28),

                              // Animated status indicator.
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF58FFD2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF58FFD2)
                                              .withValues(
                                            alpha: 0.4 +
                                                0.6 *
                                                    math.sin(t * math.pi * 2)
                                                        .abs(),
                                          ),
                                          blurRadius: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 9),
                                  const Text(
                                    'SYSTEM ONLINE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      letterSpacing: 2.5,
                                      color: Color(0xFF85D8D5),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 34),

                              // Breathing glass-style action button.
                              Transform.scale(
                                scale: 1.0 + 0.018 * math.sin(t * math.pi * 2),
                                child: GestureDetector(
                                  onTap: _openWelcome,
                                  child: Container(
                                    width: double.infinity,
                                    constraints: const BoxConstraints(
                                      maxWidth: 330,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 22,
                                      vertical: 19,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF20DDF7),
                                          Color(0xFF267BF5),
                                          Color(0xFF6245D9),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.30,
                                        ),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AquaColors.cyan
                                              .withValues(alpha: 0.25),
                                          blurRadius: 30,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'ENTER AQUAFLOW',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 2.1,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 22),

                              const Text(
                                'IMMERSE YOURSELF IN THE FUTURE',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 9,
                                  letterSpacing: 2,
                                  color: Color(0xFF788AAE),
                                ),
                              ),

                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final double size;
  final Color color;

  const _Glow({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0.35),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

// Draws a continuously moving particle field and flowing light trails.
class _AquaEnvironmentPainter extends CustomPainter {
  final double progress;

  _AquaEnvironmentPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF030817),
            Color(0xFF081532),
            Color(0xFF100C2D),
            Color(0xFF030817),
          ],
          stops: [0.0, 0.36, 0.72, 1.0],
        ).createShader(rect),
    );

    // Slowly shifting atmospheric glow.
    for (var i = 0; i < 3; i++) {
      final x = size.width *
          (0.18 +
              0.32 * i +
              0.10 * math.sin(progress * 2 * math.pi + i));
      final y = size.height *
          (0.20 +
              0.28 * i +
              0.08 * math.cos(progress * 2 * math.pi + i));

      canvas.drawCircle(
        Offset(x, y),
        size.width * 0.30,
        Paint()
          ..shader = RadialGradient(
            colors: [
              (i.isEven ? AquaColors.cyan : AquaColors.purple)
                  .withValues(alpha: 0.09),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(x, y),
              radius: size.width * 0.30,
            ),
          ),
      );
    }

    // Flowing contour lines.
    for (var j = 0; j < 7; j++) {
      final path = Path();
      final baseY = size.height * (0.18 + j * 0.105);

      for (var step = 0; step <= 40; step++) {
        final x = size.width * step / 40;
        final y = baseY +
            13 *
                math.sin(
                  x / size.width * math.pi * 2 +
                      progress * 2 * math.pi +
                      j * 0.65,
                );

        if (step == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.65
          ..color = const Color(0xFF5AEFFF).withValues(alpha: 0.065),
      );
    }

    // Deterministic particles: no random regeneration on each frame.
    for (var i = 0; i < 64; i++) {
      final seed = i.toDouble();
      final baseX = ((i * 37) % 101) / 101;
      final baseY = ((i * 61) % 103) / 103;

      final x = (baseX * size.width +
          18 * math.sin(progress * 2 * math.pi + seed)) %
          size.width;

      final y = (baseY * size.height -
          progress * size.height * (0.035 + (i % 4) * 0.012)) %
          size.height;

      final twinkle =
          0.25 + 0.75 * (0.5 + 0.5 * math.sin(progress * 12 + seed));

      final radius = 0.7 + (i % 3) * 0.45;

      canvas.drawCircle(
        Offset(x, y < 0 ? y + size.height : y),
        radius,
        Paint()
          ..color = (i % 3 == 0
              ? const Color(0xFF9BFFFF)
              : const Color(0xFF658EFF))
              .withValues(alpha: twinkle * 0.75),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AquaEnvironmentPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Holographic rings, orbiting points and energy arcs.
class _EnergyCorePainter extends CustomPainter {
  final double progress;

  _EnergyCorePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Soft halo.
    canvas.drawCircle(
      center,
      86 + 4 * math.sin(progress * 2 * math.pi),
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF26DFFF).withValues(alpha: 0.17),
            const Color(0xFF5266FF).withValues(alpha: 0.07),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: 100),
        ),
    );

    // Three differently oriented energy rings.
    for (var i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(
        progress * 2 * math.pi * (i.isEven ? 1 : -1) * (i + 1) * 0.28,
      );

      final ringRect = Rect.fromCenter(
        center: Offset.zero,
        width: 145.0 + i * 34,
        height: 57.0 + i * 18,
      );

      canvas.drawOval(
        ringRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = i == 1 ? 1.5 : 0.9
          ..color = (i == 1
              ? const Color(0xFF70F9FF)
              : const Color(0xFF637FFF))
              .withValues(alpha: i == 1 ? 0.65 : 0.36),
      );

      // Segmented energy arc.
      canvas.drawArc(
        ringRect,
        progress * 2 * math.pi + i,
        math.pi * 0.58,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2.2
          ..color = const Color(0xFFB4FFFF).withValues(alpha: 0.9),
      );

      // Glowing orbital point.
      final angle = progress * 2 * math.pi + i * 2.1;
      final point = Offset(
        math.cos(angle) * ringRect.width / 2,
        math.sin(angle) * ringRect.height / 2,
      );

      canvas.drawCircle(
        point,
        3.0,
        Paint()
          ..color = Colors.white
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );

      canvas.drawCircle(
        point,
        1.8,
        Paint()..color = const Color(0xFFDBFFFF),
      );

      canvas.restore();
    }

    // Fine circular interface markings.
    canvas.drawCircle(
      center,
      112,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6
        ..color = const Color(0xFF62CFFF).withValues(alpha: 0.22),
    );

    for (var i = 0; i < 32; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * math.pi / 16);

      canvas.drawLine(
        const Offset(0, -108),
        Offset(0, i % 4 == 0 ? -117 : -112),
        Paint()
          ..strokeWidth = i % 4 == 0 ? 1.5 : 0.7
          ..color = const Color(0xFF9AEFFF)
              .withValues(alpha: i % 4 == 0 ? 0.7 : 0.3),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _EnergyCorePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
