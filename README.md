# Laboratorio: CI para tu juego Flutter

Repositorio del laboratorio de [Lopand Academy](https://academy.lopandsolutions.com/tutoriales/laboratorio-ci-juego-flutter).
Es el juego de carriles de [Tu primer juego en Flutter + Flame](https://academy.lopandsolutions.com/tutoriales/primer-juego-flutter-flame),
y aquí le pones un CI con GitHub Actions.

## Ramas

- **`inicio`**: el juego sin CI. Desde aquí empiezas.
- **`main`**: la solución: `tool/check.sh` y `.github/workflows/ci.yml`.

## Cómo saber si quedó

```bash
./tool/comprobar_laboratorio.sh
```

Revisa los archivos, el workflow, que el control frene un error a propósito y que tu código pase.

## Requisitos

Flutter 3.47.8 (`flutter --version`). Si tienes otra, cambia `flutter-version` en el workflow.

Código libre para usar y adaptar (licencia MIT).
