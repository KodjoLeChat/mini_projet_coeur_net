from pydantic import BaseModel

class CreateUserRequest(BaseModel):
    email: str
    username: str
    bio: str
