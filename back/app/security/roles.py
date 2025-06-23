from fastapi import HTTPException, Header, Path
from app.config import SUPABASE_JWT_SECRET_KEY
import jwt

from app.service.supabase.user.get.get_user_by_id import get_user_by_id

def _decode_jwt(authorization: str) -> dict:
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
        return decoded
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expired")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token")




def _get_roles(authorization: str) -> list:
    decoded = _decode_jwt(authorization)
    return decoded.get("app_metadata", {}).get("roles", [])

def get_current_user_id(authorization: str = Header(...)) -> str:
    decoded = _decode_jwt(authorization)
    user_id = decoded.get("sub")
    if not user_id:
        raise HTTPException(status_code=401, detail="User ID not found in token")
    return user_id

def get_current_user(authorization: str = Header(...)):
    user_id = get_current_user_id(authorization)
    return get_user_by_id(user_id)


def is_admin(authorization: str = Header(...)) -> bool:
    roles = _get_roles(authorization)
    if "admin" not in roles:
        raise HTTPException(status_code=403, detail="Admin access only")
    return True

def _can_get_or_edt(user_id:str, authorization:str,detail="You are not authorized") -> bool:
    current_user_id = get_current_user_id(authorization)
    roles = _get_roles(authorization)
    if "admin" in roles:
        return True
    if(user_id != current_user_id):
        raise HTTPException(status_code=403, detail=detail)
    return True


def can_edit(user_id: str = Path(...), authorization: str = Header(...)) -> bool:
    response = _can_get_or_edt(user_id,authorization,detail="Can not edit other user data")
    return response

def can_get(user_id: str = Path(...), authorization: str = Header(...)) -> bool:
    response = _can_get_or_edt(user_id,authorization,detail="Can not get other user data")
    return response

def is_user(authorization: str = Header(...)) -> bool:
    roles = _get_roles(authorization)
    print(f"roles : {roles}")
    if "user" not in roles and "admin" not in roles:
        raise HTTPException(status_code=403, detail="Access restricted to authenticated users")
    return True
    
