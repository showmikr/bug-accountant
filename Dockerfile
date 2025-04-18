FROM python:3.12

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

# copy the rest of our application code
COPY . .

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:3000", "app:app"]
