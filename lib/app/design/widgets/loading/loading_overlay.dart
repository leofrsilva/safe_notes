import 'package:flutter/material.dart';

class LoadingOverlay {
  static Future<T?> show<T>(BuildContext context, Future<T> future) async {
    final _overlay = OverlayEntry(
      opaque: false,
      maintainState: true,
      builder: (_) => const _FullScreenLoader(),
    );
    Overlay.of(context)?.insert(_overlay);

    T? result;
    await future.then((value) {
      result = value;
      _overlay.remove();
    });

    return result;
  }
}

class _FullScreenLoader extends StatefulWidget {
  const _FullScreenLoader({Key? key}) : super(key: key);

  @override
  State<_FullScreenLoader> createState() => _FullScreenLoaderState();
}

class _FullScreenLoaderState extends State<_FullScreenLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5)),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.lock,
              size: 28,
              color: Theme.of(context).backgroundColor,
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: animationController,
              child: Icon(
                Icons.refresh_rounded,
                size: 85,
                color: Theme.of(context).backgroundColor,
              ),
              builder: (context, _widget) {
                return Transform.rotate(
                  alignment: AlignmentDirectional.center,
                  angle: animationController.value * 6.3,
                  child: _widget,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
