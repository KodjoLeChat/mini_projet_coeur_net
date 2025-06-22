import requests
from fastapi import HTTPException
from app.config import  SUPABASE_URL
from app.utils.headers import headers


def create_user_auth(email, role):
    response = requests.post(
        f"{SUPABASE_URL}/auth/v1/admin/users",
        headers=headers(),
        json={
            "email": email,
            "password": "123456",
            "email_confirm": True,
            "app_metadata": {"roles": [role]}
        }
    )
    if response.status_code not in [200, 201]:
        raise HTTPException(
            status_code=response.status_code,
            detail=f"Erreur à la création de l'utilisateur Auth : {response.text}"
        )
    user = response.json()
    user_id = user.get("id") or user.get("user", {}).get("id")
    if not user_id:
        raise HTTPException(
            status_code=response.status_code,
            detail=f"Impossible d'extraire l'id utilisateur : {user}"
        )
    return {"user": user, "user_id": user_id}