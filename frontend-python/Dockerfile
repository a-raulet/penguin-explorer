FROM python:3.11-slim

WORKDIR /app

RUN pip install --no-cache-dir shiny requests

COPY app.py .

EXPOSE 8000

CMD ["shiny", "run", "app.py", "--host", "0.0.0.0", "--port", "8000"]
