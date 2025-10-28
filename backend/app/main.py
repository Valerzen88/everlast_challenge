from fastapi import FastAPI, Depends, HTTPException
from .db import init_db, get_session
from .deps import get_tenant_id
from .schemas import LeadCreate, LeadRead
from .crud import create_lead, list_leads, convert_lead
from sqlmodel import Session, SQLModel, select, create_engine
from typing import List
from backend.app.models import Lead

app = FastAPI(title="CRM Recruiting Challenge - Backend")

sqlite_file_name = "database.db"
sqlite_url = f"sqlite:///{sqlite_file_name}"
engine = create_engine(sqlite_url, echo=True)

SQLModel.metadata.create_all(engine)

def get_session():
    with Session(engine) as session:
        yield session

@app.on_event("startup")
def on_startup():
    init_db()

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/api/v1/leads", response_model=LeadRead)
def api_create_lead(payload: LeadCreate, tenant_id: str = Depends(get_tenant_id), session: Session = Depends(get_session)):
    lead = create_lead(session, tenant_id, payload)
    return lead

@app.get("/api/v1/leads", response_model=List[LeadRead])
def get_leads(session: Session = Depends(get_session)):
    statement = select(Lead)
    leads = session.exec(statement).all()
    return leads

@app.post("/api/v1/leads/{lead_id}/convert", response_model=LeadRead)
def api_convert_lead(lead_id: int, tenant_id: str = Depends(get_tenant_id), session: Session = Depends(get_session)):
    lead = convert_lead(session, tenant_id, lead_id)
    if not lead:
        raise HTTPException(status_code=404, detail="Lead not found")
    return lead