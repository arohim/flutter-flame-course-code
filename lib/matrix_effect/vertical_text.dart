import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_squares/matrix_effect/maxtrix_text.dart';
import 'package:flutter/material.dart';

class VerticalText extends PositionComponent {
  int totalHeightText = 0;
  int totalWidthText = 0;
  int bottomColorIdx = 0;
  Random random = Random();
  List<MatrixTextComponent> textComponents = [];
  double maxSpeed = 0.5;
  var xPosition = 0.0;
  final matrixTextPaint = TextPaint(
    style: const TextStyle(
      color: Colors.transparent,
      fontSize: 12,
    ),
  );

  VerticalText({
    required this.xPosition
  });

  @override
  Future<void>? onLoad() {
    totalHeightText = size.y ~/ 12.0;
    totalWidthText = size.x ~/ 12.0;
    bottomColorIdx = 0;
    var yIndx = 0;
    for (yIndx = 0; yIndx < totalHeightText; yIndx++) {
      var textComponent = MatrixTextComponent(
        index: yIndx,
        text: String.fromCharCode(random.nextInt(512)),
        textRenderer: matrixTextPaint,
        position: Vector2(12.0 * xPosition, 12.0 * yIndx),
      );
      textComponents.add(textComponent);
      add(textComponent);
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    bottomColorIdx += random.nextInt(2);
    if (bottomColorIdx >= totalHeightText + 50) {
      bottomColorIdx = 0;
    }
    for (int childIdx = 0; childIdx < textComponents.length; childIdx++) {
      final element = textComponents[childIdx];
      var topAlpha = (childIdx - bottomColorIdx) * 2 + 100;
      if (topAlpha < 0) {
        topAlpha = 0;
      }
      if (childIdx == bottomColorIdx) {
        element.textRenderer = matrixTextPaint.copyWith((p0) =>
            TextStyle(
              color: Colors.white,
              fontSize: p0.fontSize,
            ));
      } else if (childIdx <= bottomColorIdx) {
        element.textRenderer = matrixTextPaint.copyWith((p0) =>
            TextStyle(
              color: Colors.green.withAlpha(topAlpha),
              fontSize: p0.fontSize,
            ));
      } else {
        element.textRenderer = matrixTextPaint.copyWith((p0) =>
            TextStyle(
              color: Colors.transparent,
              fontSize: p0.fontSize,
            ));
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    var yIndx = 0;
    var xIndx = 5;
  }
}
