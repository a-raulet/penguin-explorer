from pins import board_folder
from vetiver import VetiverModel, VetiverAPI
import os

model_path = os.getenv("MODEL_PATH", "/data/model")

b = board_folder(model_path, allow_pickle_read=True)
v = VetiverModel.from_pin(b, "penguin_model")

api = VetiverAPI(v, check_prototype=True)
app = api.app
