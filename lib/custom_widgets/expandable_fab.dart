import 'package:flutter/material.dart';
import 'dart:math' as math;

class ExpandedFab extends StatefulWidget {
  const ExpandedFab({
    // super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandedFab> createState() => _ExpandedFabState();
}

class _ExpandedFabState extends State<ExpandedFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandedAnimation;
  bool _open = false;

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandedAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      vsync: this,
      value: _open ? 1 : 0,
      duration: const Duration(milliseconds: 250),
    );
    _expandedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
        ignoring: _open,
        child: AnimatedContainer(
          transformAlignment: Alignment.center,
          transform: Matrix4.diagonal3Values(
            _open ? 0.7 : 1,
            _open ? 0.7 : 1,
            1,
          ),
          duration: const Duration(milliseconds: 250),
          curve: const Interval(0, 0.5, curve: Curves.easeOut),
          child: AnimatedOpacity(
            opacity: _open ? 0 : 1,
            curve: const Interval(0.25, 1, curve: Curves.easeInOut),
            duration: const Duration(milliseconds: 250),
            child: FloatingActionButton(
              onPressed: _toggle,
              child: const Icon(Icons.create),
            ),
          ),
        ));
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4.0,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}

class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}