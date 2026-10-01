#!/bin/sh
set -e

# Espera a que PostgreSQL acepte conexiones (sin depender de herramientas extra)
python - <<'PY'
import os, socket, sys, time
host = os.environ.get("POSTGRES_HOST", "db")
port = int(os.environ.get("POSTGRES_PORT", "5432"))
for i in range(30):
    try:
        socket.create_connection((host, port), timeout=2).close()
        print(f"[entrypoint] PostgreSQL disponible en {host}:{port}")
        sys.exit(0)
    except OSError:
        print(f"[entrypoint] Esperando base de datos... ({i+1}/30)")
        time.sleep(2)
print("[entrypoint] No se pudo conectar a la base de datos")
sys.exit(1)
PY

if [ "${RUN_MIGRATIONS:-1}" = "1" ]; then
    echo "[entrypoint] Aplicando migraciones"
    python manage.py migrate --noinput
fi

if [ "${RUN_COLLECTSTATIC:-1}" = "1" ]; then
    echo "[entrypoint] Recolectando estáticos"
    python manage.py collectstatic --noinput
fi

exec "$@"
