import 'dart:ui';

import 'package:flutter/material.dart';

import '../utils.dart';

enum SnackBarType { success, fail, alert }

class IconSnackBar {
  static void show(
    BuildContext context, {
    required String label,
    required SnackBarType snackBarType,
    Duration? duration,
    DismissDirection? direction,
    SnackBarBehavior behavior = SnackBarBehavior.fixed,
    Color? backgroundColor,
    Color iconColor = Colors.white,
    TextStyle labelTextStyle = const TextStyle(),
    int? maxLines,
  }) {
    final snackBar = SnackBar(
      duration: duration ?? const Duration(seconds: 2),
      dismissDirection: direction ?? DismissDirection.down,
      behavior: behavior,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: SnackBarWidget(
        onPressed: () => ScaffoldMessenger.of(context).removeCurrentSnackBar(),
        label: label,
        backgroundColor: backgroundColor ?? _getBackgroundColor(snackBarType),
        labelTextStyle: labelTextStyle,
        iconType: _getIconType(snackBarType),
        maxLines: maxLines,
        color: iconColor,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Color _getBackgroundColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return Colors.green;
      case SnackBarType.fail:
        return Colors.red;
      case SnackBarType.alert:
        return Colors.black;
    }
  }

  static IconType _getIconType(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return IconType.check;
      case SnackBarType.fail:
        return IconType.fail;
      case SnackBarType.alert:
        return IconType.alert;
    }
  }
}

class SnackBarWidget extends StatefulWidget implements SnackBarAction {
  const SnackBarWidget({
    super.key,
    required this.iconType,
    required this.label,
    required this.onPressed,
    this.textColor,
    this.disabledTextColor,
    this.backgroundColor = Colors.black,
    this.labelTextStyle,
    this.disabledBackgroundColor = Colors.black,
    this.maxLines,
    this.color,
  });

  @override
  final Color? textColor;

  @override
  final Color? disabledTextColor;

  @override
  final String label;

  @override
  final VoidCallback onPressed;

  @override
  final Color backgroundColor;

  @override
  final Color disabledBackgroundColor;

  final TextStyle? labelTextStyle;
  final IconType iconType;
  final int? maxLines;
  final Color? color;

  @override
  State<SnackBarWidget> createState() => _SnackBarWidgetState();
}

