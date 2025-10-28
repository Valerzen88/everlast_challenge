from fastapi import Header, HTTPException
from typing import Optional
from .db import get_session

def get_tenant_id(x_tenant_id: Optional[str] = Header(None)):
    # Simple tenant extraction. In prod: validate JWT and extract tenant.
    if not x_tenant_id:
        raise HTTPException(status_code=400, detail="Missing X-Tenant-Id header")
    return x_tenant_id