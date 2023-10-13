import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

enum DinoState {
  run,
  dead,
  idle,
  jump,
  walk,
}

class Dino extends BodyComponent with KeyboardHandler {
  final _size = Vector2(1.70, 2.4);
  // componentPosition is the position of the dino in the screen
  final _componentPosition = Vector2(0, 0);
  DinoState state = DinoState.idle;

  late final SpriteAnimationComponent runComponent;
  late final SpriteAnimationComponent deadComponent;
  late final SpriteAnimationComponent idleComponent;
  late final SpriteAnimationComponent jumpComponent;
  late final SpriteAnimationComponent walkComponent;

  late PositionComponent currentComponent;

  int accelerationX = 0;
  int dinoDirecction = 0;
  int walkStep = 0;
  bool isruning = false;
  bool walkingAnimationStarted = false;
  bool walking = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;

    final run0 = await gameRef.loadSprite('up/green/run/Run_1.png');
    final run1 = await gameRef.loadSprite('up/green/run/Run_2.png');
    final run2 = await gameRef.loadSprite('up/green/run/Run_3.png');
    final run3 = await gameRef.loadSprite('up/green/run/Run_4.png');
    final run4 = await gameRef.loadSprite('up/green/run/Run_5.png');
    final run5 = await gameRef.loadSprite('up/green/run/Run_6.png');
    final run6 = await gameRef.loadSprite('up/green/run/Run_7.png');
    final run7 = await gameRef.loadSprite('up/green/run/Run_8.png');

    final dead0 = await gameRef.loadSprite('up/green/dead/Dead_1.png');
    final dead1 = await gameRef.loadSprite('up/green/dead/Dead_2.png');
    final dead2 = await gameRef.loadSprite('up/green/dead/Dead_3.png');
    final dead3 = await gameRef.loadSprite('up/green/dead/Dead_4.png');
    final dead4 = await gameRef.loadSprite('up/green/dead/Dead_5.png');
    final dead5 = await gameRef.loadSprite('up/green/dead/Dead_6.png');
    final dead6 = await gameRef.loadSprite('up/green/dead/Dead_7.png');
    final dead7 = await gameRef.loadSprite('up/green/dead/Dead_8.png');

    final idle0 = await gameRef.loadSprite('up/green/idle/Idle_1.png');
    final idle1 = await gameRef.loadSprite('up/green/idle/Idle_2.png');
    final idle2 = await gameRef.loadSprite('up/green/idle/Idle_3.png');
    final idle3 = await gameRef.loadSprite('up/green/idle/Idle_4.png');
    final idle4 = await gameRef.loadSprite('up/green/idle/Idle_5.png');
    final idle5 = await gameRef.loadSprite('up/green/idle/Idle_6.png');
    final idle6 = await gameRef.loadSprite('up/green/idle/Idle_7.png');
    final idle7 = await gameRef.loadSprite('up/green/idle/Idle_8.png');
    final idle8 = await gameRef.loadSprite('up/green/idle/Idle_9.png');
    final idle9 = await gameRef.loadSprite('up/green/idle/Idle_10.png');

    final jump0 = await gameRef.loadSprite('up/green/jump/Jump_1.png');
    final jump1 = await gameRef.loadSprite('up/green/jump/Jump_2.png');
    final jump2 = await gameRef.loadSprite('up/green/jump/Jump_3.png');
    final jump3 = await gameRef.loadSprite('up/green/jump/Jump_4.png');
    final jump4 = await gameRef.loadSprite('up/green/jump/Jump_5.png');
    final jump5 = await gameRef.loadSprite('up/green/jump/Jump_6.png');
    final jump6 = await gameRef.loadSprite('up/green/jump/Jump_7.png');
    final jump7 = await gameRef.loadSprite('up/green/jump/Jump_8.png');
    final jump8 = await gameRef.loadSprite('up/green/jump/Jump_9.png');
    final jump9 = await gameRef.loadSprite('up/green/jump/Jump_10.png');
    final jump10 = await gameRef.loadSprite('up/green/jump/Jump_11.png');
    final jump11 = await gameRef.loadSprite('up/green/jump/Jump_12.png');

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

