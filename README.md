## Database setup
psql -U postgres -c "CREATE DATABASE caregiver_db;"
psql -U postgres -d caregiver_db -f caregiver_db.sql

## Run Backend
pipenv install
pipenv shell
uvicorn main:app --reload
