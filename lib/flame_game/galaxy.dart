import 'package:flame/components.dart';

import 'code.dart';

class Galaxy extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('bg.gif');

    position = gameRef.size / 2;
    width = gameRef.size.x;
    height = gameRef.size.y;
    anchor = Anchor.center;
  }

  // void move(Vector2 delta) {
  //   position.add(delta);
  // }
}
