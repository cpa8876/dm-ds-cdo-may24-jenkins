#~/python-microservices/movie-service/app/api/models.py
from pydantic import BaseModel
from typing import List, Optional

class MovieIn(BaseModel):
    id: int
    name: str
    plot: str
    genres: List[str]
    casts_id: List[int]

class MovieOut(MovieIn):
    id: int

class MovieUpdate(MovieIn):
    id: Optional[int] = None
    name: Optional[str] = None
    plot: Optional[str] = None
    genres: Optional[List[str]] = None
    casts_id: Optional[List[int]] = None
