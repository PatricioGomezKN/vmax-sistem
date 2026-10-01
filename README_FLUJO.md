# Flujo de empaquetado

**PC origen** (una vez definidos los archivos):
1. `cp .env.example .env` y completar.
2. `docker compose build backend`
3. `docker login && docker compose push backend`

**PC destino** (clona el repo y descarga la imagen):
1. `git clone <repo> && cd <repo>`
2. `cp .env.example .env` y completar (mismo DOCKERHUB_USER / APP_TAG).
3. `docker compose pull backend db`
4. `docker compose up -d`

**Actualización de entorno (paso aparte, fuera del flujo):**
- Node: `nvm install && nvm use` (lee `.nvmrc`). Para Docker no hace falta: el compose usa `node:24.21.0-alpine`.
- Python/Django/DRF/CORS: las versiones viven en `backend/requirements.txt` y en `backend/Dockerfile`; se actualizan reconstruyendo la imagen, no en el host.
- Docker/Compose: actualizar desde el gestor del sistema.
