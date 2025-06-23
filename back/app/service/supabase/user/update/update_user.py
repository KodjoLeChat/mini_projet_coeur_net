from app.models.create_user_request import CreateUserRequest
from app.service.supabase.user.update.update_user_auth import update_user_auth
from app.service.supabase.user.update.update_profile import update_profile


def update_user(user_id: str, payload: CreateUserRequest):
    update_user_auth(user_id,payload.email,payload.role)
    profile = update_profile(user_id, payload)
    return profile
