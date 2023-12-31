import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

class VerticalTextLine extends StatefulWidget {
  VerticalTextLine({
    required this.onFinished,
    this.speed = 12.0,
    this.maxLength = 10,
  });

  final double speed;
  final int maxLength;
  final VoidCallback onFinished;

  @override
  _VerticalTextLineState createState() => _VerticalTextLineState();
}

class _VerticalTextLineState extends State<VerticalTextLine> {
  late int _maxLength;
  late Duration _stepInterval;
  List<String> _characters = [];
  late Timer timer;

  @override
  void initState() {
    _maxLength = widget.maxLength;
    // _stepInterval = Duration(milliseconds: (1000 ~/ widget.speed));
    _stepInterval = Duration(milliseconds: 300);
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    timer = Timer.periodic(_stepInterval, (timer) {
      final random = Random();
      // String element = getString();//String.fromCharCode(random.nextInt(512));
      String element = String.fromCharCode(random.nextInt(512));

      final box = context.findRenderObject() as RenderBox;

      if (box.size.height > MediaQuery.of(context).size.height * 2) {
        widget.onFinished();
        return;
      }

      setState(() {
        _characters.add(element);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<double> stops = [];
    List<Color> colors = [];

    double greenStart = 0.3;
    double whiteStart = (_characters.length - 1) / (_characters.length);

    colors = [
      Colors.transparent,
      Colors.green.withAlpha(70),
      Colors.green.withAlpha(70),
      Colors.white.withAlpha(70),
    ];

    greenStart = (_characters.length - _maxLength) / _characters.length;

    stops = [0, greenStart, whiteStart, whiteStart];

    return ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: stops,
            colors: colors,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcIn,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: _getCharacters(),
        ));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  List<Widget> _getCharacters() {
    List<Widget> textWidgets = [];

    for (var character in _characters) {
      textWidgets.add(
        Text(
          character,
          style: const TextStyle(
            fontFamily: "Monospace",
            fontSize: 14,
          ),
        ),
      );
    }

    return textWidgets;
  }

  String getString() {
    final rand = Random().nextInt(2);
    return rand.toString();
  }
}
