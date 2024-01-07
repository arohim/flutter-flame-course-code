import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_squares/matrix_effect/maxtrix_text.dart';
import 'package:flutter/material.dart';

class VerticalText extends PositionComponent {
  int totalHeightText = 0;
  int totalWidthText = 0;
  int bottomColorIdx = 0;
  int totalChars = 30;
  Random random = Random();
  List<MatrixTextComponent> textComponents = [];
  double maxSpeed = 0.5;
  final List<String> _characters = [];
  var textPaint = TextPaint(
    style: const TextStyle(
      color: Colors.white,
      fontSize: 12,
    ),
  );
  late Timer interval;
  int pt = 0;
  double spaceBetweenText = 12;

  VerticalText({required this.textPaint, required this.totalChars}) {
    spaceBetweenText = textPaint.style.fontSize ?? 12.0;
    interval = Timer(
      1,
      onTick: () {
        if (pt <= 0) {
          pt = totalChars - 1;
        }
        pt--;

        position = Vector2(position.x, position.y + spaceBetweenText);
        if (position.y > size.y) {
          position = Vector2(position.x, -(spaceBetweenText * totalChars));
        }

        for (int childIdx = children.length - 1; childIdx > 0; childIdx--) {
          final element = textComponents[childIdx];
          final charIdx = (pt - childIdx).abs();
          element.text = _characters[charIdx];
        }
      },
      repeat: true,
    );
    interval.start();
  }

  @override
  Future<void>? onLoad() {
    totalHeightText = size.y ~/ spaceBetweenText;
    totalWidthText = size.x ~/ spaceBetweenText;
    bottomColorIdx = 0;
    pt = totalChars - 1;
    var yIndx = 0;
    for (int charIdx = 0; charIdx < totalChars; charIdx++) {
      _characters.add(String.fromCharCode(random.nextInt(512)));
    }
    for (yIndx = 0; yIndx < totalChars; yIndx++) {
      var alpha = (yIndx * 1.0) / (totalChars - 1);
      var newTextPaint = textPaint;
      if (yIndx == totalChars - 1) {
        newTextPaint = textPaint.copyWith(
          (p0) => TextStyle(
            color: Colors.white,
            fontSize: p0.fontSize,
          ),
        );
      } else {
        newTextPaint = textPaint.copyWith(
          (p0) => TextStyle(
            color: Colors.green.withOpacity(alpha),
            fontSize: p0.fontSize,
          ),
        );
      }
      var text = MatrixTextComponent(
        index: yIndx,
        text: _characters[yIndx],
        textRenderer: newTextPaint,
        position:
            Vector2(spaceBetweenText * position.x, spaceBetweenText * yIndx),
      );
      textComponents.add(text);
      add(text);
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    var yIndx = 0;
    var xIndx = 5;
  }
}
