import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:dinogrow/pages/mini-games/up/up.dart';

class VirtualPadButtons extends PositionComponent {
  List<PositionComponent> buttons = [];
  List vpadbuttons() {
    RectangleComponent btnLeftCircle;
    final circlePaintLeft = BasicPalette.yellow.paint();
    btnLeftCircle =
        RectangleComponent.square(size: 0.95, paint: circlePaintLeft);
    btnLeftCircle.position = Vector2(0, worldSize.y - 5.7);
    btnLeftCircle.anchor = Anchor.topLeft;
    buttons.add(btnLeftCircle);

    RectangleComponent btnRightCircle;
    final circlePaintRight = BasicPalette.yellow.paint();
    btnRightCircle =
        RectangleComponent.square(size: 0.95, paint: circlePaintRight);
    btnRightCircle.position = Vector2(3, worldSize.y - 5.7);
    btnRightCircle.anchor = Anchor.topLeft;
    buttons.add(btnRightCircle);

    RectangleComponent btnJumpCircle;
    final circlePaintJump = BasicPalette.gray.paint();
    btnJumpCircle =
        RectangleComponent.square(size: 0.95, paint: circlePaintJump);
    btnJumpCircle.position = Vector2(1, worldSize.y - 5.7);
    btnJumpCircle.anchor = Anchor.topLeft;
    buttons.add(btnJumpCircle);

    RectangleComponent btnAttackCircle;
    final circlePaintAttack = BasicPalette.gray.paint();
    btnAttackCircle =
        RectangleComponent.square(size: 0.95, paint: circlePaintAttack);
    btnAttackCircle.position = Vector2(2, worldSize.y - 5.7);
    btnAttackCircle.anchor = Anchor.topLeft;
    buttons.add(btnAttackCircle);

    final btnStyleLetters = TextPaint(
        style: const TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontFamily: 'ComicNeue Bold',
    ));

    final textJump = TextComponent(
      text: 'J',
      textRenderer: btnStyleLetters,
      position: Vector2(2.7, 6.3),
    );

    buttons.add(textJump);

    final textAttack = TextComponent(
      text: 'A',
      textRenderer: btnStyleLetters,
      position: Vector2(3, 6.8),
      priority: 1,
    );

    buttons.add(textAttack);

    return buttons;
  }
}
