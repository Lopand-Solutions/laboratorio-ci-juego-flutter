import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_runner/obstaculo.dart';
import 'package:mi_runner/runner_game.dart';

void main() {
  final probar = FlameTester(RunnerGame.new);

  probar.testGameWidget(
    'nunca bloquea los tres carriles',
    verify: (game, tester) async {
      for (var i = 0; i < 200; i++) {
        game.update(RunnerGame.separacion); // pasa el tiempo de una fila
        game.update(0); // se agregan los obstáculos nuevos
        final carriles = game.children
            .whereType<Obstaculo>()
            .where((o) => o.position.y < 0) // solo la fila recién creada
            .map((o) => o.carril)
            .toSet();
        expect(carriles.length, lessThan(3));
        game.removeAll(game.children.whereType<Obstaculo>());
        game.update(0);
      }
    },
  );
}
