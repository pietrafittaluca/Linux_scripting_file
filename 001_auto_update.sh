red=$(tput setaf 1)
reset=$(tput sgr0)
 
sudo apt-get update -y
echo "$red Comando 1: eseguito. $reset"
 
sudo apt-get upgrade -y
echo "$red Comando 2: eseguito. $reset"
 
sudo apt-get dist-upgrade -y
echo "$red Comando 3: eseguito. $reset"

sudo apt full-upgrade -y
echo "$red Comando 4: eseguito. $reset" 

sudo ubuntu-drivers autoinstall
echo "$red Comando 5: eseguito. $reset"
 
sudo apt-get clean -y
echo "$red Comando 6: eseguito. $reset"

sudo apt-get autoclean -y
echo "$red Comando 7: eseguito. $reset"
   
sudo apt-get autoremove -y
echo "$red Comando 8: eseguito. $reset"
