import 'package:flutter/material.dart';

import '../../common/common.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final bool isGradient;
  final Function()? onTap;
  final bool isInvertAnimation;

  const CustomButton({
    Key? key,
    this.onTap,
    this.isGradient = true,
    required this.text,
    this.isInvertAnimation = false,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
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
        const Duration(milliseconds: 50), _animationController.forward);
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
          child: Opacity(
            opacity: opacity(),
            child: child,
          ),
        );
      },

      // child: SizedBox(
      //   width: Sizes.width(context) * .9,
      //   child: InkWell(
      //     onTap: widget.onTap,
      // splashColor: Theme.of(context).colorScheme.tertiary,
      // highlightColor: Theme.of(context).colorScheme.primary,
      // borderRadius: BorderRadius.circular(Sizes.dp10(context)),
      // child: Ink(
      // decoration: BoxDecoration(
      //   color: Theme.of(context).colorScheme.primary,
      //   borderRadius: BorderRadius.circular(Sizes.dp10(context)),
      //   gradient: widget.isGradient
      //       ? LinearGradient(
      //           colors: <Color>[
      //             Theme.of(context).colorScheme.primary,
      //             Theme.of(context).colorScheme.tertiary,
      //           ],
      //           begin: AlignmentDirectional.topStart,
      //           end: AlignmentDirectional.bottomEnd,
      //         )
      //       : null,
      // ),
      // child: Container(
      //   constraints: BoxConstraints(
      //     minWidth: Sizes.width(context) * .9,
      //     minHeight: 45.0,
      //   ),
      //   alignment: Alignment.center,
      //   child: Text(
      //     widget.text,
      //     textAlign: TextAlign.center,
      //     style: TextStyle(
      //       fontSize: 18,
      //       fontWeight: FontWeight.bold,
      //       color: Theme.of(context).colorScheme.onInverseSurface,
      //     ),
      //   ),
      // ),
      // ),
      // ),
      // ),
      child: Container(
        height: 45.0,
        width: Sizes.width(context) * .9,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(Sizes.dp10(context)),
          gradient: widget.isGradient
              ? LinearGradient(
                  colors: <Color>[
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                )
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Theme.of(context).colorScheme.tertiary,
            highlightColor: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(Sizes.dp10(context)),
            onTap: widget.onTap,
            child: Align(
              // child: Container(
              // constraints: BoxConstraints(
              //   minWidth: Sizes.width(context) * .9,
              //   minHeight: 45.0,
              // ),
              alignment: Alignment.center,
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
