# everlast_challenge
# Recruiting Challenge — CRM Demo (FastAPI + Flutter)

**Ziel:** Kleines End-to-End-Feature für Sales-CRM: TODO.  
Stack: **Backend** Python/FastAPI + **Frontend** Flutter (mobile/desktop). Persistenz: SQLite (Demo). Mandantenbewusstsein (light) via `X-Tenant-Id` Header.

+++

## Inhalt des Repos
- `/backend` — FastAPI backend (SQLite by default)
- `/frontend` — Flutter demo app
- `docker-compose.yml` — startet nur das Backend (db = SQLite file)
- `.env.example` — Environment template

+++

## How to build and start docker image
docker compose up --build

## Backend: http://localhost:8000

+++

## Special things to know
For local backend run:
- brew has a problem with MacOS 26
- don't forget to create env
	- python3 -m venv venv
	- source venv/bin/activate
	- pip install "fastapi" "uvicorn" "sqlmodel" "python-jose[cryptography]" or run pip install -r requirements.txt
	- install in venv, not in local env!
- ./start.sh
- python -m uvicorn backend.app.main:app --reload in everlast_challenge dir

For local frontend run:
- flutter config --enable-web
- flutter create .
- flutter run -d chrome
- flutter devices (to see which devices are possible)

## Use Case - Ein Mini-CRM für unterwegs, bei dem jeder Vertriebler nur seine eigenen Leads sieht
* Zielnutzer (Persona)
Name: Anna Schmidt
Rolle: Account Managerin / Sales Representative
Kontext: Sie arbeitet in einem mittelständischen B2B-Unternehmen und nutzt das CRM täglich, um Leads zu pflegen, Kunden nachzufassen und Deals zu verwalten.
Problem: Anna hat ständig viele Kontakte, Excel-Listen, Mails – aber kein System, das automatisch, schnell und einfach relevante Kundeninteraktionen speichert und abrufbar macht.

* Problem aus Vertriebssicht
Zeitverlust bei manueller Dateneingabe	-> Anna schreibt Kundennotizen in Mails oder Excel statt direkt im CRM – dadurch gehen Daten verloren oder sind veraltet.
Unklare Trennung zwischen Teams / Mandanten -> Sie betreut nur „ihre“ Kunden – aber im CRM mischen sich Leads von anderen Teams oder Projekten.
Fehlender Überblick über den eigenen Sales Funnel -> Ohne klare Struktur und Filter (z. B. nach Mandant oder Account) sieht sie nicht, welche Leads aktiv sind.
Kein mobiler Zugriff / keine einfache UI -> Das CRM ist oft zu schwerfällig für schnelles Arbeiten am Handy oder Laptop unterwegs.

## Next steps
1. Auth + Multi-tenant enforcement (JWT + middleware verifying tenant_id against
token).
2. Minimal API + UI flow: Lead list, Create Lead form, Convert to Opportunity. (Flutter +
FastAPI endpoints).
3. Persistence: Postgres schema + basic migration (alembic) or SQLite for demo. DB
model includes tenant_id and indices.
4. Observability quick wins: structured logs + basic Prometheus metrics endpoint
(/metrics).
5. Docker Compose to run API + DB + frontend locally.
6. README: architecture sketch, setup/run, trade-offs, next steps.

* Lösung
Ein leichtgewichtiges, mandantenfähiges Lead-Management-Modul mit JWT-basierter Authentifizierung, das Vertrieblern ermöglicht, ihre eigenen Leads schnell anzulegen, zu sehen und zu verwalten, ohne dass andere Teams dieselben Daten sehen.
