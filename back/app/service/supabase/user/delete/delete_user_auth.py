import requests
from app.config import SUPABASE_URL
from app.utils.headers import headers


def delete_user_auth(user_id):
    response = requests.delete(
        f"{SUPABASE_URL}/auth/v1/admin/users/{user_id}",
        headers=headers()
    )
    return response
