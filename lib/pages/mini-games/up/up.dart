import 'package:dinogrow/pages/mini-games/up/buttons.dart';
import 'package:dinogrow/pages/mini-games/up/objects/dino.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'objects/floor.dart';
import 'objects/box.dart';

final screenSize = Vector2(720, 1280);

// Scaled viewport size
final worldSize = Vector2(7.2, 12.8);

class UpGame extends Forge2DGame with TapDetector {
  // setup the game camera to match the device size
  UpGame() : super(zoom: 100, gravity: Vector2(0, 15));

  //get the dino object and sprite animation
  final dino = Dino();

  //set initial state of the game buttons
  bool isJumpPressed = false;
  bool isLeftPressed = false;
  bool isRightPressed = false;
  bool isAttackPressed = false;

  //set initial score
  int score = 0;
  late TextComponent scoreText;

  // get the buttons
  final btnLeft = VirtualPadButtons().vpadbuttons()[0];
  final btnRight = VirtualPadButtons().vpadbuttons()[1];
  final btnJump = VirtualPadButtons().vpadbuttons()[2];
  final btnAttack = VirtualPadButtons().vpadbuttons()[3];
  final btnJumpText = VirtualPadButtons().vpadbuttons()[4];
  final btnAttackText = VirtualPadButtons().vpadbuttons()[5];

  // check and verify if the button is pressed
  bool isInsideButton(Vector2 tapPosition, CircleComponent button) {
    final buttonRect = button.toRect();
    return buttonRect.contains(tapPosition.toOffset());
  }

  @override
  bool onTapDown(TapDownInfo info) {
    final tapPosition = info.eventPosition.game;

    if (isInsideButton(tapPosition, btnLeft)) {
      isLeftPressed = true;
    }
    if (isInsideButton(tapPosition, btnRight)) {
      isRightPressed = true;
    }
    if (isInsideButton(tapPosition, btnJump)) {
      isJumpPressed = true;
    }
    if (isInsideButton(tapPosition, btnAttack)) {
      isAttackPressed = true;
    }

    if (isLeftPressed) {
      dino.walkLeft();
      btnLeft.paint.color = const Color.fromARGB(255, 91, 92, 91);
    }
    if (isRightPressed) {
      dino.walkRight();
      btnRight.paint.color = const Color.fromARGB(255, 91, 92, 91);
    }
    if (isJumpPressed) {
      dino.jump();
      score += 10;
      scoreText.text = 'Score: ${score.toString().padLeft(3, '0')}';
      btnJump.paint.color = const Color.fromARGB(255, 91, 92, 91);
    }
    if (isAttackPressed) {
      dino.run();
      btnAttack.paint.color = const Color.fromARGB(255, 91, 92, 91);
    }

    return true;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    if (isLeftPressed) {
      isLeftPressed = false;
      btnLeft.paint.color = const Color.fromARGB(255, 182, 113, 113);
    }
    if (isRightPressed) {
      isRightPressed = false;
      btnRight.paint.color = const Color.fromARGB(255, 182, 113, 113);
    }
    if (isJumpPressed) {
      isJumpPressed = false;
      btnJump.paint.color = const Color.fromARGB(255, 182, 113, 113);
    }
    if (isAttackPressed) {
      isAttackPressed = false;
      btnAttack.paint.color = const Color.fromARGB(255, 182, 113, 113);
    }

    return true;
  }

  @override
  Future<void> onLoad() async {
    final camera =
        CameraComponent.withFixedResolution(width: 720, height: 1280);
    final background = _Background(size: screenSize);
    camera.viewport.add(background);
    if (dino.isLoaded) {
      camera.follow(dino.currentComponent, verticalOnly: true);
    }
    // camera.follow(dino.c,verticalOnly: true);
    add(FpsTextComponent(
        position: Vector2(0, 7.8),
        scale: Vector2(0.01, 0.01),
        anchor: Anchor.topLeft,
        windowSize: 60,
        textRenderer: TextPaint(style: const TextStyle(color: Colors.white))));

    add(Floor());

    //Testing
    // Add instance of Box
    final box = Box()
      ..x = 0
      ..y = 5.5;
    await box.loadImage();
    add(box);

    // add the player to the game
    add(dino);

    // add the buttons to the game
    add(btnLeft);
    add(btnRight);
    add(btnJump);
    add(btnAttack);
    add(btnJumpText);
    add(btnAttackText);

    // Score text
    final btnStyleLetters = TextPaint(
        style: const TextStyle(
      fontSize: 0.2,
      color: Colors.white,
      fontFamily: 'ComicNeue Bold',
    ));

    scoreText = TextComponent(
      text: 'Score: 000',
      anchor: Anchor.topRight,
      position: Vector2(3.7, 0.65),
      textRenderer: btnStyleLetters,
    );

    add(scoreText);
  }

  @override
  Color backgroundColor() => const Color(0xBF077777);
}

class _Background extends PositionComponent {
  _Background({super.size});
  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y),
        Paint()..color = const Color.fromARGB(255, 56, 53, 53));
  }
}

class GameWidgetUp extends StatelessWidget {
  final UpGame game;

  const GameWidgetUp({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: GameWidget(game: game),
    );
  }
}
