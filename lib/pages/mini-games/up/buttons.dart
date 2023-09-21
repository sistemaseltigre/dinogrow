import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class VirtualPadButtons extends PositionComponent {
  List<PositionComponent> buttons = [];
  List vpadbuttons() {
    CircleComponent btnLeftCircle;
    final circlePaintLeft = BasicPalette.gray.paint();
    btnLeftCircle = CircleComponent(radius: 0.15, paint: circlePaintLeft);
    btnLeftCircle.position = Vector2(0.3, 6.8);
    btnLeftCircle.anchor = Anchor.topLeft;
    buttons.add(btnLeftCircle);

    CircleComponent btnRightCircle;
    final circlePaintRight = BasicPalette.gray.paint();
    btnRightCircle = CircleComponent(radius: 0.15, paint: circlePaintRight);
    btnRightCircle.position = Vector2(1, 6.8);
    btnRightCircle.anchor = Anchor.topLeft;
    buttons.add(btnRightCircle);

    CircleComponent btnJumpCircle;
    final circlePaintJump = BasicPalette.gray.paint();
    btnJumpCircle = CircleComponent(radius: 0.15, paint: circlePaintJump);
    btnJumpCircle.position = Vector2(2.7, 6.3);
    btnJumpCircle.anchor = Anchor.topLeft;
    buttons.add(btnJumpCircle);

    CircleComponent btnAttackCircle;
    final circlePaintAttack =
        BasicPalette.gray.paint();
    btnAttackCircle = CircleComponent(radius: 0.15, paint: circlePaintAttack);
    btnAttackCircle.position = Vector2(3, 6.8);
    btnAttackCircle.anchor = Anchor.topLeft;
    buttons.add(btnAttackCircle);

    final btnStyleLetters = TextPaint(
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontFamily: 'ComicNeue Bold',
      )
    );

    final textJump = TextComponent(
      text:'J',
      textRenderer: btnStyleLetters,
      position: Vector2(2.7, 6.3),
    );

    buttons.add(textJump);

    final textAttack = TextComponent(
      text:'A',
      textRenderer: btnStyleLetters,
      position: Vector2(3, 6.8),
      priority: 1,
    );
  
    buttons.add(textAttack);

    return buttons;
  }
}
