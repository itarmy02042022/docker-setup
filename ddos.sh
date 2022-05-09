#!/bin/bash
#color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

#commands list
commands[0]='echo -e "${YELLOW}UPDATING PACKAGES${NC}" && sudo apt update'
commands[1]='echo -e "${YELLOW}INSTALLING DOCKER${NC}" && sudo apt install -y docker.io'
commands[2]='echo -e "${YELLOW}ENABLING DOCKER${NC}" && sudo systemctl enable docker --now'
commands[3]='echo -e "${YELLOW}ADDING DOCKER TO USER GROUP${NC}" && sudo usermod -aG docker $USER'
commands[4]='echo -e "${YELLOW}ADDING REPO AND GPG KEY${NC}" && printf \'%s\n\'' "deb https://download.docker.com/linux/debian bullseye stable" | sudo tee /etc/apt/sources.list.d/docker-ce.list ; curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-ce-archive-keyring.gpg'
commands[5]='echo -e "${YELLOW}UPDATING PACKAGES${NC}" && sudo apt update'
commands[6]='echo -e "${YELLOW}INSTALLING DOCKER-CE${NC}" && sudo apt install -y docker-ce docker-ce-cli containerd.io'
commands[7]='echo -e "${YELLOW}UNMASKING DOCKER SERVICE${NC}" && sudo systemctl unmask docker.service'
commands[8]='echo -e "${YELLOW}UNMASKING DOCKER SOCKET${NC}" && sudo systemctl unmask docker.socket'
commands[9]='echo -e "${YELLOW}STARTING DOCKER${NC}" && sudo systemctl start docker.service'
commands[10]='echo -e "${YELLOW}CHANGING RIGHTS FOR DOCKER SOCKET${NC}" && sudo chmod 666 /var/run/docker.sock'
commands[11]='echo -e "${YELLOW}CHECKING DOCKER${NC}" && sudo docker run hello-world'

for index in ${!commands[*]}
do
  eval " ${commands[index]} &"
  wait $! && echo -e "${GREEN}OK${NC}" || (echo -e "${RED}FAILED${NC} WITH CODE ${index}" && exit index)
done

echo -e "${GREEN}INITIALISATION COMPLETED${NC}"
