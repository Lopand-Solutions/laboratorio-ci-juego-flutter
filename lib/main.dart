import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'runner_game.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: PantallaJuego()),
  );
}

class PantallaJuego extends StatefulWidget {
  const PantallaJuego({super.key});

  @override
  State<PantallaJuego> createState() => _PantallaJuegoState();
}

class _PantallaJuegoState extends State<PantallaJuego> {
  // El juego se crea UNA vez. Si lo crearas dentro de build(), se
  // reiniciaría cada vez que Flutter redibuja la pantalla.
  final juego = RunnerGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: juego,
        overlayBuilderMap: {
          'puntaje': (context, RunnerGame juego) => Puntaje(juego: juego),
          'gameOver': (context, RunnerGame juego) => FinDelJuego(juego: juego),
        },
        initialActiveOverlays: const ['puntaje'],
      ),
    );
  }
}

class Puntaje extends StatelessWidget {
  const Puntaje({super.key, required this.juego});
  final RunnerGame juego;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<int>(
          valueListenable: juego.puntaje,
          builder: (context, valor, _) => Text(
            '$valor m',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class FinDelJuego extends StatelessWidget {
  const FinDelJuego({super.key, required this.juego});
  final RunnerGame juego;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '¡Chocaste!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Llegaste a ${juego.puntaje.value} m'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: juego.reiniciar,
                child: const Text('Jugar otra vez'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
