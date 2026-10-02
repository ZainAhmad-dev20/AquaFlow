import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const AquaFlowApp());
}

class AquaFlowApp extends StatelessWidget {
  const AquaFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF080D27),
      ),
      home: const SplashScreen(),
    );
  }
}

// =====================================================
// COLORS
// =====================================================

class AquaColors {
  static const background = Color(0xFF080D27);
  static const darkBlue = Color(0xFF15164A);
  static const purple = Color(0xFF321B68);
  static const cyan = Color(0xFF00D9FF);
  static const blue = Color(0xFF645BFF);
}

// =====================================================
// ANIMATED SPLASH SCREEN
// =====================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _bubbleController;
  late final AnimationController _glowController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.2,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeIn,
    );

    _introController.forward();
  }

  @override
  void dispose() {
    _introController.dispose();
    _bubbleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _openWelcome() {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const WelcomeScreen();
        },
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.85,
                end: 1,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AquaColors.background,
                    AquaColors.darkBlue,
                    AquaColors.purple,
                    AquaColors.background,
                  ],
                ),
              ),
            ),
          ),

          // Floating bubbles
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bubbleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: BubblePainter(
                    progress: _bubbleController.value,
                  ),
                );
              },
            ),
          ),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Glowing logo
                        AnimatedBuilder(
                          animation: _glowController,
                          builder: (context, child) {
                            final glow = _glowController.value;

                            return Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    AquaColors.cyan,
                                    AquaColors.blue,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AquaColors.cyan.withOpacity(
                                      0.2 + glow * 0.4,
                                    ),
                                    blurRadius: 25 + glow * 30,
                                    spreadRadius: 3 + glow * 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.water_drop_rounded,
                                color: Colors.white,
                                size: 78,
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 32),

                        // App name
                        const Text(
                          'AquaFlow',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'EXPERIENCE THE FLOW',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 5,
                            color: Colors.white.withOpacity(0.65),
                          ),
                        ),

                        const SizedBox(height: 65),

                        // Animated button
                        LiquidButton(
                          text: 'GET STARTED',
                          icon: Icons.arrow_forward_rounded,
                          onPressed: _openWelcome,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom text
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SafeArea(
              child: IgnorePointer(
                child: Center(
                  child: Text(
                    'MADE WITH FLUTTER',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 3,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// FLOATING BUBBLES
// =====================================================

class BubblePainter extends CustomPainter {
  final double progress;

  BubblePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);

    for (int i = 0; i < 40; i++) {
      final x = random.nextDouble() * size.width;
      final initialY = random.nextDouble() * size.height;
      final radius = 2 + random.nextDouble() * 9;
      final speed = 0.5 + random.nextDouble();

      final y = (initialY -
          progress * size.height * speed * 1.5) %
          size.height;

      final opacity = 0.06 + random.nextDouble() * 0.13;

      final center = Offset(x, y);

      final fillPaint = Paint()
        ..color = Colors.white.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = Colors.white.withOpacity(opacity + 0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;

      canvas.drawCircle(center, radius, fillPaint);
      canvas.drawCircle(center, radius, borderPaint);

      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.2);

      canvas.drawCircle(
        Offset(x - radius * 0.3, y - radius * 0.3),
        radius * 0.18,
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BubblePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// =====================================================
// REUSABLE LIQUID BUTTON
// =====================================================

class LiquidButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;

  const LiquidButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon = Icons.arrow_forward_rounded,
  });

  @override
  State<LiquidButton> createState() => _LiquidButtonState();
}

class _LiquidButtonState extends State<LiquidButton>
    with TickerProviderStateMixin {
  late final AnimationController _pressController;
  late final AnimationController _rippleController;

  late final Animation<double> _scaleAnimation;

  Offset _ripplePosition = Offset.zero;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 450),
    );

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _scaleAnimation = Tween<double>(
      begin: 1,
      end: 0.90,
    ).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOut,
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
      _ripplePosition = details.localPosition;
    });

    _pressController.forward();
    _rippleController.forward(from: 0);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });

    _pressController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });

    _pressController.reverse();
  }

  @override
  void dispose() {
    _pressController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.text,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _pressController,
            _rippleController,
          ]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 200,
                  minHeight: 60,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 17,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    _isPressed ? 30 : 22,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _isPressed
                        ? const [
                      Color(0xFF00B4D8),
                      Color(0xFF5145CD),
                    ]
                        : const [
                      AquaColors.cyan,
                      AquaColors.blue,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AquaColors.cyan.withOpacity(
                        _isPressed ? 0.12 : 0.38,
                      ),
                      blurRadius: _isPressed ? 10 : 25,
                      spreadRadius: _isPressed ? 0 : 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: RipplePainter(
                            progress: _rippleController.value,
                            center: _ripplePosition,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// =====================================================
// RIPPLE EFFECT
// =====================================================

class RipplePainter extends CustomPainter {
  final double progress;
  final Offset center;

  RipplePainter({
    required this.progress,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) {
      return;
    }

    final maxRadius = math.sqrt(
      size.width * size.width +
          size.height * size.height,
    );

    final radius = progress * maxRadius;

    final paint = Paint()
      ..color = Colors.white.withOpacity(
        (1 - progress) * 0.45,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * (1 - progress);

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant RipplePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.center != center;
  }
}

// =====================================================
// WELCOME SCREEN
// =====================================================

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Welcome to AquaFlow! More features coming soon.',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AquaColors.blue,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: AquaBackground(child: SizedBox.expand()),
          ),

          const Positioned.fill(
            child: _WelcomeBubbles(),
          ),

          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 4,
                  left: 8,
                  child: IconButton(
                    tooltip: 'Back',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),

                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 115,
                              height: 115,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    AquaColors.cyan,
                                    AquaColors.blue,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AquaColors.cyan.withOpacity(0.35),
                                    blurRadius: 35,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.water_drop_rounded,
                                size: 70,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 35),

                            const Text(
                              'Welcome to AquaFlow',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              'Discover a new world of fluid interactions.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.6,
                                color: Colors.white.withOpacity(0.65),
                              ),
                            ),

                            const SizedBox(height: 45),

                            LiquidButton(
                              text: 'EXPLORE',
                              icon: Icons.explore_rounded,
                              onPressed: _showMessage,
                            ),

                            const SizedBox(height: 25),

                            Text(
                              'A NEW WAY TO EXPERIENCE ANIMATIONS',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 9,
                                letterSpacing: 2,
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
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
      ),
    );
  }
}

// =====================================================
// WELCOME SCREEN BUBBLES
// =====================================================

class _WelcomeBubbles extends StatefulWidget {
  const _WelcomeBubbles();

  @override
  State<_WelcomeBubbles> createState() => _WelcomeBubblesState();
}

class _WelcomeBubblesState extends State<_WelcomeBubbles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BubblePainter(
            progress: _controller.value,
          ),
        );
      },
    );
  }
}
