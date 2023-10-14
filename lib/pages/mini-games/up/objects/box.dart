import 'dart:math';

import 'package:dinogrow/pages/mini-games/up/objects/floor.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'dino.dart';

class Box extends BodyComponent with ContactCallbacks {
  final Function onCollisionBox;
  final Function onCollisionDino;

  Box(this.onCollisionBox, this.onCollisionDino) : super(priority: 1);

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
    if (other is Floor) {
      onCollisionBox();
    } else if (other is Dino) {
      onCollisionDino();
    }
  }

  @override
  Body createBody() {
    final rnd = Random();

    final bodyDef = BodyDef(
      userData: this,
      //position: Vector2(worldSize.x / 2, worldSize.y - 3), change dino position later
      position: Vector2(rnd.nextDouble() * 2.5, -1),
      type: BodyType.dynamic,
      gravityOverride: Vector2(0, rnd.nextDouble() * 3 + 1),
    );

    final shape = PolygonShape()..setAsBoxXY(.5, .5);

    final fixtureDef = FixtureDef(shape)
      ..density = 0
      ..friction = 0
      ..restitution = 0;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
