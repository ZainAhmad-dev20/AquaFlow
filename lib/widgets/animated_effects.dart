import 'package:flutter/material.dart';

class FadeInAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration + delay,
      builder: (context, value, child) {
        final progress = delay == Duration.zero
            ? value
            : ((value * (duration + delay).inMilliseconds -
            delay.inMilliseconds) /
            duration.inMilliseconds)
            .clamp(0.0, 1.0);

        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - progress)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}