from typing import Optional
from sqlmodel import SQLModel, Field
from datetime import datetime
import uuid

class Lead(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    external_id: str = Field(default_factory=lambda: str(uuid.uuid4()), index=True)
    tenant_id: str = Field(index=True)
    name: str
    email: Optional[str] = None
    status: str = Field(default="new")
    created_at: datetime = Field(default_factory=datetime.utcnow)
