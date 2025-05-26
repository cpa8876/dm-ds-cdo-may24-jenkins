# /home/cpa/Documents/CPA/44_JENKINS/DM.JENKINS/python-microservices/cast_service/Dockerfile
# FROM python:3.8-slim
FROM FROM tiangolo/uvicorn-gunicorn-fastapi:python3.10-slim as base

WORKDIR /app

COPY ./requirements.txt /app/requirements.txt

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -r /app/requirements.txt \

COPY . /app/

# Create and activate virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Set environment variables
ENV APP_MODULE=main:app
ENV PORT=5000

# Use a non-root user
USER 1000

#CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]# Start the application
CMD ["uvicorn", "--host", "0.0.0.0", "--port", "5000", "app.main:app"]
