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
          child: Opacity(opacity: opacity(), child: child),
        );
      },
      child: Container(
        width: Sizes.width(context) * .9,
        height: 45,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(Sizes.dp10(context)),
            gradient: widget.isGradient
                ? LinearGradient(
                    colors: <Color>[
                      Theme.of(context).primaryColor,
                      ColorPalettes.secondy,
                    ],
                    begin: AlignmentDirectional.topStart,
                    end: AlignmentDirectional.bottomEnd,
                  )
                : null,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: ColorPalettes.black.withOpacity(0.2),
                blurRadius: 10.0,
                spreadRadius: 0.0,
                offset: const Offset(2.0, 2.0),
              ),
            ]),
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: ColorPalettes.lightBG,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Sizes.dp10(context),
              ),
            ),
          ),
          onPressed: widget.onTap,
          child: Text(
            widget.text,
            style: const TextStyle(
              fontFamily: 'JosefinSans',
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
