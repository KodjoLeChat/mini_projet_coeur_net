from fastapi import APIRouter, Depends
from app.models.create_user_request import CreateUserRequest
from app.security.roles import is_admin, is_user
from app.service.supabase.user.create.create_user import create_user
from app.service.supabase.user.get.get_user_list import get_user_list
from app.service.supabase.user.get.get_user_by_id import get_user_by_id

router = APIRouter()

@router.post("/users/create")
def create_user_route(payload: CreateUserRequest,_=Depends(is_admin)):
    response = create_user(payload)
    return response

@router.get("/users",)
def user_list_route(_=Depends(is_admin)):
    return get_user_list()

@router.get("/users/{user_id}")
def user_detail_route(user_id: str,_=Depends(is_user)):
    return get_user_by_id(user_id)

