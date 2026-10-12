
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import '../theme/aqua_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late final AnimationController _motion;
  late final AnimationController _entrance;

  int _selectedIndex = 0;

  final List<_Feature> _features = const [
    _Feature(
      icon: Icons.water_drop_rounded,
      title: 'Aqua Experience',
      subtitle: 'Immerse yourself in motion',
      tag: 'CORE',
      color: Color(0xFF36E7FF),
      description:
      'Your interactive liquid environment. This is where we will build '
          'the deeper water effects and reactive visual experiences.',
    ),
    _Feature(
      icon: Icons.auto_awesome_rounded,
      title: 'Discover',
      subtitle: 'Explore new possibilities',
      tag: 'EXPLORE',
      color: Color(0xFFAA91FF),
      description:
      'A dedicated space for future AquaFlow experiences, visual themes, '
          'and interactive discoveries.',
    ),
    _Feature(
      icon: Icons.tune_rounded,
      title: 'Settings',
      subtitle: 'Make it your own',
      tag: 'CONTROL',
      color: Color(0xFF69FFD6),
      description:
      'AquaFlow preferences will live here, including appearance, '
          'animation intensity, and personalization.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _motion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..forward();
  }

  @override
  void dispose() {
    _motion.dispose();
    _entrance.dispose();
    super.dispose();
  }

  void _openFeature(_Feature feature) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _FeatureSheet(feature: feature),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030716),
      extendBody: true,
      body: AnimatedBuilder(
        animation: Listenable.merge([_motion, _entrance]),
        builder: (context, child) {
          final t = _motion.value;
          final intro = Curves.easeOutCubic.transform(
            _entrance.value,
          );

          return Stack(
            children: [
              // Living background.
              Positioned.fill(
                child: CustomPaint(
                  painter: _DashboardBackgroundPainter(
                    progress: t,
                  ),
                ),
              ),

              Positioned(
                top: -130 + 24 * math.sin(t * math.pi * 2),
                right: -120,
                child: _Glow(
                  size: 320,
                  color: AquaColors.cyan.withValues(alpha: 0.13),
                ),
              ),

              Positioned(
                bottom: 80,
                left: -140 + 18 * math.cos(t * math.pi * 2),
                child: _Glow(
                  size: 330,
                  color: AquaColors.purple.withValues(alpha: 0.15),
                ),
              ),

              SafeArea(
                bottom: false,
                child: FadeTransition(
                  opacity: _entrance,
                  child: Transform.translate(
                    offset: Offset(0, 14 * (1 - intro)),
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // Custom app header.
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              22, 14, 22, 0,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF26DFF8),
                                        Color(0xFF4559D8),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AquaColors.cyan.withValues(
                                          alpha: 0.23,
                                        ),
                                        blurRadius: 22,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.water_drop_rounded,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 13),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'AquaFlow',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 21,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'YOUR DIGITAL UNIVERSE',
                                        style: TextStyle(
                                          color: Color(0xFF91B3D9),
                                          fontSize: 9,
                                          letterSpacing: 1.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(11),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(
                                      alpha: 0.055,
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.12,
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.blur_on_rounded,
                                    color: Color(0xFF82F5FF),
                                    size: 21,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Hero heading.
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              24, 36, 24, 0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _Eyebrow(
                                  label: 'PERSONAL CONTROL CENTER',
                                ),
                                const SizedBox(height: 13),
                                const Text(
                                  'Your world.\nIn motion.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    height: 1.12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.8,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'A new perspective on your digital space.',
                                  style: TextStyle(
                                    color: Colors.white.withValues(
                                      alpha: 0.64,
                                    ),
                                    fontSize: 13,
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Central animated energy core.
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Center(
                              child: SizedBox(
                                width: 300,
                                height: 280,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CustomPaint(
                                      size: const Size(300, 280),
                                      painter: _DashboardCorePainter(
                                        progress: t,
                                      ),
                                    ),

                                    Transform.translate(
                                      offset: Offset(
                                        0,
                                        4 * math.sin(t * math.pi * 2),
                                      ),
                                      child: Container(
                                        width: 104,
                                        height: 104,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const RadialGradient(
                                            center: Alignment(-0.35, -0.4),
                                            colors: [
                                              Color(0xFFE9FFFF),
                                              Color(0xFF68F5FF),
                                              Color(0xFF1686F5),
                                              Color(0xFF3422A3),
                                            ],
                                            stops: [0, 0.22, 0.63, 1],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AquaColors.cyan
                                                  .withValues(
                                                alpha: 0.35 +
                                                    0.12 *
                                                        math.sin(
                                                          t * math.pi * 2,
                                                        ),
                                              ),
                                              blurRadius: 38,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.water_drop_rounded,
                                          color: Colors.white,
                                          size: 52,
                                        ),
                                      ),
                                    ),

                                    // Live status label.
                                    Positioned(
                                      bottom: 12,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 9,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0B1830)
                                              .withValues(alpha: 0.88),
                                          borderRadius:
                                          BorderRadius.circular(30),
                                          border: Border.all(
                                            color: AquaColors.cyan
                                                .withValues(alpha: 0.35),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF5DFFD1),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 9),
                                            const Text(
                                              'AQUA CORE ACTIVE',
                                              style: TextStyle(
                                                color: Color(0xFFB4F8FF),
                                                fontSize: 9,
                                                letterSpacing: 1.7,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Section heading.
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              22, 12, 22, 17,
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Explore your space',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Text(
                                  '03 MODULES',
                                  style: TextStyle(
                                    color: AquaColors.cyan.withValues(
                                      alpha: 0.85,
                                    ),
                                    fontSize: 9,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Animated interactive feature cards.
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                final feature = _features[index];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 13,
                                  ),
                                  child: _AnimatedFeatureCard(
                                    feature: feature,
                                    index: index,
                                    progress: t,
                                    onTap: () => _openFeature(feature),
                                  ),
                                );
                              },
                              childCount: _features.length,
                            ),
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              22, 6, 22, 125,
                            ),
                            child: Center(
                              child: Text(
                                'DESIGNED TO MOVE WITH YOU',
                                style: TextStyle(
                                  color: Colors.white.withValues(
                                    alpha: 0.32,
                                  ),
                                  fontSize: 9,
                                  letterSpacing: 2.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),

      // Floating glass navigation.
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF101A36).withValues(alpha: 0.90),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  children: [
                    _NavItem(
                      icon: Icons.grid_view_rounded,
                      label: 'Home',
                      selected: _selectedIndex == 0,
                      onTap: () => setState(() => _selectedIndex = 0),
                    ),
                    _NavItem(
                      icon: Icons.explore_rounded,
                      label: 'Discover',
                      selected: _selectedIndex == 1,
                      onTap: () {
                        setState(() => _selectedIndex = 1);
                        _openFeature(_features[1]);
                      },
                    ),
                    _NavItem(
                      icon: Icons.water_drop_rounded,
                      label: 'Aqua Core',
                      selected: _selectedIndex == 2,
                      onTap: () {
                        setState(() => _selectedIndex = 2);
                        _openFeature(_features[0]);
                      },
                    ),
                    _NavItem(
                      icon: Icons.tune_rounded,
                      label: 'Settings',
                      selected: _selectedIndex == 3,
                      onTap: () {
                        setState(() => _selectedIndex = 3);
                        _openFeature(_features[2]);
                      },
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

class _Feature {
  final IconData icon;
  final String title;
  final String subtitle;
  final String tag;
  final Color color;
  final String description;

  const _Feature({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.color,
    required this.description,
  });
}

class _AnimatedFeatureCard extends StatelessWidget {
  final _Feature feature;
  final int index;
  final double progress;
  final VoidCallback onTap;

  const _AnimatedFeatureCard({
    required this.feature,
    required this.index,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pulse = 0.5 + 0.5 * math.sin(
      progress * math.pi * 2 + index * 1.5,
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 650 + index * 150),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(23),
          child: Ink(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.085),
                  Colors.white.withValues(alpha: 0.025),
                ],
              ),
              border: Border.all(
                color: feature.color.withValues(
                  alpha: 0.18 + 0.15 * pulse,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: feature.color.withValues(
                    alpha: 0.035 + 0.035 * pulse,
                  ),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        feature.color.withValues(alpha: 0.95),
                        feature.color.withValues(alpha: 0.30),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: feature.color.withValues(alpha: 0.16),
                        blurRadius: 18,
                      ),
                    ],
                  ),
                  child: Icon(
                    feature.icon,
                    color: Colors.white,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature.tag,
                        style: TextStyle(
                          color: feature.color,
                          fontSize: 8,
                          letterSpacing: 1.7,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        feature.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        feature.subtitle,
                        style: const TextStyle(
                          color: Color(0xFF9BAED0),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: feature.color.withValues(alpha: 0.85),
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

class _FeatureSheet extends StatelessWidget {
  final _Feature feature;

  const _FeatureSheet({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        30 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1430),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        border: Border.all(
          color: feature.color.withValues(alpha: 0.28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 26),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                gradient: LinearGradient(
                  colors: [
                    feature.color,
                    feature.color.withValues(alpha: 0.35),
                  ],
                ),
              ),
              child: Icon(
                feature.icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              feature.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              feature.description,
              style: const TextStyle(
                color: Color(0xFFB5C5E1),
                fontSize: 14,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: feature.color.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: feature.color.withValues(alpha: 0.20),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.construction_rounded,
                    color: feature.color,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Feature module not connected yet',
                      style: TextStyle(
                        color: Color(0xFFD6E8FF),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: feature.color,
                  foregroundColor: const Color(0xFF061024),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('BACK TO DASHBOARD'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? const Color(0xFF76F4FF)
        : const Color(0xFF8294B5);

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(
                horizontal: 3,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF2DDDF4).withValues(alpha: 0.10)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    scale: selected ? 1.12 : 1.0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      icon,
                      color: color,
                      size: 21,
                    ),
                  ),
                  const SizedBox(height: 5),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontSize: 9,
                        fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  final String label;

  const _Eyebrow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 2,
          color: const Color(0xFF63F0FF),
        ),
        const SizedBox(width: 9),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8DDCF3),
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
          ),
        ),
      ],
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
              color.withValues(alpha: 0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardBackgroundPainter extends CustomPainter {
  final double progress;

  _DashboardBackgroundPainter({required this.progress});

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
            Color(0xFF091633),
            Color(0xFF120D31),
            Color(0xFF030716),
          ],
        ).createShader(rect),
    );

    // Moving atmospheric light fields.
    for (var i = 0; i < 3; i++) {
      final center = Offset(
        size.width *
            (0.18 + i * 0.32 +
                0.09 * math.sin(progress * 2 * math.pi + i)),
        size.height *
            (0.20 + i * 0.26 +
                0.07 * math.cos(progress * 2 * math.pi + i)),
      );

      final radius = size.width * 0.28;

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

    // Fluid contour lines.
    for (var j = 0; j < 9; j++) {
      final path = Path();
      final baseY = size.height * (0.06 + j * 0.105);

      for (var step = 0; step <= 40; step++) {
        final x = size.width * step / 40;
        final y = baseY +
            12 * math.sin(
              x / size.width * math.pi * 2 +
                  progress * math.pi * 2 +
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
          ..color = const Color(0xFF6AEAFF).withValues(alpha: 0.055),
      );
    }

    // Drifting particles.
    for (var i = 0; i < 48; i++) {
      final seed = i.toDouble();
      final baseX = ((i * 37) % 101) / 101;
      final baseY = ((i * 61) % 103) / 103;

      final x = (baseX * size.width +
          13 * math.sin(progress * 2 * math.pi + seed)) %
          size.width;

      final y = (baseY * size.height -
          progress * size.height * (0.025 + (i % 4) * 0.01)) %
          size.height;

      final alpha = 0.25 +
          0.65 * (0.5 + 0.5 * math.sin(progress * 12 + seed));

      canvas.drawCircle(
        Offset(x, y < 0 ? y + size.height : y),
        0.7 + (i % 3) * 0.35,
        Paint()
          ..color = const Color(0xFF9CEFFF)
              .withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashboardBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _DashboardCorePainter extends CustomPainter {
  final double progress;

  _DashboardCorePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 4);

    canvas.drawCircle(
      center,
      78 + 5 * math.sin(progress * math.pi * 2),
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF35E8FF).withValues(alpha: 0.17),
            const Color(0xFF5B65FF).withValues(alpha: 0.07),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: 95),
        ),
    );

    // Three animated energy orbits.
    for (var i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(
        progress * 2 * math.pi * (i.isEven ? 1 : -1) *
            (0.24 + i * 0.13),
      );

      final ring = Rect.fromCenter(
        center: Offset.zero,
        width: 140.0 + i * 32,
        height: 54.0 + i * 17,
      );

      canvas.drawOval(
        ring,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.9
          ..color = const Color(0xFF6BEFFF)
              .withValues(alpha: 0.30 + i * 0.06),
      );

      canvas.drawArc(
        ring,
        progress * 2 * math.pi + i * 1.9,
        math.pi * 0.57,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFFC2FFFF),
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
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );

      canvas.restore();
    }

    // Fine interface markings.
    canvas.drawCircle(
      center,
      110,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.6
        ..color = const Color(0xFF75DFFF).withValues(alpha: 0.19),
    );

    for (var i = 0; i < 32; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * math.pi / 16);

      canvas.drawLine(
        const Offset(0, -106),
        Offset(0, i % 4 == 0 ? -114 : -110),
        Paint()
          ..strokeWidth = i % 4 == 0 ? 1.4 : 0.7
          ..color = const Color(0xFF9AEFFF)
              .withValues(alpha: i % 4 == 0 ? 0.62 : 0.25),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _DashboardCorePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
