#!/usr/bin/env bash
# El mismo control en tu computadora y en GitHub Actions.
# En tu computadora el formato se aplica; en CI (CI=true) solo se revisa y falla si algo no está formateado.
set -euo pipefail
cd "$(dirname "$0")/.."

if [ "${CI:-}" = "true" ]; then
  echo "▶ Formato (solo revisa)"
  dart format --output=none --set-exit-if-changed lib test
else
  echo "▶ Formato (lo aplica)"
  dart format lib test
fi

echo "▶ Análisis"
flutter analyze --fatal-infos

echo "▶ Pruebas"
flutter test

echo "✓ Todo en verde"
