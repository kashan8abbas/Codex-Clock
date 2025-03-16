import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';

class CustomCircularIndicator extends StatelessWidget {
  final double progressValue; // From 0 to 1

  const CustomCircularIndicator({Key? key, required this.progressValue})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child:
          progressValue >= 1.0
              ? SvgPicture.asset(
                'lib/Utils/Images/Logo.svg',
              ) // ✅ Your Uploaded Image
              : CustomPaint(painter: _CircularProgressPainter(progressValue)),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;

  _CircularProgressPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    // Background circle
    final backgroundPaint =
        Paint()
          ..color = Colors.grey.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Gradient for Progress Indicator
    final gradient = SweepGradient(
      startAngle: 3 * pi / 2,
      endAngle: 3 * pi / 2 + 2 * pi,
      colors: [
        Colors.red,
        Colors.pinkAccent,
        Colors.white.withOpacity(0.1), // For fade effect
      ],
    );

    final progressPaint =
        Paint()
          ..shader = gradient.createShader(
            Rect.fromCircle(center: center, radius: radius),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round; // ✅ For rounded edges

    final progressAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3 * pi / 2, // Start from top
      progressAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
