import 'package:flame_forge2d/flame_forge2d.dart';

class Floor extends BodyComponent {
  final Vector2 worldSize;
  Floor(this.worldSize);

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(0, worldSize.y - 1),
      type: BodyType.static,
    );

    final shape = EdgeShape()..set(Vector2.zero(), Vector2(worldSize.x, 0));

    final fixtureDef = FixtureDef(shape)..friction = .7;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class LeftWall extends BodyComponent {
  final Vector2 worldSize;
  LeftWall(this.worldSize);

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: Vector2(0, 0),
      type: BodyType.static,
    );

    final shape = EdgeShape()..set(Vector2(0, worldSize.y), Vector2.zero());

    final fixtureDef = FixtureDef(shape)..friction = .7;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class RightWall extends BodyComponent {
  final Vector2 worldSize;
  RightWall(this.worldSize);

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: Vector2(worldSize.x, 0),
      type: BodyType.static,
    );

    final shape = EdgeShape()..set(Vector2(0, worldSize.y), Vector2.zero());

    final fixtureDef = FixtureDef(shape)..friction = .7;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
