import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class MatrixTextComponent<T extends TextRenderer> extends PositionComponent {
  String _text;
  T _textRenderer;
  int index = 0;
  int bottomColorIdx = 0;

  String get text => _text;

  set text(String text) {
    if (_text != text) {
      _text = text;
      updateBounds();
    }
  }

  T get textRenderer => _textRenderer;

  set textRenderer(T textRenderer) {
    _textRenderer = textRenderer;
    updateBounds();
  }

  MatrixTextComponent({
    String? text,
    T? textRenderer,
    required this.index,
    Vector2? position,
    Vector2? size,
    Vector2? scale,
    double? angle,
    Anchor? anchor,
    int? priority,
  })  : _text = text ?? '',
        _textRenderer = textRenderer ?? TextRenderer.createDefault<T>(),
        super(
          position: position,
          size: size,
          scale: scale,
          angle: angle,
          anchor: anchor,
          priority: priority,
        ) {
    updateBounds();
  }

  void updateBounds() {
    final expectedSize = textRenderer.measureText(_text);
    size.setValues(expectedSize.x, expectedSize.y);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    _textRenderer.render(canvas, text, Vector2.zero());
  }
}
