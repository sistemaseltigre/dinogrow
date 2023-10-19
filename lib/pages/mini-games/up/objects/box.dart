import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'dino.dart';

class Box extends BodyComponent with ContactCallbacks {
  final Function onCollisionBox;
  final Function onCollisionDino;
  final Vector2 worldSize;

  Box(this.onCollisionBox, this.onCollisionDino, this.worldSize)
      : super(priority: 1);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      SpriteComponent(
        sprite: await Sprite.load('up/maps/01/box.png'),
        size: Vector2(1, 1),
        position: Vector2(-.5, -.5),
      ),
    );
  }

  @override
  void beginContact(Object other, Contact contact) {
    removeFromParent();
    if (other is Dino) {
      onCollisionDino();
    }
    onCollisionBox();
  }

  @override
  Body createBody() {
    final rnd = Random();
    final xpos = (rnd.nextDouble() * (worldSize.x - 0.5)).abs();
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(
          xpos > 0.6
              ? (xpos < (worldSize.x - 0.5) ? (xpos) : worldSize.x - 0.5)
              : 0.6,
          -1),
      type: BodyType.dynamic,
      gravityOverride: Vector2(0, rnd.nextDouble() * 3 + 2),
    );

    final shape = PolygonShape()..setAsBoxXY(.5, .5);

    final fixtureDef = FixtureDef(shape)
      ..density = 0
      ..friction = 0
      ..restitution = 0;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class BoxFloor extends SpriteComponent {
  BoxFloor() : super(priority: 1);

  Future<void> loadImage() async {
    // load the image to be used as the box
    sprite = await Sprite.load('up/maps/01/box.png');
    width = 1;
    height = 1;
  }
}

class LeftFloor extends SpriteComponent {
  LeftFloor() : super(priority: 1);

  Future<void> loadImage() async {
    sprite = await Sprite.load('up/maps/01/left_btn.png');
    width = 1;
    height = 1;
  }
}

class RightFloor extends SpriteComponent {
  RightFloor() : super(priority: 1);

  Future<void> loadImage() async {
    sprite = await Sprite.load('up/maps/01/right_btn.png');
    width = 1;
    height = 1;
  }
}
