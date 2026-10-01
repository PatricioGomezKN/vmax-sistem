# ---------- Backend Django ----------
FROM python:3.14.7-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# Dependencias del sistema mínimas (psycopg[binary] no requiere compilar)
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# Capa de dependencias (se cachea mientras requirements.txt no cambie)
COPY requirements.txt .
RUN pip install -r requirements.txt

# Código de la aplicación
COPY . .

# Usuario sin privilegios
RUN useradd --create-home appuser \
    && chmod +x /app/entrypoint.sh \
    && mkdir -p /app/staticfiles \
    && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3"]
