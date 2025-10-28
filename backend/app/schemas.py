from pydantic import BaseModel
from typing import Optional

class LeadCreate(BaseModel):
    name: str
    email: Optional[str] = None

class LeadRead(BaseModel):
    id: int
    external_id: str
    tenant_id: str
    name: str
    email: Optional[str]
    status: str
    created_at: str