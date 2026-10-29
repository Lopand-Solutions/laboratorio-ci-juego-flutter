#!/usr/bin/env bash
# Comprueba el laboratorio «CI para tu juego Flutter». Uso: ./tool/comprobar_laboratorio.sh
# No toca tu código: las pruebas de «romper» usan archivos temporales que se borran al terminar.
set -uo pipefail
cd "$(dirname "$0")/.."
WF=.github/workflows/ci.yml
ok=0; mal=0
bien() { echo "  ✓ $1"; ok=$((ok + 1)); }
falla() { echo "  ✗ $1"; mal=$((mal + 1)); }
limpiar() { rm -f lib/zz_laboratorio_formato.dart lib/zz_laboratorio_analisis.dart; }
trap limpiar EXIT

echo "1. Archivos"
[ -x tool/check.sh ] && bien "tool/check.sh existe y se puede ejecutar" || falla "tool/check.sh no existe o le falta chmod +x"
[ -f "$WF" ] && bien "$WF existe" || falla "falta $WF"

echo "2. El workflow"
if [ -f "$WF" ]; then
  grep -q "tool/check.sh" "$WF" && bien "corre el mismo harness que tu computadora" || falla "el workflow no llama a tool/check.sh"
  grep -q "enforce-lockfile" "$WF" && bien "instala exactamente las dependencias del pubspec.lock" || falla "falta --enforce-lockfile en flutter pub get"
  grep -qE "^permissions:" "$WF" && bien "limita los permisos del token" || falla "falta el bloque permissions:"
  grep -q "CI: 'true'" "$WF" && bien "le avisa al harness que está en CI" || falla "falta env CI: 'true' en el paso del harness"
  local_v=$(flutter --version 2>/dev/null | head -1 | awk '{print $2}')
  grep -q "flutter-version: '$local_v'" "$WF" && bien "usa Flutter $local_v, igual que tu computadora" || falla "flutter-version del workflow no es $local_v (tu versión local)"
fi

echo "3. El harness detecta errores (se rompe a propósito)"
if [ ! -x tool/check.sh ]; then
  falla "sin tool/check.sh no hay nada que pruebe tu código"
else
printf "int  mal( ){return 1;}\n" > lib/zz_laboratorio_formato.dart
if CI=true ./tool/check.sh >/dev/null 2>&1; then falla "un archivo mal formateado pasó el control"; else bien "un archivo mal formateado lo frena"; fi
rm -f lib/zz_laboratorio_formato.dart
printf "import 'dart:math';\n\nvoid nada() {}\n" > lib/zz_laboratorio_analisis.dart
if CI=true ./tool/check.sh >/dev/null 2>&1; then falla "un import sin usar pasó el análisis"; else bien "un import sin usar lo frena"; fi
rm -f lib/zz_laboratorio_analisis.dart
fi

echo "4. Tu código pasa"
if [ -x tool/check.sh ] && CI=true ./tool/check.sh >/dev/null 2>&1; then bien "formato, análisis y pruebas en verde"; else falla "CI=true ./tool/check.sh falla: córrelo para ver por qué"; fi

echo
if [ "$mal" -eq 0 ]; then echo "Laboratorio completo: $ok de $ok. Sube tu rama y revisa la pestaña Actions."; exit 0; fi
echo "Faltan $mal cosas ($ok bien)."; exit 1
