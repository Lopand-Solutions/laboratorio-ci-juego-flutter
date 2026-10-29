import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'jugador.dart';
import 'obstaculo.dart';

enum EstadoJuego { jugando, fin }

class RunnerGame extends FlameGame
    with DragCallbacks, KeyboardEvents, HasCollisionDetection {
  static const double velocidadInicial = 300; // píxeles por segundo
  static const double aceleracion = 8; // cuánto sube la velocidad cada segundo
  static const double separacion = 1.1; // segundos entre filas de obstáculos

  late final Jugador jugador;
  final puntaje = ValueNotifier<int>(0);
  final _azar = Random();

  EstadoJuego estado = EstadoJuego.jugando;
  double velocidad = velocidadInicial;
  double _distancia = 0;
  double _paraSiguienteFila = separacion;

  /// Ancho de un carril: la pantalla dividida en tres.
  double get anchoCarril => size.x / 3;

  /// Posición horizontal del centro de un carril (-1, 0 o 1).
  double xDeCarril(int carril) => size.x / 2 + carril * anchoCarril;

  @override
  Color backgroundColor() => const Color(0xFF1B2A3A);

  @override
  void onLoad() {
    jugador = Jugador();
    add(jugador);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (estado != EstadoJuego.jugando) return;

    velocidad += aceleracion * dt;
    _distancia += velocidad * dt;
    puntaje.value = (_distancia / 100).floor(); // 100 píxeles = 1 metro

    _paraSiguienteFila -= dt;
    if (_paraSiguienteFila <= 0) {
      _paraSiguienteFila = separacion;
      _crearFila();
    }
  }

  /// Pone obstáculos en 1 o 2 carriles, nunca en los 3:
  /// siempre debe existir un camino libre.
  void _crearFila() {
    final carriles = [-1, 0, 1]..shuffle(_azar);
    final cuantos = 1 + _azar.nextInt(2); // 1 o 2
    for (final carril in carriles.take(cuantos)) {
      add(Obstaculo(carril: carril));
    }
  }

  void chocar() {
    if (estado == EstadoJuego.fin) return;
    estado = EstadoJuego.fin;
    pauseEngine();
    overlays.add('gameOver');
  }

  void reiniciar() {
    removeAll(children.whereType<Obstaculo>());
    jugador.carril = 0;
    velocidad = velocidadInicial;
    _distancia = 0;
    _paraSiguienteFila = separacion;
    puntaje.value = 0;
    estado = EstadoJuego.jugando;
    overlays.remove('gameOver');
    resumeEngine();
  }

  // ---------- Deslizar el dedo ----------
  final _deslizamiento = Vector2.zero();
  bool _gestoUsado = false;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _deslizamiento.setZero();
    _gestoUsado = false;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    _deslizamiento.add(event.localDelta);
    // Se decide en cuanto el dedo recorre 30 píxeles, no al soltar:
    // así el juego responde al instante. Un gesto = una acción.
    if (_gestoUsado || _deslizamiento.x.abs() < 30) return;
    _gestoUsado = true;
    _deslizamiento.x > 0 ? jugador.derecha() : jugador.izquierda();
  }

  // ---------- Teclado (para probar en el emulador o en la web) ----------
  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      jugador.izquierda();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      jugador.derecha();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
