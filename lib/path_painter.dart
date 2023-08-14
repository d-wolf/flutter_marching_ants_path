import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final List<Offset> points;
  final double offset;
  final double dashWidth;
  final double dashSpace;
  final Color color;
  final double strokeWidth;

  DashedLinePainter(this.points, this.offset, this.dashWidth, this.dashSpace,
      this.color, this.strokeWidth)
      : assert(points.length > 1, 'At least two points are needed.');

  @override
  void paint(Canvas canvas, Size size) {
    final pPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final p = Path();
    p.moveTo(points.first.dx, points.first.dy);

    for (var i = 1; i < points.length; i++) {
      p.lineTo(points[i].dx, points[i].dy);
      p.moveTo(points[i].dx, points[i].dy);
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
      for (int i = 0; distance < metric.length; i = (i + 1) % dash.length) {
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
