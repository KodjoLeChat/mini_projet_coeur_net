import os
from fastapi import FastAPI
from app.api import tensor, user
from fastapi.middleware.cors import CORSMiddleware
from app.api import admin
from app.api import task


app = FastAPI()

origins = os.getenv("CORS_ORIGINS", "").split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins, 
    allow_credentials=True,
    allow_methods=["*"],    
    allow_headers=["*"],   
)


app.include_router(tensor.router, tags=["tensor"])
app.include_router(user.router, tags=["user"])
app.include_router(admin.router, tags=["admin"])
app.include_router(task.router, tags=["task"])