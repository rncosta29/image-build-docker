#!/bin/bash
 
#setando timestamp
timestamp_teste=`date '+%Y-%m-%d_%Hh%Mm%Ss'`

#dev.azure.com/yaman-apm/YAMAN%20-%20Yaman%20Performance%20Tool/_git/apm-esteira-azure-bots

cd /opt/yaman/jmeter

#clonando jmeter
#git clone https://$(System.AccessToken)@dev.azure.com/bancotoyota/Devops-Corporativo/_git/scripts-yaman
git clone https://$1@$2
#git clone https://bancotoyota@dev.azure.com/bancotoyota/APM/_git/APM
 
#permissão no robô
chmod 775 /opt/yaman/apm-esteira-azure-bots/bot/bot-busca-google.jmx
 
#copiando o robô para a pasta scripts
#cp /opt/yaman/teste/jmeter.jmx /opt/yaman/scripts

cd apm-esteira-azure-bots

if [ ! -d "/opt/yaman/jmeter/apm-esteira-azure-bots/logs" ];
then
    mkdir logs
fi

if [ ! -d "/opt/yaman/jmeter/apm-esteira-azure-bots/outputs"];
then
    mkdir outputs
fi
 
#executando Jmeter
#/opt/yaman/jmeter/apache-jmeter-5.5/bin/jmeter -j /opt/yaman/outputs/jmeter_${timestamp_teste}.log -n -t /opt/yaman/scripts/jmeter.jmx -l /opt/yaman/outputs/resultado_${timestamp_teste}.csv
jmeter -j /opt/yaman/jmeter/apm-esteira-azure-bots/results/jmeter_${timestamp_teste}.log -n -t /opt/yaman/jmeter/apm-esteira-azure-bots/bot/bot-busca-google.jmx -l /opt/yaman/jmeter/apm-esteira-azure-bots/outputs/resultado_${timestamp_teste}.csv
 
#copiando o resultado o jmeter.log para a pasta do GIT
#cp /opt/yaman/outputs/resultado_${timestamp_teste}.csv /opt/yaman/jmeter/apm-esteira-azure-bots
#cp /opt/yaman/outputs/jmeter_${timestamp_teste}.log /opt/yaman/jmeter/apm-esteira-azure-bots
 
#indo para o diretorio do GIT
cd /opt/yaman/jmeter/apm-esteira-azure-bots
 
#informando usuario do GIT
#git config --global user.email "renato.olimelo@gmail.com"
#git config --global user.name "Renato Melo"
 
#Subindo o arquivo para o git hub
#git add resultado_${timestamp_teste}.csv jmeter_${timestamp_teste}.log
git add .
git commit -m "resultado_${timestamp_teste}.csv"
#git push https://${GIT_USER}:${GIT_PASSWORD}@github.com/renatoolimelo/teste.git --all
git push
 
#exit 0