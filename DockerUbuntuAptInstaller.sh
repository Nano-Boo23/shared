#!/bin/bash
GRN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GRN}[script gs] Empezando script${NC}"

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Este script debe de ser ejecutado con sudo!${NC}"
   exit 1
elif ! grep -q "Ubuntu" /etc/os-release; then
   echo "$ID"
   echo -e "${RED}Este sistema no es Ubuntu! El script está preparado solo para Ubuntu.${NC}"
   exit 1
fi

echo -e "${GRN}[script gs] Quitando version Docker antigua si existe...${NC}"
apt remove -y $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)
echo -e "${GRN}Hecho${NC}"

echo -e "${GRN}[script gs] Instalando paquetes necesarios...${NC}"
apt install -y ca-certificates curl
echo -e "${GRN}Hecho${NC}"

echo
echo -e "${GRN}[script gs] Obteniendo GPG de Docker...${NC}"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo -e "${GRN}Hecho${NC}"

echo
echo -e "${GRN}[script gs] Añadiendo Docker a recursos apt...${NC}"
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
echo -e "${GRN}Hecho${NC}"

echo
echo -e "${GRN}[script gs] Actualizando apt${NC}"
apt update -y


echo
echo -e "${GRN}[script gs] Instalando paquetes Docker...${NC}"
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo -e "${GRN}Hecho${NC}"

echo
echo -e "${GRN}[script gs] Descargando fichero yml para proyecto 3...${NC}"
curl -o docker-compose.yml https://raw.githubusercontent.com/Nano-Boo23/shared/main/projecte3_compose.yml
chmod +x docker-compose.yml
echo -e "${GRN}Hecho${NC}"


echo -e "${GRN}"
echo "[script gs] Script finalizado! Comprueba el estado de Docker con:"
echo "    sudo systemctl status docker"
echo "    sudo docker run hello-world"
echo "[script gs] Y ejecuta la linea siguiente para iniciar todos los contenedores:"
echo "    sudo docker compose up"
echo "[script gs] Si quieres utilizar docker build y necesitas los ficheros correspondientes, descargalos aqui: https://github.com/Nano-Boo23/shared/tree/main/docker_build_scripts"
echo -e "${NC}"

exit 0
