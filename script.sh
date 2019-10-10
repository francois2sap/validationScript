#!/bin/bash
echo -e "\e[31mBienvenue sur mon Script!\e[0m"
echo "Ceci est un script permettant de savoir si un paquet est installé, si la réponse est non pas de soucis... Je vais l'installé pour toi!"
echo "Entre le nom du paquet que tu souhaites installer: "
read name
getName() {
dpkg-query --show  $name

if [ "$?" = "0" ];
then
    echo "$name" found
else
    echo "$name" not found. Please approve installation.
    sudo apt-get install "$name"
    if [ "$name" = "0" ];
    	then echo "$name" installed successfully.
    fi
fi
}

getName

echo "Vagrant.configure("\"2"\") do |config|" > Vagrantfile
echo "Vagrantfile crée, nous allons désormais le configurer. "
read -p "Veux-tu modifier le nom du dossier synchronisé local ? O/n " choice

if [ $choice == "O" ]
then
    read -p "Merci d'entrer le nouveau nom du dossier : " folderName
    mkdir $folderName
    echo "config.vm.synced_folder "\"./$folderName"\", "\"/var/www/html"\"" >> Vagrantfile
else
    echo "Très bien. Le nom du dossier par défaut sera donc 'data.'"
    mkdir data
    echo "config.vm.synced_folder "\"./data"\", "\"/var/www/html"\"" >> Vagrantfile
fi

echo "Super! Tu as maintenant le choix entre ces 3 boxes: 
	1) ubuntu/trusty64
	2) ubuntu/xenial64
	3) hashicorp/precise64
"
read boxChoice
case $boxChoice in
    1) 
        echo "Box trusty choisie."
        echo "config.vm.box = "\"ubuntu/trusty64"\"" >> Vagrantfile
    ;;
    2) 
        echo "Box xenial choisie."
        echo "config.vm.box = "\"ubuntu/xenial64"\"" >> Vagrantfile
    ;;
    3) 
        echo "Box precise choisie."
        echo "config.vm.box = "\"hashicorp/precise64"\"" >> Vagrantfile
    ;;
    *) 
        echo "Box par défaut (xenial) chosie."
        echo "config.vm.box = "\"ubuntu/xenial64"\"" >> Vagrantfile
    ;;
esac

read -p "Nous allons désormais changer l'adresse IP, celle par défaut sera 192.168.33.10, veux-tu la changer? O = oui " choice2
if [ $choice2 == "O" ]
then
	read -p "Merci d'entrer une adresse IP valide : " ipAdress
	echo "config.vm.network "\"private_network"\", ip: "\"$ipAdress"\"" >> Vagrantfile
else
	echo "Pas de changement."
	echo "config.vm.network "\"private_network"\", ip: "\"192.168.33.10"\"" >> Vagrantfile
fi

echo "end" >> Vagrantfile

echo "Vérification des boxes up : "

vagrant global-status

read -p "Veux-tu désormais lancer ta box? O/n " choice3
if [ $choice3 == "O" ]
then
	echo " box en lancement "
	vagrant up
else
	echo "Pas de changement. "
fi
