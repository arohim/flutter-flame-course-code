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

  final matrixTextPaint = TextPaint(
    style: TextStyle(
      color: Colors.white.withAlpha(50),
      fontSize: 12,
    ),
  );

  @override
  Future<void>? onLoad() {
    totalHeightText = (size.y ~/ 12.0);
    totalWidthText = (size.x ~/ 12.0);

    for (int i = 0; i < totalWidthText; i++) {
      add(
        VerticalText(xPosition: i * 1.0)..size = size,
      );
    }
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // var yIndx = 0;
    // var xIndx = 5;
    // // for (var xIndx = 0; xIndx < totalWidthText; xIndx++) {
    //   for (yIndx = 0; yIndx < totalHeightText; yIndx++) {
    //     matrixTextPaint.render(
    //       canvas,
    //       "5",
    //       Vector2(12.0 * xIndx, 12.0 * yIndx),
    //     );
    //   }
    // // }
    matrixTextPaint.render(canvas, "FPS: ${fps(60)}", Vector2(50, size.y - 50));
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
