import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/glow_behavior/no_glow_behavior.dart';
import 'package:safe_notes/app/shared/database/default.dart';

class GridSelectionColor extends StatefulWidget {
  final String? title;
  final int? initalColor;
  final Function(int) onChangeColor;

  const GridSelectionColor({
    Key? key,
    this.title,
    this.initalColor,
    required this.onChangeColor,
  }) : super(key: key);

  @override
  State<GridSelectionColor> createState() => _GridSelectionColorState();
}

class _GridSelectionColorState extends State<GridSelectionColor> {
  int colorSelected = 0;
  List<int> colors = [];

  void includeColors() {
    colors.addAll(DefaultDatabase.listColors);
    if (widget.initalColor != null) {
      colorSelected = colors.firstWhere((color) => color == widget.initalColor);
    } else {
      colorSelected = colors.first;
    }
  }

  @override
  void initState() {
    super.initState();
    includeColors();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135.0,
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                widget.title ?? 'Cor da pasta',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'JosefinSans',
                  fontWeight: FontWeight.w600,
                  color: ColorPalettes.grey,
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Container(
                  height: 1.1,
                  color: ColorPalettes.grey,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 95.0,
            child: ScrollConfiguration(
              behavior: NoGlowBehavior(),
              child: GridView.extent(
                maxCrossAxisExtent: 35,
                mainAxisSpacing: 7.5,
                crossAxisSpacing: 17.5,
                padding: const EdgeInsets.only(top: 10),
                children: colors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        colorSelected = color;
                      });
                      widget.onChangeColor(color);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(color),
                        shape: BoxShape.circle,
                      ),
                      child: color == colorSelected
                          ? Center(
                              child: Icon(
                                Icons.check,
                                color: Theme.of(context).colorScheme.background,
                              ),
                            )
                          : Container(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
