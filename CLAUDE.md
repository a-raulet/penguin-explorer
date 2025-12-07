# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Penguin Explorer is a data science project that predicts penguin body mass using the Palmer Penguins dataset. It combines R and Python, featuring a machine learning model served via API with Shiny frontends in both languages.

## Architecture

```
penguin-explorer/
├── api/                    # Vetiver API service
│   ├── Dockerfile
│   └── main.py
├── frontend-python/        # Shiny Python frontend
│   ├── Dockerfile
│   └── app.py
├── frontend-r/             # Shiny R frontend
│   ├── Dockerfile
│   └── app.R
├── model/                  # Training scripts
│   └── train.py
├── notebooks/              # Quarto notebooks (exploration)
│   └── model-vetiver.qmd
├── pages/                  # Quarto website pages
├── data/model/             # Saved Vetiver model (pins board)
├── docker-compose.yml      # Multi-container orchestration
└── _quarto.yml             # Quarto website configuration
```

**Data flow**: DuckDB → scikit-learn LinearRegression → Vetiver model → FastAPI endpoint → Shiny UI

## Common Commands

### Run Everything (Docker Compose)
```bash
docker compose up --build
```
- API: http://localhost:8080/docs
- Python frontend: http://localhost:8000
- R frontend: http://localhost:3838

### Train Model
```bash
source venv/bin/activate
python model/train.py
```

### Run Services Individually (Development)
```bash
# API
cd api && uvicorn main:app --reload --port 8080

# Python frontend
shiny run frontend-python/app.py

# R frontend
Rscript -e "shiny::runApp('frontend-r/app.R')"
```

### Environment Setup
```bash
# Python
source venv/bin/activate
pip install -r requirements.txt

# R
Rscript -e "renv::restore()"
```

### Render Quarto Website
```bash
quarto render
quarto preview
```

## Key Technologies

- **ML**: scikit-learn (LinearRegression), Vetiver for model deployment
- **Data**: DuckDB, palmerpenguins, pandas
- **API**: FastAPI/uvicorn (via Vetiver)
- **Frontend**: Shiny (Python & R versions)
- **Containerization**: Docker, Docker Compose
- **Website**: Quarto
- **CI/CD**: GitHub Actions publishes to gh-pages on push to main

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `API_URL` | `http://127.0.0.1:8080/predict` | API endpoint for frontends |
| `MODEL_PATH` | `data/model` | Path to Vetiver model board |
| `DB_PATH` | `my-db.duckdb` | Path to DuckDB database |
