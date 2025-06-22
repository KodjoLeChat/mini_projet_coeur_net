import requests
from app.config import SUPABASE_DB_URL
from app.utils.headers import headers


def delete_profile(user_id):
    response = requests.delete(
        f"{SUPABASE_DB_URL}/profiles?id=eq.{user_id}",
        headers=headers()
    )
    return response