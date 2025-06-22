from app.models.create_user_request import CreateUserRequest
from .create_user import create_user


def create_admin(payload : CreateUserRequest):
    return create_user(payload,"admin")