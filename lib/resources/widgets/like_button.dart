import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:petguardian/resources/constants/app_icons.dart';

class LikeButton extends StatefulWidget {
  final bool isLiked;
  final Function(bool, AnimationController) onTap;

  const LikeButton({super.key, required this.isLiked, required this.onTap});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
    value: 1.0,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(widget.isLiked, _controller),
      child: ScaleTransition(
        scale: Tween(
          begin: 0.7,
          end: 1.0,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut)),
        child:
            widget.isLiked
                ? SvgPicture.asset(AppIcons.heartActive, color: Colors.red, height: 26)
                : SvgPicture.asset(AppIcons.heartInActive, color: Colors.black, height: 26),
      ),
    );
  }
}
