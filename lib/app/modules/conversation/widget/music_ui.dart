import 'dart:math';

import 'package:flutter/material.dart';

class MusicVisualizer extends StatefulWidget {
  final int barCount;
  final List<Color> colors;
  final Duration duration;
  final double barWidth;
  final double maxBarHeight;

  const MusicVisualizer({
    super.key,
    this.barCount = 20,
    this.colors = const [Colors.blue, Colors.purple, Colors.cyan],
    this.duration = const Duration(milliseconds: 400),
    this.barWidth = 4.0,
    this.maxBarHeight = 30.0,
  });

  @override
  _MusicVisualizerState createState() => _MusicVisualizerState();
}

class _MusicVisualizerState extends State<MusicVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> barHeights;

  @override
  void initState() {
    super.initState();
    barHeights = List.generate(widget.barCount, (index) => 0.0);

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )
      ..addListener(() {
        setState(() {
          // Generate random bar heights on every tick
          barHeights = List.generate(
            widget.barCount,
            (index) => Random().nextDouble() * widget.maxBarHeight,
          );
        });
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.barCount, (index) {
        final color = widget.colors[index % widget.colors.length];
        return AnimatedContainer(
          duration: widget.duration,
          width: widget.barWidth,
          height: barHeights[index],
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }
}
