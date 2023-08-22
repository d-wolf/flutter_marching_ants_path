import 'package:flutter/material.dart';
import 'dashed_path_painter.dart';

class DashedLineWidget extends StatefulWidget {
  final List<Offset> points;
  final Duration duration;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  final Color strokeColor;

  const DashedLineWidget(
      {required this.points,
      this.dashWidth = 10.0,
      this.dashSpace = 5.0,
      this.strokeWidth = 2.0,
      this.strokeColor = Colors.black,
      this.duration = const Duration(milliseconds: 500),
      super.key});

  @override
  State<DashedLineWidget> createState() => _DashedLineWidgetState();
}

class _DashedLineWidgetState extends State<DashedLineWidget>
    with SingleTickerProviderStateMixin {
  late final Animation<double> _animation;
  late final AnimationController _controller;
  late final Tween<double> _tween;

  @override
  void initState() {
    super.initState();

    _tween =
        Tween<double>(begin: 0.0, end: widget.dashWidth + widget.dashSpace);

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = _tween.animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _hasChanged() =>
      _tween.end != widget.dashWidth + widget.dashSpace ||
      _controller.duration != widget.duration;

  void _updateAnimation() {
    _controller.duration = widget.duration;
    _tween.end = widget.dashWidth + widget.dashSpace;
  }

  @override
  Widget build(BuildContext context) {
    if (_hasChanged()) {
      _updateAnimation();
    }

    return CustomPaint(
      painter: DashedPathPainter(
        widget.points,
        _animation.value,
        widget.dashWidth,
        widget.dashSpace,
        widget.strokeColor,
        widget.strokeWidth,
      ),
    );
  }
}