    final runAnimation = SpriteAnimation.spriteList([
      run0,
      run1,
      run2,
      run3,
      run4,
      run5,
      run6,
      run7,
    ], stepTime: 0.05, loop: false);

    final deadAnimation = SpriteAnimation.spriteList([
      dead0,
      dead1,
      dead2,
      dead3,
      dead4,
      dead5,
      dead6,
      dead7,
    ], stepTime: 0.05, loop: false);

    final idleAnimation = SpriteAnimation.spriteList([
      idle0,
      idle1,
      idle2,
      idle3,
      idle4,
      idle5,
      idle6,
      idle7,
      idle8,
      idle9,
    ], stepTime: 0.05, loop: true);

    final jumpAnimation = SpriteAnimation.spriteList([
      jump0,
      jump1,
      jump2,
      jump3,
      jump4,
      jump5,
      jump6,
      jump7,
      jump8,
      jump9,
      jump10,
      jump11,
    ], stepTime: 0.05, loop: false);

    runComponent = SpriteAnimationComponent(
      animation: runAnimation,
      size: _size,
      position: _componentPosition,
      anchor: Anchor.center,
    );

    deadComponent = SpriteAnimationComponent(
      animation: deadAnimation,
      size: _size,
      position: _componentPosition,
      anchor: Anchor.center,
    );

    idleComponent = SpriteAnimationComponent(
      animation: idleAnimation,
      size: _size,
      position: _componentPosition,
      anchor: Anchor.center,
    );

    jumpComponent = SpriteAnimationComponent(
      animation: jumpAnimation,
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
    walking = true;
  }

  void walkRight() {
    accelerationX = 1;
    walking = true;
  }

  void run() {
    isruning = true;
  }

  void jump() {
    if (state == DinoState.jump || state == DinoState.dead) return;
    final velocity = body.linearVelocity;
    body.linearVelocity = Vector2(velocity.x, -6);
    state = DinoState.jump;
  }

  @override
  void update(double dt) {
    super.update(dt);

    final velocity = body.linearVelocity;
    if (velocity.y > 0.1) {
    } else if (velocity.y < 0.1 && state != DinoState.jump) {
      if (accelerationX != 0 && walking == true) {
        state = DinoState.walk;
        walkStep++;
        if (walkStep == 10) {
          walking = false;
          walkStep = 0;
        }
      } else if (isruning) {
        state = DinoState.run;
      } else {
        state = DinoState.idle;
      }
    } else if (velocity.y > 0.0 &&
        state == DinoState.jump &&
        state != DinoState.walk) {
      state = DinoState.idle;
    }
    if (walking == true && walkStep != 0) {
      velocity.x = accelerationX * 3;
      body.linearVelocity = velocity;
    } else {
      velocity.x = 0;
      body.linearVelocity = velocity;
    }

    if (state == DinoState.jump) {
      _setComponent(jumpComponent, accelerationX);
    } else if (state == DinoState.dead) {
      _setComponent(deadComponent, accelerationX);
    } else if (state == DinoState.walk) {
      _setComponent(walkComponent, accelerationX);
    } else if (state == DinoState.run) {
      _setComponent(runComponent, accelerationX);
    } else if (state == DinoState.idle) {
      _setComponent(idleComponent, accelerationX);
    }
  }

  void _setComponent(PositionComponent component, int xAcceleration) {
    if (xAcceleration < 0) {
      if (!component.isFlippedHorizontally) {
        component.flipHorizontally();
      }
    } else if (xAcceleration > 0) {
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
      position: Vector2(2, 3),
      type: BodyType.dynamic,
    );

    final shape = PolygonShape()..setAsBoxXY(.4, .9);

    final fixtureDef = FixtureDef(shape)
      ..density = 0
      ..friction = 0
      ..restitution = 0;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
