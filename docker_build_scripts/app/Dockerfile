FROM python:3.11
WORKDIR /app

#app dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

#copy other files (like templates/)
COPY . .

#expose flask port
EXPOSE 5000

#python app startup
CMD ["python", "app.py"]
