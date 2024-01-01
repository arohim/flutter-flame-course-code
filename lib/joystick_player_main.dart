import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_squares/bullet.dart';
import 'package:flame_squares/utils.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(GameWidget(game: JoyStickGame()));
}

class JoyStickGame extends FlameGame with HasDraggables, HasTappables {
  late final JoystickComponent joyStick;
  late final JoystickPlayer joystickPlayer;
  var shipAngleTextPaint = TextPaint();

  @override
  Future<void>? onLoad() {
    final knobPaint = BasicPalette.green.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.green.withAlpha(100).paint();

    joyStick = JoystickComponent(
      knob: CircleComponent(paint: knobPaint, radius: 15),
      background: CircleComponent(radius: 50, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 20, bottom: 20),
    );

    joystickPlayer = JoystickPlayer(joyStick);

    add(joyStick);
    add(joystickPlayer);
    return super.onLoad();
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);
    var velocity = Vector2(0, -1);
    velocity.rotate(joystickPlayer.angle);
    add(Bullet(joystickPlayer.position, velocity));
    super.onTapUp(pointerId, info);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    shipAngleTextPaint.render(
      canvas,
      '${joystickPlayer.angle.toStringAsFixed(5)} radians obc: ${children.length}',
      Vector2(20, size.y - 40),
    );
  }
}

class JoystickPlayer extends SpriteComponent with HasGameRef {
  /// Max speed in Pixels/s
  double maxSpeed = 300.0;

  @override
  bool get debugMode => true;

  //
  // this gives the player component access to the Joystick data
  final JoystickComponent joystick;

  //
  // constructor which aggregates the Joystick access
  JoystickPlayer(this.joystick)
      : super(
          size: Vector2.all(50.0),
        ) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //
    // ship png comes from Kenny
    // https://www.kenney.nl/assets
    //
    sprite = await gameRef.loadSprite('asteroids_ship.png');
    position = gameRef.size / 2;
  }

  @override
  void update(double dt) {
    //
    // if the joystick has moved
    if (!joystick.delta.isZero()) {
      // TODO: trying to set boundary, but wasn't work yet
      // var gameSize = gameRef.size;
      // var head = position.y;
      // var isInBoundary = head >= 0 && head <= gameSize.y;
      // if (isInBoundary) {
      //   position.add(joystick.relativeDelta * maxSpeed * dt);
      // }
      // print("isInBoundary:$isInBoundary angle:$angle head:$head");

      position.add(joystick.relativeDelta * maxSpeed * dt);
      angle = joystick.delta.screenAngle();
      if (Utils.isPositionOutOfBounds(gameRef.size, position)) {
        position = Utils.wrapPosition(gameRef.size, position);
      }
    }
  }
}
