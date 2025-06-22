from fastapi import APIRouter, Depends
from app.models.create_user_request import CreateUserRequest
from app.security.roles import is_admin
from app.service.supabase.user.create.create_admin import create_admin

router = APIRouter()

@router.post("/admins/create")
def create_admin_route(payload: CreateUserRequest):
    return create_admin(payload)
