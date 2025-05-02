import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomCheckBox extends StatefulWidget {
  final bool isChecked; // Change to a simple bool
  final ValueChanged<bool> onChanged; // Callback to notify parent
  final double size;
  final Color fillColor;
  final Color borderColor;
  final Color checkColor;
  final Duration animationDuration;

  const CustomCheckBox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    this.size = 24.0,
    this.fillColor = AppColors.primary,
    this.borderColor = AppColors.primary,
    this.checkColor = Colors.white,
    this.animationDuration = const Duration(milliseconds: 150),
  });

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.animationDuration);

    // Initialize the animation state
    if (widget.isChecked) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CustomCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the animation if the checkbox state changes
    if (widget.isChecked != oldWidget.isChecked) {
      if (widget.isChecked) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Toggle the value and notify the change
        final newValue = !widget.isChecked;
        widget.onChanged(newValue);
      },
      child: AnimatedContainer(
        duration: widget.animationDuration,
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.isChecked ? widget.fillColor : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: widget.isChecked ? widget.borderColor : AppColors.primary,
            width: widget.isChecked ? 2 : 1.5,
          ),
        ),
        child: Center(
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _TickPainter(animation: _controller, color: widget.checkColor),
          ),
        ),
      ),
    );
  }
}

class _TickPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  _TickPainter({required this.animation, required this.color}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2.0;

    if (animation.value > 0.2) {
      Path path = Path();
      path.moveTo(size.width * 0.2, size.height * 0.55);
      path.lineTo(size.width * 0.45, size.height * 0.75);
      path.lineTo(size.width * 0.75, size.height * 0.3);

      PathMetrics pathMetrics = path.computeMetrics();
      for (var pathMetric in pathMetrics) {
        var extractPath = pathMetric.extractPath(0.0, pathMetric.length * animation.value);
        canvas.drawPath(extractPath, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
