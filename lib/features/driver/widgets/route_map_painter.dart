import 'dart:math' as math;

import 'package:flutter/material.dart';

class RouteMapPainter extends CustomPainter {
  RouteMapPainter({required this.hasTrip});

  final bool hasTrip;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFE6EDF5),
    );

    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.92)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final smallRoadPaint = Paint()
      ..color = const Color(0xFFD0D9E7)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (var i = 0; i < 5; i++) {
      final y = size.height * (0.18 + i * 0.16);
      canvas.drawLine(
        Offset(-30, y),
        Offset(size.width + 30, y + (i.isEven ? 30 : -20)),
        smallRoadPaint,
      );
    }

    final route = Path()
      ..moveTo(size.width * 0.12, size.height * 0.78)
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.62,
        size.width * 0.26,
        size.height * 0.42,
        size.width * 0.46,
        size.height * 0.45,
      )
      ..cubicTo(
        size.width * 0.68,
        size.height * 0.48,
        size.width * 0.62,
        size.height * 0.22,
        size.width * 0.86,
        size.height * 0.18,
      );

    canvas.drawPath(route, roadPaint);
    canvas.drawPath(
      route,
      Paint()
        ..color = hasTrip ? const Color(0xFF416FDF) : const Color(0xFF94A3B8)
        ..strokeWidth = 7
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    _drawPin(
      canvas,
      Offset(size.width * 0.12, size.height * 0.78),
      const Color(0xFF12A87E),
    );
    _drawPin(
      canvas,
      Offset(size.width * 0.86, size.height * 0.18),
      const Color(0xFFEF4444),
    );
    _drawCar(canvas, Offset(size.width * 0.43, size.height * 0.46));
  }

  void _drawPin(Canvas canvas, Offset center, Color color) {
    canvas.drawCircle(center, 14, Paint()..color = Colors.white);
    canvas.drawCircle(center, 8, Paint()..color = color);
  }

  void _drawCar(Canvas canvas, Offset center) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 9);
    final rect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-18, -12, 36, 24),
      const Radius.circular(8),
    );
    canvas.drawRRect(rect, Paint()..color = const Color(0xFF172033));
    canvas.drawCircle(const Offset(-10, 12), 4, Paint()..color = Colors.white);
    canvas.drawCircle(const Offset(10, 12), 4, Paint()..color = Colors.white);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant RouteMapPainter oldDelegate) {
    return oldDelegate.hasTrip != hasTrip;
  }
}
