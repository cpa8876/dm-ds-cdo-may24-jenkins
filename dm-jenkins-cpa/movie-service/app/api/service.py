#~/python-microservices/movie-service/app/api/service.py
import os
import httpx

CAST_SERVICE_HOST_URL = 'http://localhost:8002/api/v1/casts/'

def is_cast_present(cast_id: int):
# https://www.python-httpx.org/quickstart/
# https://python-forum.io/thread-3795.html
    #url = os.environ.get('CAST_SERVICE_HOST_URL') or CAST_SERVICE_HOST_URL
    url = CAST_SERVICE_HOST_URL
    #url = os.environ.get('CAST_SERVICE_HOST_URL')
    r = httpx.get(f"{url}{cast_id}/")
    # return True if r.status_code == 200 else (False)
    if r.status_code == 200:
      return True
    else:
      return False

