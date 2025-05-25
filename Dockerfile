FROM python:3.9
WORKDIR /code
COPY ./requirements.txt /code/requirements.txt
RUN apt-get update && apt-get install -y curl
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt
COPY ./app /code/app
# CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "5000"]

#CMD [ "python3", "-m" ,"uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000",  "--backlog", "8", "--timeout-keep-alive", "300", "--no-server-header", "--header", "server:TTServer", "--reload"]
