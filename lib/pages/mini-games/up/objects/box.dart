import 'package:flame/components.dart';

class Box extends SpriteComponent {
  Box() : super(priority: 1);

  Future<void> loadImage() async {
    // load the image to be used as the box
    sprite = await Sprite.load('up/maps/01/box.png');
    width = 0.5;
    height = 0.5;
  }
}