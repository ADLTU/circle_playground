FROM python:3.11.5

WORKDIR /circle_playground

COPY pyproject.toml poetry.lock ./

RUN pip install poetry
RUN poetry config virtualenvs.create false


RUN poetry install

COPY decoder/main.py ./

EXPOSE 80

CMD exec gunicorn --bind :80 --workers 3 --timeout 2 --worker-class uvicorn.workers.UvicornWorker --preload main:app
