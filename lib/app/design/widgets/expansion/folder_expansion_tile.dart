import 'package:flutter/material.dart';

class FolderExpansionTile extends StatefulWidget {
  const FolderExpansionTile({
    Key? key,
    required this.title,
    this.onPressed,
    this.onExpansionChanged,
    this.selected = false,
    this.iconSize,
    this.iconColor,
    this.fontColor,
    this.selectedColor,
    this.children = const <Widget>[],
    this.trailing,
    this.spaceStart,
    this.borderRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.initiallyExpanded = false,
    this.contentPadding,
    this.backgroundColor,
    this.duration = const Duration(milliseconds: 200),
    this.heightFactorCurve = Curves.easeIn,
    this.turnsCurve = Curves.easeIn,
    this.turnsColor,
  }) : super(key: key);

  final bool selected;

  final Color? fontColor;

  final double? iconSize;

  final Color? iconColor;

  final Color? selectedColor;

  final Widget? trailing;

  final String title;

  final List<Widget> children;

  final Function()? onPressed;

  // Padding Start (Left)
  final double? spaceStart;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool>? onExpansionChanged;

  /// Defaults to a circular border with a radius of 8.0.
  final BorderRadiusGeometry borderRadius;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  /// The inner `contentPadding` of the ListTile widget.
  ///
  /// If null, ListTile defaults to 16.0 horizontal padding.
  final EdgeInsetsGeometry? contentPadding;

  /// If null, defaults to Theme.of(context).primaryColor.
  final Color? backgroundColor;

  /// Defaults to 200 milliseconds.
  final Duration duration;

  /// The animation curve used to control the height of the expanding/collapsing card.
  ///
  /// Defaults to Curves.easeIn.
  final Curve heightFactorCurve;

  final Color? turnsColor;

  /// Defaults to Curves.easeIn.
  final Curve turnsCurve;

  @override
  FolderExpansionTileState createState() => FolderExpansionTileState();
}

class FolderExpansionTileState extends State<FolderExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.25);

  late Animatable<double> _heightFactorTween;
  late Animatable<double> _turnsTween;

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;

  late Color _selectColor;
  late Color _materialColor;
  bool _isExpanded = false;

  initialConfig(BuildContext context) {
    _heightFactorTween = CurveTween(curve: widget.heightFactorCurve);
    _turnsTween = CurveTween(curve: widget.turnsCurve);

    _heightFactor = _controller.drive(_heightFactorTween);
    _iconTurns = _controller.drive(_halfTween.chain(_turnsTween));
    _isExpanded = PageStorage.of(context).readState(context) as bool? ??
        widget.initiallyExpanded; //! WARNING
    if (_isExpanded) {
      _controller.value = 1.0;
    } else {
      _controller.value = 0.0;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    initialConfig(context);
  }

  @override
  void didUpdateWidget(covariant FolderExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    initialConfig(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Credit: Simon Lightfoot - https://stackoverflow.com/a/48935106/955974
  void _setExpansion(bool shouldBeExpanded) {
    if (shouldBeExpanded != _isExpanded) {
      setState(() {
        _isExpanded = shouldBeExpanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse().then<void>((void value) {
            if (!mounted) return;
            setState(() {
              // Rebuild without widget.children.
            });
          });
        }
        PageStorage.of(context).writeState(context, _isExpanded); //! WARNING
      });
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged!(_isExpanded);
      }
    }
  }

  void expand() {
    _setExpansion(true);
  }

  void collapse() {
    _setExpansion(false);
  }

  void toggleExpansion() {
    _setExpansion(!_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    Widget turnsButton = const SizedBox(width: 14.0);
    Function()? onExpanded;
    if (widget.children.isNotEmpty) {
      onExpanded = toggleExpansion;
      turnsButton = RotationTransition(
        turns: _iconTurns,
        child: Icon(
          Icons.arrow_forward_ios,
          size: 10,
          color: widget.turnsColor,
        ),
      );
    }

    return Material(
      color: _materialColor,
      borderRadius: widget.borderRadius,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
            tileColor: widget.selected ? _selectColor : null,
            child: ListTile(
              onTap: widget.onPressed,
              shape: RoundedRectangleBorder(
                borderRadius: widget.borderRadius,
              ),
              title: Text(
                widget.title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  height: 1.6,
                  fontSize: widget.selected ? 16 : null,
                  fontWeight:
                      widget.selected ? FontWeight.bold : FontWeight.w600,
                  color: widget.fontColor ??
                      (Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).colorScheme.inverseSurface
                          : Theme.of(context).colorScheme.onInverseSurface),
                ),
              ),
              trailing: widget.trailing,
              contentPadding: const EdgeInsetsDirectional.only(
                start: 0.0,
                end: 16.0,
              ),
              leading: Container(
                constraints: const BoxConstraints(
                  minHeight: 50.0,
                  minWidth: 44.0,
                ),
                child: InkWell(
                  onTap: onExpanded,
                  borderRadius: BorderRadius.circular(8.0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 16,
                      bottom: 8.0,
                    ),
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Icon(
                          Icons.folder_outlined,
                          color: widget.iconColor,
                          size: widget.iconSize ?? 28,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: turnsButton,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _selectColor =
        widget.selectedColor ?? theme.colorScheme.primary.withOpacity(0.2);
    _materialColor = widget.backgroundColor ??
        Theme.of(context).drawerTheme.backgroundColor ??
        Theme.of(context).colorScheme.background;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}
