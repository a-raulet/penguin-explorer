FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your API code
COPY app/app-api.py ./app-api.py

# Create mount point for model
RUN mkdir -p /data/model

# Expose port used by FastAPI
EXPOSE 8080

# Run the API
CMD ["uvicorn", "app-api:app", "--host", "0.0.0.0", "--port", "8080"]

