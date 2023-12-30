import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget(game: Exercise1Game()),
  );
}

class MyRectangleShape extends RectangleComponent
    with HasGameRef<Exercise1Game> {
  Vector2 velocity;
  final Vector2 screenSize;
  final _random = Random();

  MyRectangleShape({
    required this.screenSize,
    required Vector2 size,
    required this.velocity,
    Paint? paint,
    Vector2? position,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  }) : super(
          size: size,
          paint: paint,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
          position: position,
        ) {
    anchor = Anchor.topLeft;
  }

  double next(int min, int max) =>
      (min + _random.nextInt(max - min)).toDouble();

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity;
    var gameSize = gameRef.size;
    var topLeftPos = position.x;
    var topRightPos = position.y;
    var bottomLeftPos = position.y + size.y;
    var bottomRightPos = position.x + size.x;
    var isHitBoundary = topLeftPos <= 0 ||
        topRightPos >= gameSize.y ||
        bottomLeftPos >= gameSize.x ||
        bottomRightPos >= gameSize.y;

    if (isHitBoundary) {
      print(
          "isHitBoundary $isHitBoundary topLeftPos: $topLeftPos,topRightPos:$topRightPos"
              ",bottomLeftPos:$bottomLeftPos,bottomRightPos:$bottomRightPos");
      var randomVelocity = Vector2(next(-4, 4), next(-4, 4));
      if (randomVelocity == Vector2(0, 0)) {
        velocity = Vector2(0, 1).normalized() * 0.5;
      }
    }
  }
}

class Exercise1Game extends FlameGame with TapDetector, DoubleTapDetector {
  final _random = Random();
  bool running = true;
  final textPaint = TextPaint(
    style: const TextStyle(color: Colors.white, fontSize: 12),
  );

  @override
  bool get debugMode => true;

  double next(int min, int max) =>
      (min + _random.nextInt(max - min)).toDouble();

  @override
  void onTapUp(TapUpInfo info) {
    super.onTapUp(info);
    var tapPosition = info.eventPosition.game;
    final randomPosition =
        Vector2(next(0, size.x.toInt() - 50), next(0, size.y.toInt() - 50));
    var randomVelocity = Vector2(next(-2, 4), next(-2, 4));
    if (randomVelocity == Vector2(0, 0)) {
      randomVelocity = Vector2(0, 1);
    }

    final handled = children.any((component) {
      if (component is MyRectangleShape &&
          component.containsPoint(tapPosition)) {
        remove(component);
        return true;
      }
      return false;
    });

    if (!handled) {
      add(
        MyRectangleShape(
          screenSize: size,
          size: Vector2(50, 50),
          position: tapPosition,
          paint: Paint()..color = Colors.red,
          velocity: randomVelocity.normalized() * 0.5,
        ),
      );
    }
  }

  @override
  void onDoubleTap() {
    super.onDoubleTap();
    if (running) {
      pauseEngine();
    } else {
      resumeEngine();
    }

    running = !running;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    textPaint.render(canvas, "Object: ${children.length}", Vector2(10, 30));
  }
}
