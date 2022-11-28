#!/bin/bash

PURPLE='0;35'
NC='\033[0m' 
VERSAO=11
# ===================================================================
# variaveis.
# ===================================================================
jarDisplay='https://github.com/Monitoramento-Funcionario/api-health/raw/main/api-health-display/app.jar'
script_bd='https://cdn.discordapp.com/attachments/1004014309485060149/1046538112785981450/BD.sql'
app='app.jar'


corBot='\e[38;5;207m'
bold=$(tput bold) 
cortxt='\033[0m'
dftxt=$(tput sgr0)
# ===================================================================
# Instalando projeto.
# ===================================================================
instalando_healthMachine() {
  echo -e  "Iniciando a aplicação Health Machine"
  sudo docker exec -it healthMachine java -jar app.jar 
}
iniciando(){
  sudo apt-get update && apt-get upgrade 1> /dev/null 2> /dev/stdout
  sudo java -jar $app 1> /dev/null 2> /dev/stdout
}
criar_container() {
  if [ "$(sudo docker ps -aqf 'name=healthMachine' | wc -l)" -eq "0" ]
  then
  echo -e  ""
  echo -e "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt}  Criando o container..."
  sudo docker run -it -d -p 8080:8080 --name healthMachine healthmachine/java
  echo -e  "Executando o app"
  fi
  instalando_healthMachine
}
gerar_imagem_personalizada() {

    sudo docker build . --tag healthmachine/java
    sudo docker images

    criar_container
}
cloner_repositorio() {
	if [ "$( ls -l | grep 'BD.sql' | wc -l )" -eq "1" ]; then
	rm BD.sql
	fi
  echo -e  ""
  echo -e  "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt} Selecione a versão que deseja baixar"
  echo -e  "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt} (1) - CLI"
  echo -e  "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt} (2) - Display"
  
  read versaojar
if [ \"$versaojar\" == \"1\" ]
    then
   if [ "$(ls | grep 'api-health' | wc -l)" -eq "0" ]
    then
    echo -e  "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt}  Ok! Você escolheu instalar a versão CLI ;D"
    echo -e "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt}  Clonando a aplicação..."
    git clone "https://github.com/Monitoramento-Funcionario/api-health"
   fi
    cd api-health
    pwd
    cd api-health-cli
    pwd
    gerar_imagem_personalizada

  else
    if [ "$(ls | grep 'app.jar' | wc -l)" -eq "0" ]
    then
      echo -e  "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt}  Ok! Você escolheu instalar a versão Display ;D"
	    echo -e  "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt}  Adicionando o repositório!"
      wget $jarDisplay 1> /dev/null 2> /dev/stdout
      iniciando
    else
      iniciando
    fi
fi
}
criar_container_mysql() {
	if [ "$(sudo docker ps -aqf 'name=healthBD' | wc -l)" -eq "0" ]; then
		echo -e  ""
		echo -e "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt} Finalizando instalação do docker..."
		sudo docker run -d -p 3306:3306 --name healthBD -e "MYSQL_ROOT_PASSWORD=urubu100" imagem_wsl:1.0  1> /dev/null 2> /dev/stdout
	fi
	cloner_repositorio	
}
gerar_imagem_personalizada_msql() {
	if [ "$( ls -l | grep 'BD.sql' | wc -l )" -eq "0" ]
  then
		wget $script_bd 1> /dev/null 2> /dev/stdout
	fi
	if [ "$( ls -l | grep 'dockerfile' | wc -l )" -eq "0" ]
  then
  echo -e  "
  FROM mysql:5.7

  ENV MYSQL_DATABASE miraclesolutions

  COPY BD.sql /docker-entrypoint-initdb.d/
" > dockerfile
	fi
	if [ "$(sudo docker images | grep 'imagem_wsl' | wc -l)" -eq "0" ]; then
		sudo docker build -t imagem_wsl:1.0 . 1> /dev/null 2> /dev/stdout

	fi
	criar_container_mysql
}
gerar_imagem_mysql() { 

	if [ "$(sudo docker images | grep 'mysql' | wc -l)" -eq "0" ]; then
	echo -e  ""
	echo -e "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt} Criando imagem docker..."
		sudo docker pull mysql:5.7 1> /dev/null 2> /dev/stdout
	
	  gerar_imagem_personalizada_msql
	else
		gerar_imagem_personalizada_msql

	fi
}
ligar_docker() {
if [ "$(sudo service docker status | head -2 | tail -1 | awk '{print $4}' | sed 's/\;//g')" != "enabled" ]
    then
    sudo systemctl enable docker
fi
if [ "$(sudo systemctl is-active docker)" != "active" ]
    then
    sudo systemctl start docker
fi
  gerar_imagem_mysql
}
Instalar_docker() {
  if [ "$(dpkg --get-selections | grep 'docker.io' | wc -l)" -eq "0" ]
  then
    echo -e  ""
    echo -e "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt}Atualizando as dependências..."
    sudo apt update -y 1> /dev/null 2> /dev/stdout

    echo -e "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt} ---------- Instalando o docker ----------"
  
    sudo apt install docker.io -y 1> /dev/null 2> /dev/stdout
    ligar_docker
  
  else
    ligar_docker
  
  fi
}
verificar_java() {

  echo -e  "${corBot}${bold}[...]:${cortxt}${deftxt}  Olá, meu nome é Health e serei seu assistente para instalação da nossa API!"
  echo -e  "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt}  Estou realizando uma verificação de requisitos obrigatórios para o funcionamento correto do sistema, um momento..."
  
  sleep 3
  
  if [ "$(dpkg --get-selections | grep 'default-jre' | wc -l)" -eq "0" ]
  then
  
  echo -e  "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt}  Opa! Não identifiquei nenhuma versão do Java instalado, mas sem problemas, irei resolver isso agora!"
  
  sudo apt install default-jre;sudo apt install openjdk-11-jre-headless; -y
  
  echo -e  "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt}  Instalado-com-sucesso!"
  echo -e  "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt}  Tudo certo aqui, vamos para o próximo passo..."
  Instalar_docker
else
  echo -e  "${corBot}${bold}[Health-assistant]:${cortxt}${deftxt}  Tudo certo aqui, vamos para o próximo passo.."
  Instalar_docker
  fi
}
logoHealth(){
echo -e "${corBot}${bold}         
                                             *@@@@@@@@@@@@@@@@@@@@@@@@=                                   
                                  -@@@@@@@@@@@@@@@@@@@        @@@@@@@@@@@@@@@@@@@                         
                               @@@@@@@@@@@@@@@@@@@                @@@@@@@@@@@@@@@@@@@                     
                                 @@@@@@@@@@@@@@@@@                @@@@@@@@@@@@@@@@@                       
                                  @@@@@@@@@@@@@@@@                @@@@@@@@@@@@@@@@                        
                                    @@@@@@@@@@@@@@@@@@        @@@@@@@@@@@@@@@@@@                          
                                     @@@@@@@@@@@@@@@@@        @@@@@@@@@@@@@@@@@                           
                                                                                                       
                              @@@                                                  @@                     
                            +@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                    
                           @@@@@@@@@@@@@@@@@@@@@@@     =@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%                  
                          @@@@@@@@@@@@@@@@@@@@@@           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                 
                         @@@@@@@@@@@@@@@@@@@@@                 @@@@@@@@@@@@@@@@@@@@@@@@@@@                
                        #@@@@@@@@@@@@@@@@@@                          @@@@@@@@@@@@@@@@@@@@@@               
                        @@@@@@@@@@@@@@@@@                                @@@@@@@@@@@@@@@@@@               
                       @@@@@@@@@@@@@@@@@@                                 @@@@@@@@@@@@@@@@@@              
                       @@@@@@@@@@@@@@@@@@    @@@@@@@@          @@@@@@@@   @@@@@@@@@@@@@@@@@@              
                       @@@@@@@@@@@@@@@@@@                                 @@@@@@@@@@@@@@@@@@@             
                       @@@@@@@@@@@@@@@@@@                                 @@@@@@@@@@@@@@@@@@@             
                       @@@@@@@@@@@@@@@@@@                                 @@@@@@@@@@@@@@@@@@@             
                       @@@@@@@@@@@@@@@@@@@@                              @@@@@@@@@@@@@@@@@@@@             
                       @@@@@@@@@@@@@@@@@@@@@@                          @@@@@@@@@@@@@@@@@@@@@@             
                       #@@@@@@@@@@@@@@@@@@@@@@@                      @@@@@@@@@@@@@@@@@@@@@@@@             
                        @@@@@@@@@@@@@@@@@@@@@@@@@@#              *@@@@@@@@@@@@@@@@@@@@@@@@@@@             
                        +@@@@@@@@@@-         *@@@@@@@@@@@@@@@@@@@@@@@@:          %@@@@@@@@@@              
                         @@#                       @@@@@@@@@@@@@@                        +@@
               
 ##  ##  #######    ###    ####     ########  ##  ##           ##   ##    ###      ####    ##  ##   ######  ##   ##  #######
 ##  ##   ##   #   ## ##    ##      ## ## ##  ##  ##           ### ###   ## ##    ##  ##   ##  ##     ##    ###  ##   ##   #
 ##  ##   ##      ##   ##   ##         ##     ##  ##           #######  ##   ##  ##        ##  ##     ##    #### ##   ##
 ######   ####    ##   ##   ##         ##     ######           ## # ##  ##   ##  ##        ######     ##    #######   ####
 ##  ##   ##      #######   ##         ##     ##  ##           ##   ##  #######  ##        ##  ##     ##    ## ####   ##
 ##  ##   ##   #  ##   ##   ##  ##     ##     ##  ##           ##   ##  ##   ##   ##  ##   ##  ##     ##    ##  ###   ##   #
 ##  ##  #######  ##   ##  #######    ####    ##  ##           ### ###  ##   ##    ####    ##  ##   ######  ##   ##  #######"
echo ""
echo ""
verificar_java
}
logoHealth
