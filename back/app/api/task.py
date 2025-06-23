from fastapi import APIRouter, Depends
from app.security.roles import get_current_user_id, is_admin, is_user
from app.service.supabase.task.get.get_task_by_id import get_task_by_id
from app.service.supabase.task.get.get_task_list import get_all_tasks, get_own_task_list
from app.models.task import TaskCreate
from app.service.supabase.task.create.create_task import create_task
from app.service.supabase.task.delete.delete_task import delete_admin_task, delete_own_task
from app.service.supabase.task.update.update_task import update_admin_task, update_own_task

router = APIRouter()

@router.post("/tasks/create")
def create_task_route(payload: TaskCreate, user_id=Depends(get_current_user_id), _=Depends(is_user)):
    response = create_task(user_id,payload)
    return response

@router.get("/tasks")
def own_task_list_route(user_id=Depends(get_current_user_id),_=Depends(is_user)):
    response = get_own_task_list(user_id)
    return response

@router.get("/tasks/all")
def all_task_list_route(user_id=Depends(get_current_user_id),_=Depends(is_admin)):
    response = get_all_tasks(user_id)
    return response

@router.get("/tasks/{task_id}")
def task_by_id_route(task_id: str,_=Depends(is_user),user_id: str = Depends(get_current_user_id)):
    response = get_task_by_id(task_id, user_id)
    return response


@router.put("/tasks/{task_id}")
def update_own_task_route(
    task_id: str,
    payload: TaskCreate,
    user_id: str = Depends(get_current_user_id), 
    _=Depends(is_user)
    ):
    response = update_own_task(task_id, user_id, payload)
    return response

@router.put("/tasks/admin/{task_id}")
def update_admin_task_route(
    task_id: str,
    payload: TaskCreate,
    _=Depends(is_admin)
    ):
    response = update_admin_task(task_id, payload)
    return response

@router.delete("/tasks/{task_id}")
def delete_own_task_route(
    task_id: str,
    user_id: str = Depends(get_current_user_id), 
    _=Depends(is_user)
    ):
    response = delete_own_task(task_id, user_id,)
    return response

@router.delete("/tasks/admin/{task_id}")
def update_admin_task_route(
    task_id: str,
    _=Depends(is_admin)
    ):
    response = delete_admin_task(task_id)
    return response
