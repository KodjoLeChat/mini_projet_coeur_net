from fastapi import HTTPException
from app.service.supabase.user.delete import delete_profile, delete_user_auth


def delete_user(user_id: str):
    try:
        delete_profile(user_id)
    except HTTPException as e:
        raise e

    try:
        delete_user_auth(user_id)
    except HTTPException as e:
        raise e

    return {"message": "User and profile deleted"}