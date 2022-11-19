#!/bin/bash

PURPLE='0;35'
NC='\033[0m' 
VERSAO=11
	
echo  "$(tput setaf 10)[Bot assistant]:$(tput setaf 7) Olá, serei seu assistente para instalação do Java!;"
echo  "$(tput setaf 10)[Bot assistant]:$(tput setaf 7)  Verificando aqui se você possui o Java instalado...;"
sleep 2

java -version
if [ $? -eq 0 ]
	then
		echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7) : Você já tem o java instalado!!!"
	else
		echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7)  Opa! Não identifiquei nenhuma versão do Java instalado, mas sem problemas, irei resolver isso agora!"
		echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7)  Confirme para mim se realmente deseja instalar o Java (S/N)?"
	read inst
	if [ \"$inst\" != \"S\" ]
		then
			echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7)  Ok! Você escolheu instalar o Java ;D"
			echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7)  Adicionando o repositório!"
			sleep 2
			sudo add-apt-repository ppa:webupd8team/java -y
			clear
			echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7)  Atualizando! Quase lá."
			sleep 2
			sudo apt update -y
			clear
			
			if [ $VERSAO -eq 11 ]
				then
					echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7) Preparando para instalar a versão 11 do Java. Confirme a instalação quando solicitado ;D"
					sudo apt install default-jre ; apt install openjdk-11-jre-headless; -y
					clear
					echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7) Java instalado com sucesso!"
				fi
		else 	
		echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7)  Você optou por não instalar o Java por enquanto, até a próxima então!"
	fi
fi
# ===================================================================
# Todos direitos reservados para o autor: Dra. Profa. Marise Miranda.
# Sob licença Creative Commons @2020
# Podera modificar e reproduzir para uso pessoal.
# Proibida a comercialização e a exclusão da autoria.
# ===================================================================



# ===================================================================
# Intalação do projeto.
# ===================================================================
echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7)  Selecione a versão que deseja baixar (cli/display)"
read versaojar
if [ \"$versaojar\" == "cli"]
then
echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7)  Ok! Você escolheu instalar a versão CLI ;D"
			echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7)  Adicionando o repositório!"
      clear
      git clone https://github.com/Monitoramento-Funcionario/CLI-jar.git
clear
      cd Jar-Exe/target
      sudo java -jar MiracleSolution-JFrame-1.0-SNAPSHOT-jar-with-dependencies.jar
else
echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7)  Ok! Você escolheu instalar a versão Display ;D"
			echo "$(tput setaf 10)[Bot assistant]:$(tput setaf 7)  Adicionando o repositório!"
      clear
      git clone https://github.com/Monitoramento-Funcionario/Jar-Exe.git
      clear
      cd Jar-Exe/target
      sudo java -jar MiracleSolution-JFrame-1.0-SNAPSHOT-jar-with-dependencies.jar
fi


