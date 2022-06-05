import 'package:flutter/material.dart';

class FloatingButtonForTop extends StatelessWidget {
  final bool isVisible;
  final ScrollController scrollController;

  const FloatingButtonForTop({
    Key? key,
    required this.isVisible,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isVisible
        ? FloatingActionButton(
            mini: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 18,
                  height: 2.0,
                  color: Colors.blueGrey,
                  margin: const EdgeInsets.only(bottom: 5.0),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Icon(
                    Icons.keyboard_arrow_up_rounded,
                    color: Colors.blueGrey,
                    size: 30,
                  ),
                ),
              ],
            ),
            onPressed: () {
              scrollController.animateTo(
                scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInQuint,
              );
            },
          )
        : Container();
  }
}
