import 'package:flutter/material.dart';

class ClipViewPortWidget extends StatefulWidget {
  final Widget child;
  final Curve curve;
  final Duration duration;
  final bool isShowDrawer;

  const ClipViewPortWidget({
    Key? key,
    required this.child,
    required this.duration,
    required this.isShowDrawer,
    this.curve = Curves.easeOutSine,
  }) : super(key: key);

  @override
  State<ClipViewPortWidget> createState() => _ClipViewPortWidgetState();
}

class _ClipViewPortWidgetState extends State<ClipViewPortWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final double beginRadius = 0.0;
  final double endRadius = 45.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: beginRadius, end: endRadius).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ClipViewPortWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isShowDrawer) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(_animation.value),
          ),
          child: widget.child,
        );
      },
    );
  }
}
