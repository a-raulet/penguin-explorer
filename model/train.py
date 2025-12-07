"""
Train and save the penguin mass prediction model.

Usage:
    python model/train.py

This script:
1. Loads penguin data from DuckDB
2. Trains a linear regression model
3. Saves the model using Vetiver and pins
"""

import duckdb
from pandas import get_dummies
from sklearn.linear_model import LinearRegression
from pins import board_folder
from vetiver import VetiverModel, vetiver_pin_write
import os

# Configuration
DB_PATH = os.getenv("DB_PATH", "my-db.duckdb")
MODEL_PATH = os.getenv("MODEL_PATH", "data/model")
MODEL_NAME = "penguin_model"


def load_data(db_path: str):
    """Load penguin data from DuckDB."""
    con = duckdb.connect(db_path)
    df = con.execute("SELECT * FROM penguins").fetchdf().dropna()
    con.close()
    print(f"Loaded {len(df)} rows from {db_path}")
    return df


def train_model(df):
    """Train linear regression model."""
    X = get_dummies(df[['bill_length_mm', 'species', 'sex']], drop_first=True)
    y = df['body_mass_g']

    model = LinearRegression().fit(X, y)

    print(f"R² score: {model.score(X, y):.4f}")
    print(f"Intercept: {model.intercept_:.2f}")
    print(f"Features: {list(X.columns)}")
    print(f"Coefficients: {model.coef_}")

    return model, X


def save_model(model, prototype_data, model_path: str, model_name: str):
    """Save model using Vetiver."""
    v = VetiverModel(model, model_name=model_name, prototype_data=prototype_data)
    board = board_folder(model_path, allow_pickle_read=True)
    vetiver_pin_write(board, v)
    print(f"Model saved to {model_path}/{model_name}")


def main():
    print("=" * 50)
    print("Penguin Model Training")
    print("=" * 50)

    df = load_data(DB_PATH)
    model, X = train_model(df)
    save_model(model, X, MODEL_PATH, MODEL_NAME)

    print("=" * 50)
    print("Training complete!")
    print("=" * 50)


if __name__ == "__main__":
    main()
