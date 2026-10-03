import 'package:flutter/material.dart';
import '../theme/aqua_colors.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openWelcome() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WelcomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
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
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _controller,
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.5,
                  end: 1,
                ).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeOutBack,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
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
                            color: AquaColors.cyan.withValues(alpha: 0.5),
                            blurRadius: 35,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.water_drop_rounded,
                        color: Colors.white,
                        size: 75,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'AquaFlow',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'EXPERIENCE THE FLOW',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 5,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 60),
                    ElevatedButton.icon(
                      onPressed: _openWelcome,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('GET STARTED'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AquaColors.cyan,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}