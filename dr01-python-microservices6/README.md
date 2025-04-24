{
  "name": "Star Wars: Episode VI - Return of the Jedi",
  "plot": "The evil Galactic Empire is building a new Death Star space station to permanently destroy the Rebel Alliance, its main opposition.",
  "genres": [
      "Action",
      "Adventure",
      "Fantasy"
  ],
  "casts_id": [3]
}

>>> print(f"{url}{casts_id}/")
http://localhost:8002/api/v1/casts/3/
>>> print(f"{url}{casts_id}/")
http://localhost:8002/api/v1/casts/3/
>>> httpx.get(f"{url}{casts_id}/")
<Response [200 OK]>


import os
import httpx
CAST_SERVICE_HOST_URL = 'http://localhost:8000/api/v1/casts/'
url = CAST_SERVICE_HOST_URL
cast_id=3
print(f"{url}{cast_id}/")
http://localhost:8000/api/v1/casts/3/
r = httpx.get(f"{url}{cast_id}/")
return True if r.status_code == 200 else False


curl -X 'POST' \
  'http://192.168.20.1:8001/api/v1/movies/' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "name": "Star Wars: Episode VI",
  "plot": "The evil Galactic Empire is building a new Death Star space station",
  "genres": [
    "Action"
  ],
  "casts_id": [
    3
  ]
}'
