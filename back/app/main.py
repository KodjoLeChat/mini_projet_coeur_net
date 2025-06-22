from fastapi import FastAPI
from app.api import tensor, user
from fastapi.middleware.cors import CORSMiddleware
from app.api import admin


app = FastAPI()

origins = [
    "http://localhost:62062",  
    "http://localhost",      
    "http://127.0.0.1",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,  # liste des origines autorisées
    allow_credentials=True,
    allow_methods=["*"],    # autoriser toutes les méthodes HTTP (GET, POST, ...)
    allow_headers=["*"],    # autoriser tous les headers
)


app.include_router(tensor.router, tags=["tensor"])
app.include_router(user.router, tags=["user"])
app.include_router(admin.router, tags=["admin"])