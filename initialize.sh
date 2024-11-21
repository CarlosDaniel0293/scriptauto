#!/bin/bash

# Variables
REPO_URL="https://github.com/CarlosDaniel0293/proyectotesis2.git"
PROJECT_DIR="mi-proyecto"
CORS_FILE_BACKEND="backend/index.js" # Ajusta la ruta a tu archivo donde configures CORS
API_FILE_FRONTEND="frontend/src/api.js" # Ajusta la ruta a tu archivo donde configures la API URL
DOCKER_COMPOSE_FILE="docker-compose.yml" # Ruta al docker-compose.yml
PORT=3001 # Puerto de tu aplicación

# Obtener la IP pública de la instancia
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

# Mostrar la IP pública detectada
echo "IP Pública de la instancia: $PUBLIC_IP"

# 1. Actualizar el sistema e instalar dependencias necesarias
echo "Actualizando el sistema e instalando Docker..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io docker-compose git curl

# 2. Clonar el repositorio del proyecto
echo "Clonando el proyecto desde Git..."
if [ -d "$PROJECT_DIR" ]; then
    echo "El proyecto ya existe. Eliminando para una instalación limpia..."
    rm -rf "$PROJECT_DIR"
fi
git clone "$REPO_URL" "$PROJECT_DIR"

# 3. Modificar las URLs dinámicamente
echo "Actualizando las URLs del frontend y CORS en el backend..."
sed -i "s|http://localhost:3000/api/users|http://$PUBLIC_IP:3000/api/users|g" "$PROJECT_DIR/$API_FILE_FRONTEND"
sed -i "s|http://.*:3001|http://$PUBLIC_IP:$PORT|g" "$PROJECT_DIR/$CORS_FILE_BACKEND"

# 4. Navegar al directorio del proyecto y ejecutar Docker Compose
cd "$PROJECT_DIR"
echo "Iniciando servicios con Docker Compose..."
sudo docker-compose down
sudo docker-compose up -d

# 5. Mostrar mensaje de éxito
echo "El proyecto se ha inicializado correctamente. Accede a: http://$PUBLIC_IP:$PORT"
