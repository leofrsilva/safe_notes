import 'package:flutter/material.dart';

import '../../common/common.dart';

class CustomButtonOutline extends StatefulWidget {
  final String text;
  final Icon? icon;
  final Function()? onTap;
  final bool isExpanded;
  final bool isInvertAnimation;

  const CustomButtonOutline({
    Key? key,
    this.onTap,
    required this.text,
    this.icon,
    this.isExpanded = true,
    this.isInvertAnimation = false,
  }) : super(key: key);

  @override
  State<CustomButtonOutline> createState() => _CustomButtonOutlineState();
}

class _CustomButtonOutlineState extends State<CustomButtonOutline>
    with TickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );
  late final _animationTween = Tween<double>(begin: -1, end: 0)
      .chain(CurveTween(curve: Curves.easeInOutQuart))
      .animate(_animationController);

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 50),
      _animationController.forward,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationTween,
      builder: (context, child) {
        double opacity() {
          if (_animationTween.value + 1 < 0.2) {
            return (_animationTween.value + 1) * 5;
          }
          return 1;
        }

        return Transform.translate(
          offset: Offset(
              _animationTween.value * (widget.isInvertAnimation ? -387 : 385),
              0),
          child: Opacity(opacity: opacity(), child: child),
        );
      },
      child: Container(
        width: widget.isExpanded
            ? Sizes.width(context) * .9
            : Sizes.width(context) * .3,
        height: 37,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(Sizes.dp10(context)),
          border: BorderDirectional(
            top: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            end: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            start: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            bottom: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Sizes.dp10(context),
              ),
            ),
          ),
          onPressed: widget.onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: widget.icon,
                ),
              Text(
                widget.text,
                style: const TextStyle(
                  fontFamily: 'JosefinSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
