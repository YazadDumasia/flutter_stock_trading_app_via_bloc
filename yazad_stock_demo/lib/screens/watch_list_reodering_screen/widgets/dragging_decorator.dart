import 'dart:ui';
import 'package:flutter/material.dart';

class DraggingDecorator extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const DraggingDecorator({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(1, 6, animValue)!;
        final double scale = lerpDouble(1, 1.02, animValue)!;
        return Transform.scale(
          scale: scale,
          child: Card(
            elevation: elevation,
            color: Colors.white,
            child: this.child,
          ),
        );
      },
    );
  }
}
