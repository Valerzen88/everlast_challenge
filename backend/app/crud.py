from sqlmodel import select
from .models import Lead
from .schemas import LeadCreate
from sqlmodel import Session
from typing import List

def create_lead(session: Session, tenant_id: str, payload: LeadCreate) -> Lead:
    lead = Lead(tenant_id=tenant_id, name=payload.name, email=payload.email)
    session.add(lead)
    session.commit()
    session.refresh(lead)
    return lead

def list_leads(session: Session, tenant_id: str, limit: int = 100) -> List[Lead]:
    statement = select(Lead).where(Lead.tenant_id == tenant_id).order_by(Lead.created_at.desc()).limit(limit)
    return session.exec(statement).all()

def convert_lead(session: Session, tenant_id: str, lead_id: int) -> Lead:
    lead = session.get(Lead, lead_id)
    if not lead or lead.tenant_id != tenant_id:
        return None
    lead.status = "opportunity"
    session.add(lead)
    session.commit()
    session.refresh(lead)
    return lead
