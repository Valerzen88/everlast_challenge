# everlast_challenge
# Recruiting Challenge — CRM Demo (FastAPI + Flutter)

**Ziel:** Kleines End-to-End-Feature für Sales-CRM: TODO.  
Stack: **Backend** Python/FastAPI + **Frontend** Flutter (mobile/desktop). Persistenz: SQLite (Demo). Mandantenbewusstsein (light) via `X-Tenant-Id` Header.

+++

## Inhalt des Repos
- `/backend` — FastAPI backend (SQLite by default)
- `/frontend` — Flutter demo app
- `docker-compose.yml` — startet nur das Backend (db = SQLite file)
- `.env.example` — Environment templat

+++

## How to build and start docker image
docker compose up --build
## Backend: http://localhost:8000
