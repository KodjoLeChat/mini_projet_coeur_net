from fastapi import HTTPException
from app.service.supabase.user.create.create_user_auth import create_user_auth
from app.service.supabase.user.create.create_profile import create_profile
from app.service.supabase.user.delete import delete_user_auth
from app.models.create_user_request import CreateUserRequest


def create_user(payload : CreateUserRequest,role= "user"):
    try:
        user_data = create_user_auth(payload.email,role)
    except HTTPException as e:
        raise e

    user_id = user_data["user_id"]

    try:
        profile = create_profile(user_id, payload.username, payload.bio)
    except HTTPException as e:
        delete_response = delete_user_auth(user_id)
        raise HTTPException(
            status_code=e.status_code,
            detail=f"{e.detail} | User rollback : {delete_response.status_code} {delete_response.text}"
        )
    return {"user": user_data["user"], "profile": profile}