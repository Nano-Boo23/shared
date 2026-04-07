FROM python:3.11

# Directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar dependencias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del código
COPY . .

# Exponer puerto de Flask
EXPOSE 5000

# Comando de arranque
CMD ["python", "app.py"]
