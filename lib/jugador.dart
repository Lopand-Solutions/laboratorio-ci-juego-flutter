import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'obstaculo.dart';
import 'runner_game.dart';

class Jugador extends PositionComponent
    with HasGameReference<RunnerGame>, CollisionCallbacks {
  Jugador() : super(size: Vector2.all(56), anchor: Anchor.center);

  int carril = 0; // -1 izquierda, 0 centro, 1 derecha
  static const double rapidezCambio = 14; // qué tan rápido llega a su carril

  final _pintura = Paint()..color = const Color(0xFFFFB020);

  @override
  void onLoad() {
    position = Vector2(game.xDeCarril(0), game.size.y * 0.8);
    add(CircleHitbox());
  }

  void izquierda() => carril = max(-1, carril - 1);
  void derecha() => carril = min(1, carril + 1);

  @override
  void update(double dt) {
    super.update(dt);
    // No salta de golpe al otro carril: se acerca un poco en cada cuadro.
    final destino = game.xDeCarril(carril);
    position.x += (destino - position.x) * min(1, rapidezCambio * dt);
    position.y = game.size.y * 0.8;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle((size / 2).toOffset(), size.x / 2, _pintura);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Obstaculo) game.chocar();
  }
}
