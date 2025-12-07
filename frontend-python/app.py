from shiny import App, render, ui, reactive
import requests
import logging
import os

api_url = os.getenv("API_URL", "http://127.0.0.1:8080/predict")

logging.basicConfig(
    format='%(asctime)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

app_ui = ui.page_fluid(
    ui.panel_title("Penguin Mass Predictor"),
    ui.layout_sidebar(
        ui.sidebar(
            ui.input_slider("bill_length", "Bill Length (mm)", 30, 60, 45, step=0.1),
            ui.input_select("sex", "Sex", ["Male", "Female"]),
            ui.input_select("species", "Species", ["Adelie", "Chinstrap", "Gentoo"]),
            ui.input_action_button("predict", "Predict")
        ),
        ui.card(
            ui.h2("Penguin Parameters"),
            ui.output_text_verbatim("vals_out"),
            ui.h2("Predicted Penguin Mass (g)"),
            ui.output_text("pred_out")
        )
    )
)


def server(input, output, session):
    logger.info("App started")

    @reactive.Calc
    def vals():
        return {
            "bill_length_mm": input.bill_length(),
            "sex_male": input.sex() == "Male",
            "species_Gentoo": input.species() == "Gentoo",
            "species_Chinstrap": input.species() == "Chinstrap"
        }

    @reactive.Calc
    @reactive.event(input.predict)
    def pred():
        logger.info("Prediction requested")
        try:
            r = requests.post(api_url, json=[vals()])
            r.raise_for_status()
            logger.info("Prediction returned successfully")
            return r.json().get('predict')[0]
        except requests.exceptions.RequestException as e:
            logger.error(f"API error: {e}")
            return None

    @output
    @render.text
    def vals_out():
        return f"{vals()}"

    @output
    @render.text
    def pred_out():
        result = pred()
        if result is None:
            return "Erreur: API indisponible"
        return f"{round(result)}"


app = App(app_ui, server)
