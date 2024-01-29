import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_squares/matrix_effect/vertical_text.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: MatrixGame()));
}

class MatrixGame extends FlameGame with DoubleTapDetector, FPSCounter {
  var totalHeightText = 0;
  var totalWidthText = 0;
  Random _random = Random();

  final matrixTextPaint = TextPaint(
    style: TextStyle(
      color: Colors.white.withAlpha(50),
      fontSize: 12,
    ),
  );

  final matrixTextPaint2 = TextPaint(
    style: TextStyle(
      color: Colors.white.withAlpha(50),
      fontSize: 8,
    ),
  );

  @override
  Future<void>? onLoad() {
    totalHeightText = (size.y ~/ 12.0);
    totalWidthText = (size.x ~/ 12.0) + 1;
    final totalWidthText2 = (size.x ~/ 8.0) + 1;

    int i = 2;
    final maxStartY = size.y ~/ 2;
    for (i = 0; i < totalWidthText; i++) {
      add(
        VerticalText(textPaint: matrixTextPaint, totalChars: 20)
          ..size = size
          ..position = Vector2(
            i * 1.0,
            _random.nextInt(maxStartY).toDouble(),
          ),
      );
    }
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    TextPaint(style: const TextStyle(color: Colors.red, fontSize: 10))
        .render(canvas, "FPS: ${fps(60)}", Vector2(50, size.y - 50));
  }

  @override
  void onDoubleTap() {
    super.onDoubleTap();
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }
}
