from pydantic import BaseModel
from typing import Optional
from pydantic import TypeAdapter
from datetime import datetime

class LeadCreate(BaseModel):
    name: str
    email: Optional[str] = None

class LeadRead(BaseModel):
    id: int
    tenant_id: str
    external_id: str
    name: str
    email: str
    status: str
    created_at: datetime

    class Config:
        orm_mode = True

LeadAdapter = TypeAdapter(LeadRead)
LeadAdapter.rebuild()