import 'package:dinogrow/pages/mini-games/up/buttons.dart';
import 'package:dinogrow/pages/mini-games/up/objects/dino.dart';
import 'package:flame/palette.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'objects/floor.dart';
import 'objects/box.dart';
import 'package:flame/timer.dart' as timer_flame;

final screenSize = Vector2(720, 1280);

// Scaled viewport size
final worldSize = Vector2(7.2, 12.8);

class DownGame extends Forge2DGame with TapDetector {
  // setup the game camera to match the device size
  DownGame() : super(zoom: 100, gravity: Vector2(0, 15));

  //get the dino object and sprite animation
  final dino = Dino();

  //set initial state of the game buttons
  bool isJumpPressed = false;
  bool isLeftPressed = false;
  bool isRightPressed = false;
  bool isAttackPressed = false;

  //Timer callbacks
  timer_flame.Timer timer = timer_flame.Timer(0);

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
  bool isInsideButton(Vector2 tapPosition, RectangleComponent button) {
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
      btnLeft.paint.color = const Color.fromARGB(255, 91, 92, 91);
      dino.walkLeft();

      timer =
          timer_flame.Timer(0.25, onTick: () => dino.walkLeft(), repeat: true);
    }
    if (isRightPressed) {
      dino.walkRight();
      btnRight.paint.color = const Color.fromARGB(255, 91, 92, 91);

      timer =
          timer_flame.Timer(0.25, onTick: () => dino.walkRight(), repeat: true);
    }
    // if (isJumpPressed) {
    //   dino.jump();
    //   score += 10;
    //   scoreText.text = 'Score: ${score.toString().padLeft(3, '0')}';
    //   btnJump.paint.color = const Color.fromARGB(255, 91, 92, 91);
    // }
    // if (isAttackPressed) {
    //   dino.run();
    //   btnAttack.paint.color = const Color.fromARGB(255, 91, 92, 91);
    // }

    return true;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    if (isLeftPressed) {
      isLeftPressed = false;
      btnLeft.paint.color = BasicPalette.yellow.color;
    }
    if (isRightPressed) {
      isRightPressed = false;
      btnRight.paint.color = BasicPalette.yellow.color;
    }
    // if (isJumpPressed) {
    //   isJumpPressed = false;
    //   btnJump.paint.color = BasicPalette.gray.color;
    // }
    // if (isAttackPressed) {
    //   isAttackPressed = false;
    //   btnAttack.paint.color = BasicPalette.gray.color;
    // }
    timer.stop();

    return true;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final camera =
        CameraComponent.withFixedResolution(width: 720, height: 1280);
    final background = _Background(size: screenSize);
    camera.viewport.add(background);
    if (dino.isLoaded) {
      camera.follow(dino.currentComponent, verticalOnly: true);
    }
    // camera.follow(dino.c,verticalOnly: true);

    // add(FpsTextComponent(
    //     position: Vector2(0, 7.8),
    //     scale: Vector2(0.01, 0.01),
    //     anchor: Anchor.topLeft,
    //     windowSize: 60,
    //     textRenderer: TextPaint(style: const TextStyle(color: Colors.white))));

    add(Floor());
    add(LeftWall());
    add(RightWall());

    //Testing
    // Add instance of Box

    finishGame() {
      print('End game with $score points in score');
    }

    newBoxAndScore() {
      score += 10;
      scoreText.text = 'Score: ${score.toString().padLeft(3, '0')}';
      add(Box(newBoxAndScore, finishGame));
    }

    add(Box(newBoxAndScore, finishGame));

    // add the player to the game
    add(dino);

    // add the buttons to the game
    add(btnLeft);
    add(btnRight);
    // add(btnJump);
    // add(btnAttack);
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
  Color backgroundColor() => const Color(0x00077777);

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
  }
}

class _Background extends PositionComponent {
  _Background({super.size});
  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y),
        Paint()..color = const Color.fromARGB(255, 56, 53, 53));
  }
}

class GameWidgetDown extends StatelessWidget {
  final DownGame game;

  const GameWidgetDown({super.key, required this.game});

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
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/up/maps/01/up_map_1.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: GameWidget(game: game),
      ),
    );
  }
}
