import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/util/sizes.dart';
import 'package:safe_notes/app/design/common/style/color_palettes.dart';
import 'package:safe_notes/app/design/widgets/wave/wave_left.dart';

class BarStatus extends StatelessWidget {
  final Widget titleChild;
  final Function()? onTapIconButtonPrevius;

  const BarStatus({
    Key? key,
    required this.titleChild,
    required this.onTapIconButtonPrevius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Future.delayed(const Duration(milliseconds: 250));
        if (onTapIconButtonPrevius != null) {
          onTapIconButtonPrevius!();
          return false;
        } else {
          return true;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: Sizes.heightStatusBar(context),
            width: Sizes.width(context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorPalettes.secondy,
                  Theme.of(context).primaryColor,
                ],
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
              ),
            ),
          ),
          SizedBox(
            height: Sizes.height(context) * 0.12,
            width: Sizes.width(context),
            child: Stack(
              children: [
                WaveLeft(fractionHeight: 0.12 + 0.4, invertedColor: true),
                Container(
                  width: 65,
                  height: Sizes.height(context) * 0.075,
                  alignment: AlignmentDirectional.center,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    onPressed: onTapIconButtonPrevius,
                  ),
                ),
                Container(
                  width: Sizes.width(context),
                  height: Sizes.height(context) * 0.075,
                  alignment: AlignmentDirectional.center,
                  padding: const EdgeInsets.only(top: 4.0),
                  child: titleChild,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
