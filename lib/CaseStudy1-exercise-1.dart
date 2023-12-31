import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'utils.dart';

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
        );

  double next(int min, int max) =>
      (min + _random.nextInt(max - min)).toDouble();

  @override
  Future<void>? onLoad() {
    anchor = Anchor.center;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity;

    // remove this component when it gone from the screen
    var gameSize = gameRef.size;
    var top = position.y - (size.y / 2.0) - 20.0;
    var left = position.x - (size.x / 2.0) - 20.0;
    var right = position.x + (size.x / 2.0) + 20.0;
    var bottom = position.y + (size.y / 2.0) + 20.0;
    var isOffTheScreen =
        top >= gameSize.y || left >= gameSize.x || bottom <= 0 || right <= 0;
    if (isOffTheScreen) {
      parent?.remove(this);
    }
    // experiment random velocity when it hit bounds
    // var gameSize = gameRef.size;
    // var topLeftPos = position.x;
    // var topRightPos = position.x + size.x;
    // var bottomLeftPos = position.y + size.y;
    // var bottomRightPos = position.x + size.x + size.y;
    // var isHitBoundary = topLeftPos <= 0 ||
    //     topRightPos >= gameSize.x ||
    //     topRightPos <= 0 ||
    //     bottomLeftPos <= 0 ||
    //     bottomLeftPos >= gameSize.y ||
    //     bottomRightPos >= gameSize.x ||
    //     bottomRightPos >= gameSize.y;
    //
    // if (isHitBoundary) {
    //   print(
    //       "isHitBoundary $isHitBoundary topLeftPos: $topLeftPos,topRightPos:$topRightPos"
    //       ",bottomLeftPos:$bottomLeftPos,bottomRightPos:$bottomRightPos");
    //   velocity = Utils.generateRandomVelocity(gameRef.size, 10, 15);
    // }
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
    final randomPosition = Utils.generateRandomPosition(size, Vector2(20, 20));
    var randomVelocity = Utils.generateRandomVelocity(size, 10, 15);

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
