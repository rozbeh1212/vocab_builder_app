import 'package:flutter/material.dart';

/// [AnimatedListItem] is a stateful widget that animates its child
/// with a staggered fade and slide effect.
///
/// It's designed to be used within a list to create an engaging and
/// visually appealing entrance animation for each item.
class AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final bool isEven;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.isEven = true,
  });

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // A slightly shorter duration can feel more responsive.
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // The slide animation starts from the side (left or right) and moves to the center.
    _slideAnimation = Tween<Offset>(
      begin: Offset(widget.isEven ? 0.5 : -0.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    // A staggered delay is applied to each item based on its index in the list.
    // This creates a cascading or "waterfall" effect.
    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      // Ensure the widget is still in the tree before starting the animation.
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The animations are applied using FadeTransition and SlideTransition widgets.
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}