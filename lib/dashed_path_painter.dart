import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashedPathPainter extends CustomPainter {
  final List<Offset> points;
  final double offset;
  final double dashWidth;
  final double dashSpace;
  final Color color;
  final double strokeWidth;

  DashedPathPainter(this.points, this.offset, this.dashWidth, this.dashSpace,
      this.color, this.strokeWidth)
      : assert(points.length > 1, 'At least two points are needed.');

  @override
  void paint(Canvas canvas, Size size) {
    final pPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final p = Path();

    var aX = points.first.dx;
    var aY = points.first.dy;
    p.moveTo(aX, aY);

    for (var i = 1; i < points.length; i++) {
      var bX = points[i].dx;
      var bY = points[i].dy;

      final lenAB = math.sqrt(math.pow(aX - bX, 2.0) + math.pow(aY - bY, 2.0));
      final bxExt = bX + (bX - aX) / lenAB * (strokeWidth / 2);
      final byExt = bY + (bY - aY) / lenAB * (strokeWidth / 2);

      // extend line by (strokewidth / 2) to overlap ends
      p.lineTo(bxExt, byExt);
      p.moveTo(bX, bY);

      aX = bX;
      aY = bY;
    }

    p.close();
    canvas.drawPath(
        _dashPath(p, [dashWidth, dashSpace], offset: offset), pPaint);
  }

  Path _dashPath(
    Path source,
    List<double> dash, {
    double offset = 0.5,
  }) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      var distance = offset;
      var draw = true;
      for (var i = 0; distance < metric.length; i = (i + 1) % dash.length) {
        final len = dash[i];
        if (draw) {
          dest.addPath(
              metric.extractPath(distance, distance + len), Offset.zero);
        }
        distance += len;
        draw = !draw;
      }
    }

    return dest;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
