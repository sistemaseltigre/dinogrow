import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:dinogrow/pages/mini-games/up/up.dart';

enum DinoState {
  run,
  dead,
  idle,
  jump,
  walk,
}

class Dino extends BodyComponent with KeyboardHandler {
  final _size = Vector2(1.80, 2.4);
  final _componentPosition = Vector2(0, -.325);
  DinoState state = DinoState.idle;

  late final SpriteComponent runComponent;
  late final SpriteComponent deadComponent;
  late final SpriteComponent idleComponent;
  late final SpriteComponent jumpComponent;
  late final SpriteAnimationComponent walkComponent;

  late Component currentComponent;

  int accelerationX = 0;
  bool isruning = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;

    final run = await gameRef.loadSprite('up/green/run/Run_1.png');
    
    final dead = await gameRef.loadSprite('up/green/run/Run_1.png');
    
    final idle = await gameRef.loadSprite('up/green/run/Run_1.png');
    
    final jump = await gameRef.loadSprite('up/green/run/Run_1.png');
    
    
    final walk0 = await gameRef.loadSprite('up/green/walk/Walk_1.png');
    final walk1 = await gameRef.loadSprite('up/green/walk/Walk_2.png');
    final walk2 = await gameRef.loadSprite('up/green/walk/Walk_3.png');
    final walk3 = await gameRef.loadSprite('up/green/walk/Walk_4.png');
    final walk4 = await gameRef.loadSprite('up/green/walk/Walk_5.png');
    final walk5 = await gameRef.loadSprite('up/green/walk/Walk_6.png');
    final walk6 = await gameRef.loadSprite('up/green/walk/Walk_7.png');
    final walk7 = await gameRef.loadSprite('up/green/walk/Walk_8.png');
    final walk8 = await gameRef.loadSprite('up/green/walk/Walk_9.png');
    final walk9 = await gameRef.loadSprite('up/green/walk/Walk_10.png');

    runComponent = SpriteComponent(
      sprite: run,
      size: _size,
      position: _componentPosition,
      anchor: Anchor.center,
    );

    deadComponent = SpriteComponent(
      sprite: dead,
      size: _size,
      position: _componentPosition,
      anchor: Anchor.center,
    );

    idleComponent = SpriteComponent(
      sprite: idle,
      size: _size,
      position: _componentPosition,
      anchor: Anchor.center,
    );

    jumpComponent = SpriteComponent(
      sprite: jump,
      size: _size,
      position: _componentPosition,
      anchor: Anchor.center,
    );

    final walkAnimation = SpriteAnimation.spriteList([
      walk0,
      walk1,
      walk2,
      walk3,
      walk4,
      walk5,
      walk6,
      walk7,
      walk8,
      walk9,
    ], stepTime: 0.05, loop: true);

    walkComponent = SpriteAnimationComponent(
      animation: walkAnimation,
      anchor: Anchor.center,
      position: _componentPosition,
      size: _size,
      removeOnFinish: false,
    );

    currentComponent = idleComponent;
    add(idleComponent);
  }

  void idle() {
    accelerationX = 0;
    isruning = false;
  }

  void walkLeft() {
    accelerationX = -1;
  }

  void walkRight() {
    accelerationX = 1;
  }

  void run() {
    isruning = true;
  }

  void jump() {
    if (state == DinoState.jump || state == DinoState.dead) return;
    final velocity = body.linearVelocity;
    body.linearVelocity = Vector2(velocity.x, -10);
    state = DinoState.jump;
  }

  @override
  void update(double dt) {
    super.update(dt);

    final velocity = body.linearVelocity;

    if (velocity.y > 0.1) {
      state = DinoState.dead;
    } else if (velocity.y < 0.1 && state != DinoState.jump) {
      if (accelerationX != 0) {
        state = DinoState.walk;
      } else if (isruning) {
        state = DinoState.run;
      } else {
        state = DinoState.idle;
      }
    }

    velocity.x = accelerationX * 3;
    body.linearVelocity = velocity;

    if (state == DinoState.jump) {
      _setComponent(jumpComponent);
    } else if (state == DinoState.dead) {
      _setComponent(deadComponent);
    } else if (state == DinoState.walk) {
      _setComponent(walkComponent);
    } else if (state == DinoState.run) {
      _setComponent(runComponent);
    } else if (state == DinoState.idle) {
      _setComponent(idleComponent);
    }
  }

  void _setComponent(PositionComponent component) {
    if (accelerationX < 0) {
      if (!component.isFlippedHorizontally) {
        component.flipHorizontally();
      }
    } else {
      if (component.isFlippedHorizontally) {
        component.flipHorizontally();
      }
    }

    if (component == currentComponent) return;
    remove(currentComponent);
    currentComponent = component;
    add(component);
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      //position: Vector2(worldSize.x / 2, worldSize.y - 3), change dino position later
      position: Vector2(2, 0),      
      type: BodyType.dynamic,
    );

    final shape = PolygonShape()..setAsBoxXY(_size.x / 2, .90);

    final fixtureDef = FixtureDef(shape)
      ..density = 15
      ..friction = 0
      ..restitution = 0;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}