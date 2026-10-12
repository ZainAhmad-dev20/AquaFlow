
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import '../theme/aqua_colors.dart';
import 'dashboard_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _motion;
  late final AnimationController _entrance;

  bool _navigating = false;

  @override
  void initState() {
    super.initState();

    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();

    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();
  }

  @override
  void dispose() {
    _motion.dispose();
    _entrance.dispose();
    super.dispose();
  }

  void _explore() {
    if (_navigating) return;
    _navigating = true;

    Navigator.of(context)
        .pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 750),
        pageBuilder: (_, animation, secondaryAnimation) =>
        const DashboardScreen(),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final curve = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );

          return FadeTransition(
            opacity: curve,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.035),
                end: Offset.zero,
              ).animate(curve),
              child: child,
            ),
          );
        },
      ),
    )
        .then((_) {
      _navigating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030716),
      body: AnimatedBuilder(
        animation: Listenable.merge([_motion, _entrance]),
        builder: (context, child) {
          final t = _motion.value;
          final entry = Curves.easeOutCubic.transform(
            _entrance.value,
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              // Animated deep-space water background.
              CustomPaint(
                painter: _WelcomeBackgroundPainter(progress: t),
              ),

              Positioned(
                top: -125 + 25 * math.sin(t * math.pi * 2),
                right: -110,
                child: _AmbientGlow(
                  size: 300,
                  color: AquaColors.cyan.withValues(alpha: 0.16),
                ),
              ),

              Positioned(
                bottom: -130 + 25 * math.cos(t * math.pi * 2),
                left: -110,
                child: _AmbientGlow(
                  size: 330,
                  color: AquaColors.purple.withValues(alpha: 0.18),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    // Header.
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 22, 0),
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: 'Go back',
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'A Q U A F L O W',
                            style: TextStyle(
                              color: Color(0xFF9DDFF3),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 16,
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 440,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Animated holographic orb.
                                Transform.translate(
                                  offset: Offset(
                                    0,
                                    -5 * math.sin(t * math.pi * 2),
                                  ),
                                  child: SizedBox(
                                    width: 260,
                                    height: 260,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CustomPaint(
                                          size: const Size(260, 260),
                                          painter: _WelcomeOrbPainter(
                                            progress: t,
                                          ),
                                        ),

                                        // Glass-like central sphere.
                                        Container(
                                          width: 116,
                                          height: 116,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: const RadialGradient(
                                              center: Alignment(-0.35, -0.4),
                                              radius: 1.1,
                                              colors: [
                                                Color(0xFFE4FFFF),
                                                Color(0xFF64F2FF),
                                                Color(0xFF148BEF),
                                                Color(0xFF3824A0),
                                              ],
                                              stops: [0, 0.22, 0.64, 1],
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.65,
                                              ),
                                              width: 1.2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AquaColors.cyan
                                                    .withValues(
                                                  alpha: 0.32 +
                                                      0.15 *
                                                          math.sin(
                                                            t * math.pi * 2,
                                                          ),
                                                ),
                                                blurRadius: 42,
                                                spreadRadius: 7,
                                              ),
                                              const BoxShadow(
                                                color: Color(0x403C5BFF),
                                                blurRadius: 75,
                                                spreadRadius: 15,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.water_drop_rounded,
                                            size: 61,
                                            color: Colors.white,
                                          ),
                                        ),

                                        // Orbiting satellite.
                                        Transform.rotate(
                                          angle: t * math.pi * 2,
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Container(
                                              width: 11,
                                              height: 11,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AquaColors.cyan,
                                                    blurRadius: 18,
                                                    spreadRadius: 3,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 2),

                                // Staggered brand entrance.
                                _Entrance(
                                  progress: entry,
                                  delay: 0.12,
                                  child: ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                          colors: [
                                            Colors.white,
                                            Color(0xFF9AF8FF),
                                            Color(0xFF91A6FF),
                                          ],
                                        ).createShader(bounds),
                                    child: const Text(
                                      'Welcome to\nAquaFlow',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 35,
                                        height: 1.15,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.3,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                _Entrance(
                                  progress: entry,
                                  delay: 0.27,
                                  child: const Text(
                                    'A new dimension of digital interaction.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.6,
                                      color: Color(0xFFB8C9E8),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 30),

                                // Translucent glass information panel.
                                _Entrance(
                                  progress: entry,
                                  delay: 0.40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 14,
                                        sigmaY: 14,
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(19),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.white.withValues(
                                                alpha: 0.105,
                                              ),
                                              Colors.white.withValues(
                                                alpha: 0.025,
                                              ),
                                            ],
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(24),
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.16,
                                            ),
                                          ),
                                        ),
                                        child: const Row(
                                          children: [
                                            _FeatureIcon(
                                              icon: Icons.blur_on_rounded,
                                            ),
                                            SizedBox(width: 15),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'A living digital space',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                      FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(height: 6),
                                                  Text(
                                                    'Motion. Light. Fluidity.',
                                                    style: TextStyle(
                                                      color: Color(0xFF9BB8D9),
                                                      fontSize: 12,
                                                      letterSpacing: 0.6,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_outward_rounded,
                                              color: Color(0xFF83F5FF),
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 27),

                                _Entrance(
                                  progress: entry,
                                  delay: 0.55,
                                  child: _ExploreButton(
                                    progress: t,
                                    onTap: _explore,
                                  ),
                                ),

                                const SizedBox(height: 19),

                                const Text(
                                  'YOUR EXPERIENCE STARTS HERE',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 9,
                                    letterSpacing: 2.1,
                                    color: Color(0xFF7187AD),
                                  ),
                                ),

                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Entrance extends StatelessWidget {
  final double progress;
  final double delay;
  final Widget child;

  const _Entrance({
    required this.progress,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final value = ((progress - delay) / (1 - delay))
        .clamp(0.0, 1.0);

    final curved = Curves.easeOutCubic.transform(value);

    return Opacity(
      opacity: curved,
      child: Transform.translate(
        offset: Offset(0, 22 * (1 - curved)),
        child: child,
      ),
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  final IconData icon;

  const _FeatureIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 47,
      height: 47,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2DDCF4),
            Color(0xFF5068EF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF39CFFF).withValues(alpha: 0.25),
            blurRadius: 18,
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 25),
    );
  }
}

class _ExploreButton extends StatelessWidget {
  final double progress;
  final VoidCallback onTap;

  const _ExploreButton({
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pulse = 1 + 0.012 * math.sin(progress * math.pi * 2);

    return Transform.scale(
      scale: pulse,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(21),
          child: Ink(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF24DFF6),
                  Color(0xFF2879F4),
                  Color(0xFF6545DB),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF23CFFF).withValues(alpha: 0.23),
                  blurRadius: 27,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'EXPLORE AQUAFLOW',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 1.8,
                  ),
                ),
                SizedBox(width: 13),
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
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  final double size;
  final Color color;

  const _AmbientGlow({
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

class _WelcomeBackgroundPainter extends CustomPainter {
  final double progress;

  _WelcomeBackgroundPainter({required this.progress});

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
            Color(0xFF030716),
            Color(0xFF0A1737),
            Color(0xFF16103A),
            Color(0xFF030716),
          ],
        ).createShader(rect),
    );

    // Animated atmospheric light fields.
    for (var i = 0; i < 3; i++) {
      final center = Offset(
        size.width *
            (0.18 + i * 0.32 +
                0.09 * math.sin(progress * 2 * math.pi + i)),
        size.height *
            (0.20 + i * 0.27 +
                0.07 * math.cos(progress * 2 * math.pi + i)),
      );

      final radius = size.width * 0.29;

      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              (i.isEven ? AquaColors.cyan : AquaColors.purple)
                  .withValues(alpha: 0.09),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(center: center, radius: radius),
          ),
      );
    }

    // Flowing contour lines.
    for (var j = 0; j < 9; j++) {
      final path = Path();
      final baseY = size.height * (0.08 + j * 0.105);

      for (var step = 0; step <= 48; step++) {
        final x = size.width * step / 48;
        final y = baseY +
            12 * math.sin(
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
          ..strokeWidth = 0.7
          ..color = const Color(0xFF5DEAFF).withValues(alpha: 0.07),
      );
    }

    // Drifting luminous particles.
    for (var i = 0; i < 55; i++) {
      final seed = i.toDouble();
      final baseX = ((i * 37) % 101) / 101;
      final baseY = ((i * 61) % 103) / 103;

      final x = (baseX * size.width +
          15 * math.sin(progress * 2 * math.pi + seed)) %
          size.width;

      final y = (baseY * size.height -
          progress * size.height * (0.03 + (i % 4) * 0.012)) %
          size.height;

      final opacity = 0.25 +
          0.65 *
              (0.5 + 0.5 * math.sin(progress * 12 + seed));

      canvas.drawCircle(
        Offset(x, y < 0 ? y + size.height : y),
        0.8 + (i % 3) * 0.4,
        Paint()
          ..color = const Color(0xFF9CEFFF)
              .withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WelcomeBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _WelcomeOrbPainter extends CustomPainter {
  final double progress;

  _WelcomeOrbPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Pulsing halo.
    canvas.drawCircle(
      center,
      82 + 5 * math.sin(progress * math.pi * 2),
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF35E8FF).withValues(alpha: 0.16),
            const Color(0xFF5B65FF).withValues(alpha: 0.07),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: 100),
        ),
    );

    // Rotating holographic ellipses.
    for (var i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(
        progress * 2 * math.pi * (i.isEven ? 1 : -1) *
            (0.22 + i * 0.14),
      );

      final ring = Rect.fromCenter(
        center: Offset.zero,
        width: 142.0 + i * 30,
        height: 56.0 + i * 16,
      );

      canvas.drawOval(
        ring,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = const Color(0xFF6BEFFF)
              .withValues(alpha: 0.30 + i * 0.07),
      );

      canvas.drawArc(
        ring,
        progress * math.pi * 2 + i * 1.7,
        math.pi * 0.60,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFFB9FFFF),
      );

      final angle = progress * math.pi * 2 + i * 2.1;
      final point = Offset(
        math.cos(angle) * ring.width / 2,
        math.sin(angle) * ring.height / 2,
      );

      canvas.drawCircle(
        point,
        3,
        Paint()
          ..color = const Color(0xFF9DFFFF)
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            5,
          ),
      );

      canvas.restore();
    }

    // Fine interface markings.
    canvas.drawCircle(
      center,
      112,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6
        ..color = const Color(0xFF75DFFF).withValues(alpha: 0.22),
    );

    for (var i = 0; i < 32; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * math.pi / 16);

      canvas.drawLine(
        const Offset(0, -108),
        Offset(0, i % 4 == 0 ? -116 : -112),
        Paint()
          ..strokeWidth = i % 4 == 0 ? 1.5 : 0.7
          ..color = const Color(0xFF9AEFFF)
              .withValues(alpha: i % 4 == 0 ? 0.65 : 0.27),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _WelcomeOrbPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
