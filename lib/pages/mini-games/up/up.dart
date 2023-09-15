import 'package:dinogrow/pages/mini-games/up/objects/dino.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'objects/floor.dart';

final screenSize = Vector2(1280, 720);

// Scaled viewport size
final worldSize = Vector2(12.8, 7.2);

class UpGame extends Forge2DGame with KeyboardEvents {
  UpGame() : super(zoom: 100, gravity: Vector2(0, 15));
  final _background = _Background(size: screenSize);
  final dino = Dino();

  @override
  Future<void> onLoad() async {
    final camera =
        CameraComponent.withFixedResolution(width: 1280, height: 720);
    final background = _Background(size: screenSize);
    camera.viewport.add(background);
    
  }

  @override
  void onMount() {
    super.onMount();
    add(_background);
    add(FpsTextComponent(
        position: Vector2(0.3, 7.5),
        scale:Vector2(0.01,0.01),
        anchor: Anchor.center,
        windowSize: 1,
        textRenderer: TextPaint(style: const TextStyle(color: Colors.white))));
    add(Floor());
    add(dino);
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set keysPressed) {
    if (event is RawKeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.escape)) {
        // navigator to home
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
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
            GoRouter.of(context).go("/mini_games");
          },
        ),
      ),
      body: GameWidget(game: game),
    );
  }
}
