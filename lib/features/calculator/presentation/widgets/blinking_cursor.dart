import 'package:flutter/material.dart';

class BlinkingCursor extends StatefulWidget {
  const BlinkingCursor({super.key, this.height = 34, this.width = 2});

  final double height;
  final double width;

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        // margin: EdgeInsets.symmetric(vertical: 3.0),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