class _SnackBarWidgetState extends State<SnackBarWidget> {
  var _fadeAnimationStart = false;
  var disposed = false;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!disposed) {
        setState(() {
          _fadeAnimationStart = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(15),
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          color: widget.backgroundColor,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 200),
          child: SizedBox(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Utils().withOpacity(color: Colors.white, opacity: 0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: IconAnimated(
                      color: _fadeAnimationStart ? widget.color : widget.backgroundColor,
                      active: true,
                      size: 40,
                      iconType: widget.iconType,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: AnimatedContainer(
                    margin: EdgeInsets.only(left: _fadeAnimationStart ? 0 : 10),
                    duration: const Duration(milliseconds: 200),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _fadeAnimationStart ? 1.0 : 0.0,
                      child: Text(
                        widget.label,
                        overflow: TextOverflow.ellipsis,
                        maxLines: widget.maxLines,
                        style: widget.labelTextStyle ?? const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}

enum IconType {
  check,
  fail,
  alert,
  error,
  trendingUp,
  trendingDown,
  search,
  message,
  add,
  download,
  menu,
  sort,
  bluetooth,
  filter,
}

class IconAnimated extends StatefulWidget {
  final bool active;
  final double size;
  final Color? color;
  final double? strokeWidth;
  final IconType iconType;

  const IconAnimated({
    super.key,
    required this.active,
    required this.size,
    this.color,
    this.strokeWidth,
    required this.iconType,
  });

  @override
  State<StatefulWidget> createState() => IconAnimatedState();
}

class IconAnimatedState extends State<IconAnimated> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOutCirc));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    widget.active ? _animationController.forward() : _animationController.reverse();
    final Size size = Size(widget.size, widget.size);
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: AnimatedPathPainter(
        _animation,
        widget.color ?? theme.primaryColor,
        widget.strokeWidth,
        widget.iconType,
        size,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class AnimatedPathPainter extends CustomPainter {
  final Animation<double> _animation;
  final Color _color;
  final double? strokeWidth;
  final IconType iconType;
  final Size size;

  AnimatedPathPainter(this._animation, this._color, this.strokeWidth, this.iconType, this.size)
    : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    size = this.size;
    final animationPercent = _animation.value;

    final path = createAnimatedPath(_createAnyPath(size, iconType), animationPercent);

    final Paint paint = Paint();
    paint.color = _color;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = strokeWidth ?? size.width * 0.04;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Path _createAnyPath(Size size, IconType iconType) {
    switch (iconType) {
      case IconType.check:
        return Path()
          ..moveTo(0.27083 * size.width, 0.54167 * size.height)
          ..lineTo(0.41667 * size.width, 0.68750 * size.height)
          ..lineTo(0.75000 * size.width, 0.35417 * size.height);
      case IconType.fail:
        return Path()
          ..moveTo(0.7 * size.width, 0.3 * size.height)
          ..lineTo(0.3 * size.width, 0.7 * size.height)
          ..moveTo(0.3 * size.width, 0.3 * size.height)
          ..lineTo(0.7 * size.width, 0.7 * size.height);
      case IconType.alert:
        return Path()
          ..addOval(
            Rect.fromCircle(
              center: Offset(0.5 * size.width, 0.5 * size.height),
              radius: (size.width + size.height) / 7.5,
            ),
          )
          ..moveTo(0.5 * size.width, 0.34 * size.height)
          ..lineTo(0.5 * size.width, 0.39 * size.height)
          ..moveTo(0.5 * size.width, 0.45 * size.height)
          ..lineTo(0.5 * size.width, 0.66 * size.height);
      case IconType.error:
        return Path()
          ..addOval(
            Rect.fromCircle(
              center: Offset(0.5 * size.width, 0.5 * size.height),
              radius: (size.width + size.height) / 7.5,
            ),
          )
          ..moveTo(0.5 * size.width, 0.34 * size.height)
          ..lineTo(0.5 * size.width, 0.55 * size.height)
          ..moveTo(0.5 * size.width, 0.61 * size.height)
          ..lineTo(0.5 * size.width, 0.66 * size.height);
      case IconType.trendingUp:
        return Path()
          ..moveTo(0.28 * size.width, 0.62 * size.height)
          ..lineTo(0.43 * size.width, 0.47 * size.height)
          ..lineTo(0.53 * size.width, 0.57 * size.height)
          ..lineTo(0.72 * size.width, 0.38 * size.height)
          ..moveTo(0.745 * size.width, 0.38 * size.height)
          ..lineTo(0.60 * size.width, 0.38 * size.height)
          ..moveTo(0.72 * size.width, 0.38 * size.height)
          ..lineTo(0.72 * size.width, 0.50 * size.height);
      case IconType.trendingDown:
        return Path()
          ..moveTo(0.25 * size.width, 0.35 * size.height)
          ..lineTo(0.415 * size.width, 0.525 * size.height)
          ..lineTo(0.515 * size.width, 0.405 * size.height)
          ..lineTo(0.700 * size.width, 0.600 * size.height)
          ..moveTo(0.735 * size.width, 0.615 * size.height)
          ..lineTo(0.585 * size.width, 0.615 * size.height)
          ..moveTo(0.715 * size.width, 0.635 * size.height)
          ..lineTo(0.715 * size.width, 0.475 * size.height);
      case IconType.search:
        return Path()
          ..addOval(
            Rect.fromCircle(
              center: Offset(0.46 * size.width, 0.46 * size.height),
              radius: (size.width + size.height) / 12,
            ),
          )
          ..moveTo(0.56 * size.width, 0.56 * size.height)
          ..lineTo(0.70 * size.width, 0.70 * size.height);
      case IconType.message:
        return Path()
          ..moveTo(0.68 * size.width, 0.50 * size.height)
          ..quadraticBezierTo(0.68 * size.width, 0.50 * size.height, 0.67 * size.width, 0.475 * size.height)
          ..quadraticBezierTo(0.67 * size.width, 0.475 * size.height, 0.65 * size.width, 0.46 * size.height)
          ..lineTo(0.39 * size.width, 0.33 * size.height)
          ..quadraticBezierTo(0.39 * size.width, 0.33 * size.height, 0.36 * size.width, 0.32 * size.height)
          ..quadraticBezierTo(0.36 * size.width, 0.32 * size.height, 0.33 * size.width, 0.33 * size.height)
          ..quadraticBezierTo(0.33 * size.width, 0.33 * size.height, 0.32 * size.width, 0.35 * size.height)
          ..quadraticBezierTo(0.32 * size.width, 0.35 * size.height, 0.32 * size.width, 0.37 * size.height)
          ..lineTo(0.375 * size.width, 0.50 * size.height)
          ..lineTo(0.32 * size.width, 0.625 * size.height)
          ..quadraticBezierTo(0.32 * size.width, 0.625 * size.height, 0.32 * size.width, 0.645 * size.height)
          ..quadraticBezierTo(0.32 * size.width, 0.645 * size.height, 0.33 * size.width, 0.665 * size.height)
          ..quadraticBezierTo(0.33 * size.width, 0.665 * size.height, 0.36 * size.width, 0.675 * size.height)
          ..quadraticBezierTo(0.36 * size.width, 0.675 * size.height, 0.39 * size.width, 0.665 * size.height)
          ..lineTo(0.65 * size.width, 0.535 * size.height)
          ..quadraticBezierTo(0.65 * size.width, 0.535 * size.height, 0.67 * size.width, 0.52 * size.height)
          ..quadraticBezierTo(0.67 * size.width, 0.52 * size.height, 0.68 * size.width, 0.50 * size.height)
          ..quadraticBezierTo(0.68 * size.width, 0.50 * size.height, 0.675 * size.width, 0.49 * size.height)
          ..moveTo(0.38 * size.width, 0.50 * size.height)
          ..lineTo(0.52 * size.width, 0.50 * size.height);
      case IconType.add:
        return Path()
          ..moveTo(0.32 * size.width, 0.50 * size.height)
          ..lineTo(0.68 * size.width, 0.50 * size.height)
          ..moveTo(0.50 * size.width, 0.32 * size.height)
          ..lineTo(0.50 * size.width, 0.68 * size.height);
      case IconType.download:
        return Path()
          ..moveTo(0.42 * size.width, 0.46 * size.height)
          ..lineTo(0.37 * size.width, 0.46 * size.height)
          ..quadraticBezierTo(0.37 * size.width, 0.46 * size.height, 0.36 * size.width, 0.465 * size.height)
          ..quadraticBezierTo(0.36 * size.width, 0.465 * size.height, 0.35 * size.width, 0.47 * size.height)
          ..quadraticBezierTo(0.35 * size.width, 0.47 * size.height, 0.345 * size.width, 0.48 * size.height)
          ..quadraticBezierTo(0.345 * size.width, 0.48 * size.height, 0.34 * size.width, 0.49 * size.height)
          ..lineTo(0.34 * size.width, 0.65 * size.height)
          ..quadraticBezierTo(0.34 * size.width, 0.65 * size.height, 0.345 * size.width, 0.66 * size.height)
          ..quadraticBezierTo(0.345 * size.width, 0.66 * size.height, 0.35 * size.width, 0.67 * size.height)
          ..quadraticBezierTo(0.35 * size.width, 0.67 * size.height, 0.36 * size.width, 0.675 * size.height)
          ..quadraticBezierTo(0.36 * size.width, 0.675 * size.height, 0.37 * size.width, 0.68 * size.height)
          ..lineTo(0.63 * size.width, 0.68 * size.height)
          ..quadraticBezierTo(0.63 * size.width, 0.68 * size.height, 0.64 * size.width, 0.675 * size.height)
          ..quadraticBezierTo(0.64 * size.width, 0.675 * size.height, 0.65 * size.width, 0.67 * size.height)
          ..quadraticBezierTo(0.65 * size.width, 0.67 * size.height, 0.655 * size.width, 0.66 * size.height)
          ..quadraticBezierTo(0.655 * size.width, 0.66 * size.height, 0.66 * size.width, 0.65 * size.height)
          ..lineTo(0.66 * size.width, 0.49 * size.height)
          ..quadraticBezierTo(0.66 * size.width, 0.65 * size.height, 0.655 * size.width, 0.48 * size.height)
          ..quadraticBezierTo(0.655 * size.width, 0.48 * size.height, 0.65 * size.width, 0.47 * size.height)
          ..quadraticBezierTo(0.65 * size.width, 0.47 * size.height, 0.64 * size.width, 0.465 * size.height)
          ..quadraticBezierTo(0.64 * size.width, 0.465 * size.height, 0.63 * size.width, 0.46 * size.height)
          ..lineTo(0.58 * size.width, 0.46 * size.height)
          ..moveTo(0.50 * size.width, 0.32 * size.height)
          ..lineTo(0.50 * size.width, 0.60 * size.height)
          ..moveTo(0.42 * size.width, 0.54 * size.height)
          ..quadraticBezierTo(0.42 * size.width, 0.54 * size.height, 0.50 * size.width, 0.60 * size.height)
          ..quadraticBezierTo(0.50 * size.width, 0.60 * size.height, 0.58 * size.width, 0.54 * size.height);

      case IconType.bluetooth:
        return Path()
          ..moveTo(0.39 * size.width, 0.61 * size.height)
          ..lineTo(0.60 * size.width, 0.40 * size.height)
          ..quadraticBezierTo(0.60 * size.width, 0.40 * size.height, 0.61 * size.width, 0.39 * size.height)
          ..quadraticBezierTo(0.61 * size.width, 0.39 * size.height, 0.60 * size.width, 0.38 * size.height)
          ..lineTo(0.52 * size.width, 0.30 * size.height)
          ..quadraticBezierTo(0.52 * size.width, 0.30 * size.height, 0.51 * size.width, 0.29 * size.height)
          ..quadraticBezierTo(0.51 * size.width, 0.29 * size.height, 0.50 * size.width, 0.28 * size.height)
          ..quadraticBezierTo(0.50 * size.width, 0.28 * size.height, 0.50 * size.width, 0.29 * size.height)
          ..quadraticBezierTo(0.50 * size.width, 0.29 * size.height, 0.50 * size.width, 0.30 * size.height)
          ..lineTo(0.50 * size.width, 0.70 * size.height)
          ..quadraticBezierTo(0.50 * size.width, 0.70 * size.height, 0.50 * size.width, 0.71 * size.height)
          ..quadraticBezierTo(0.50 * size.width, 0.71 * size.height, 0.50 * size.width, 0.72 * size.height)
          ..quadraticBezierTo(0.50 * size.width, 0.72 * size.height, 0.51 * size.width, 0.71 * size.height)
          ..quadraticBezierTo(0.51 * size.width, 0.71 * size.height, 0.52 * size.width, 0.70 * size.height)
          ..lineTo(0.60 * size.width, 0.62 * size.height)
          ..quadraticBezierTo(0.60 * size.width, 0.62 * size.height, 0.61 * size.width, 0.61 * size.height)
          ..quadraticBezierTo(0.61 * size.width, 0.61 * size.height, 0.60 * size.width, 0.60 * size.height)
          ..lineTo(0.39 * size.width, 0.39 * size.height);
      case IconType.menu:
        return Path()
          ..moveTo(0.28 * size.width, 0.38 * size.height)
          ..lineTo(0.68 * size.width, 0.38 * size.height)
          ..moveTo(0.28 * size.width, 0.50 * size.height)
          ..lineTo(0.68 * size.width, 0.50 * size.height)
          ..moveTo(0.28 * size.width, 0.62 * size.height)
          ..lineTo(0.68 * size.width, 0.62 * size.height);
      case IconType.sort:
        return Path()
          ..moveTo(0.28 * size.width, 0.38 * size.height)
          ..lineTo(0.68 * size.width, 0.38 * size.height)
          ..moveTo(0.28 * size.width, 0.50 * size.height)
          ..lineTo(0.58 * size.width, 0.50 * size.height)
          ..moveTo(0.28 * size.width, 0.62 * size.height)
          ..lineTo(0.44 * size.width, 0.62 * size.height);
      case IconType.filter:
        return Path()
          ..moveTo(0.29 * size.width, 0.36 * size.height)
          ..lineTo(0.52 * size.width, 0.36 * size.height)
          ..moveTo(0.595 * size.width, 0.36 * size.height)
          ..lineTo(0.70 * size.width, 0.36 * size.height)
          ..moveTo(0.29 * size.width, 0.50 * size.height)
          ..lineTo(0.43 * size.width, 0.50 * size.height)
          ..moveTo(0.48 * size.width, 0.50 * size.height)
          ..lineTo(0.70 * size.width, 0.50 * size.height)
          ..moveTo(0.29 * size.width, 0.64 * size.height)
          ..lineTo(0.43 * size.width, 0.64 * size.height)
          ..moveTo(0.50 * size.width, 0.64 * size.height)
          ..lineTo(0.70 * size.width, 0.64 * size.height)
          ..moveTo(0.595 * size.width, 0.29 * size.height)
          ..lineTo(0.595 * size.width, 0.43 * size.height)
          ..moveTo(0.41 * size.width, 0.43 * size.height)
          ..lineTo(0.41 * size.width, 0.57 * size.height)
          ..moveTo(0.50 * size.width, 0.57 * size.height)
          ..lineTo(0.50 * size.width, 0.71 * size.height);
    }
  }

  Path createAnimatedPath(Path originalPath, double animationPercent) {
    final totalLength = originalPath.computeMetrics().fold(
      0.0,
      (double prev, PathMetric metric) => prev + metric.length,
    );

    final currentLength = totalLength * animationPercent;

    return extractPathUntilLength(originalPath, currentLength);
  }

  Path extractPathUntilLength(Path originalPath, double length) {
    var currentLength = 0.0;

    final path = Path();

    var metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      var metric = metricsIterator.current;

      var nextLength = currentLength + metric.length;

      final isLastSegment = nextLength > length;
      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = metric.extractPath(0.0, remainingLength);

        path.addPath(pathSegment, Offset.zero);
      } else {
        final pathSegment = metric.extractPath(0.0, metric.length);
        path.addPath(pathSegment, Offset.zero);
      }

      currentLength = nextLength;
    }

    return path;
  }
}
