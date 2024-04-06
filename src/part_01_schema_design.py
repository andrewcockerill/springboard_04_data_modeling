import os
from dotenv import load_dotenv, dotenv_values

load_dotenv()
DB_USER = os.getenv("DB_USER")
DEFAULT_DB = os.getenv("DEFAULT_DB")
DB_PASSWORD = os.getenv("DB_PASSWORD")
HOST = os.getenv("HOST")
PORT = os.getenv("PORT")
SCHEMA_FILES = ["medical_center.sql", "craigslist.sql", "soccer.sql"]

PSQL_STRINGS = [
    f"psql -Atx postgresql://{DB_USER}:{DB_PASSWORD}@{HOST}:{PORT}/{DEFAULT_DB} -w < {i}" for i in SCHEMA_FILES]

for command in PSQL_STRINGS:
    os.system(command)
