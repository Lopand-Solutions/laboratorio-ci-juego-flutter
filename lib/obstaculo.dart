import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'runner_game.dart';

class Obstaculo extends RectangleComponent with HasGameReference<RunnerGame> {
  Obstaculo({required this.carril})
    : super(
        size: Vector2(80, 40),
        anchor: Anchor.center,
        paint: Paint()..color = const Color(0xFFE5484D),
      );

  final int carril;

  @override
  void onLoad() {
    position = Vector2(game.xDeCarril(carril), -size.y);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    // El jugador no avanza: es el mundo el que viene hacia él.
    position.y += game.velocidad * dt;
    if (position.y > game.size.y + size.y) removeFromParent();
  }
}
