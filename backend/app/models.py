from typing import Optional
from sqlmodel import SQLModel, Field
from datetime import datetime
from pydantic import field_validator
import uuid

class Lead(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    external_id: str = Field(default_factory=lambda: str(uuid.uuid4()), index=True)
    tenant_id: str = Field(index=True)
    name: str
    email: Optional[str] = None
    status: str = Field(default="new")
    created_at: str = Field(default_factory=lambda: datetime.utcnow().isoformat())

    class Config:
        from_attributes = True
        
class LeadRead(SQLModel):
    id: int
    name: str
    email: Optional[str] = None
    created_at: str  # oder datetime, siehe unten

    model_config = {
        "from_attributes": True
    }
    
    @field_validator("created_at", mode="before")
    def convert_datetime(cls, v):
        if isinstance(v, datetime):
            return v.isoformat()
        return v