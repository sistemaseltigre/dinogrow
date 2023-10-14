import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:dinogrow/pages/mini-games/up/up.dart';

class Floor extends BodyComponent {
  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      position: Vector2(0, worldSize.y - 5.7),
      type: BodyType.static,
    );

    final shape = EdgeShape()..set(Vector2.zero(), Vector2(worldSize.x, 0));

    final fixtureDef = FixtureDef(shape)..friction = .7;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class LeftWall extends BodyComponent {
  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: Vector2(-0.3, 0),
      type: BodyType.static,
    );

    final shape = EdgeShape()..set(Vector2(0, worldSize.y), Vector2.zero());

    final fixtureDef = FixtureDef(shape)..friction = .7;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}

class RightWall extends BodyComponent {
  @override
  Body createBody() {
    final bodyDef = BodyDef(
      position: Vector2(worldSize.x - 3, 0),
      type: BodyType.static,
    );

    final shape = EdgeShape()..set(Vector2(0, worldSize.y), Vector2.zero());

    final fixtureDef = FixtureDef(shape)..friction = .7;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
