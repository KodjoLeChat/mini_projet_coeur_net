from fastapi import APIRouter, Depends
from app.service.tensor_service import generate_tensor
from app.security.roles import is_user

router = APIRouter()

@router.get("/tensor")
async def get_tensor(_=Depends(is_user)):
    tensor = generate_tensor()
    return tensor
