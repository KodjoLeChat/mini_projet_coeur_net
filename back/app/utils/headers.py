from app.config import SUPABASE_SERVICE_ROLE_KEY

def headers(return_representation: bool = False) -> dict:
    headers = {
        "apikey": SUPABASE_SERVICE_ROLE_KEY,
        "Authorization": f"Bearer {SUPABASE_SERVICE_ROLE_KEY}",
        "Content-Type": "application/json"
    }
    if return_representation:
        headers["Prefer"] = "return=representation"
    return headers
