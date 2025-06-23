from fastapi import APIRouter, Depends
from app.models.create_user_request import CreateUserRequest
from app.security.roles import can_edit, can_get, get_current_user, is_admin, is_user
from app.service.supabase.user.create.create_user import create_user
from app.service.supabase.user.get.get_user_list import get_user_list
from app.service.supabase.user.get.get_user_by_id import get_user_by_id
from app.service.supabase.user.delete.delete_user import delete_user
from app.service.supabase.user.update.update_user import update_user

router = APIRouter()

@router.post("/users/create")
def create_user_route(payload: CreateUserRequest,_=Depends(is_admin)):
    response = create_user(payload)
    return response

@router.get("/users",)
def user_list_route(current_user=Depends(get_current_user),_=Depends(is_admin)):
    return get_user_list(exclude_id=current_user["id"])

@router.get("/users/{user_id}")
def user_by_id_route(user_id: str,_=Depends(can_get)):
    return get_user_by_id(user_id)

@router.delete("/users/{user_id}")
def delete_user_route(user_id: str, _=Depends(can_edit)):
    return delete_user(user_id)

@router.put("/users/{user_id}")
def update_user_route(user_id: str,payload: CreateUserRequest,_=Depends(can_edit)):
    response = update_user(user_id, payload)
    return response
