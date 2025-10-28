#!/usr/bin/env bash
set -e
export DATABASE_URL="${DATABASE_URL:-sqlite:///./dev.db}"
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000