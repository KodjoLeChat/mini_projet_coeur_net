from fastapi import HTTPException, Header
from app.config import SUPABASE_JWT_SECRET_KEY
import jwt

def _get_roles(authorization: str) -> list:
    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Missing or malformed token")
    token = authorization.split(" ")[1]
    try:
        decoded = jwt.decode(
            token, 
            SUPABASE_JWT_SECRET_KEY, 
            algorithms=["HS256"],
            audience="authenticated"
        )
        roles = decoded.get("app_metadata", {}).get("roles", [])
        return roles
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expired")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token")



def is_admin(authorization: str = Header(...)) -> bool:
    roles = _get_roles(authorization)
    if "admin" not in roles:
        raise HTTPException(status_code=403, detail="Admin access only")
    return True

def is_user(authorization: str = Header(...)) -> bool:
    roles = _get_roles(authorization)
    print(f"roles : {roles}")
    if "user" not in roles and "admin" not in roles:
        raise HTTPException(status_code=403, detail="Access restricted to authenticated users")
    return True
    
