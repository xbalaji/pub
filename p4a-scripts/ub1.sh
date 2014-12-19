#----------------------------------------------#
 sudo apt-get -y remove --purge libreoffice* 
 sudo apt-get -y remove unity-webapps-common
 sudo apt-get -y purge -y thunderbird*
 sudo apt-get -y purge gnome-games-common gbrainy
 sudo apt-get -y purge aisleriot gnome-sudoku mahjongg ace-of-penguins gnomine gbrainy
 sudo apt-get -y purge firefox
 sudo rm -fr /etc/firefox /usr/lib/firefox /usr/lib/firefox-addons/
 sudo echo "blacklist floppy" | tee /etc/modprobe.d/blacklist-floppy.conf 
 sudo rmmod floppy
 sudo update-initramfs -u
 sudo apt-get -y install libxss1 libappindicator1 libindicator7

 # wget 
 # https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

 sudo dpkg -i google-chrome-stable_current_amd64.deb 

 sudo apt-get -y install -y openssh-server openssh-client git openjdk-7-jdk vim
 sudo apt-get -y install python-pip python-dev

 sudo apt-get clean
 sudo apt-get autoremove
#----------------------------------------------#


