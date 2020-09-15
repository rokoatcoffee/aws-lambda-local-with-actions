FROM python:3.8

WORKDIR /app
COPY /src /app
COPY requirements.txt /app

RUN apt-get update && apt-get install zip -y
RUN pip install -r requirements.txt --target=/app
RUN zip -r9 /app/app.zip .
