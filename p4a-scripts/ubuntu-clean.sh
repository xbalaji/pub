#----------------------------------------------#
 apt-get -y remove --purge libreoffice* 
 apt-get -y remove unity-webapps-common
 apt-get -y purge -y thunderbird*
 apt-get -y purge gnome-games-common gbrainy
 apt-get -y purge aisleriot gnome-sudoku mahjongg ace-of-penguins gnomine gbrainy
 apt-get -y purge firefox
 rm -fr /etc/firefox /usr/lib/firefox /usr/lib/firefox-addons/
 echo "blacklist floppy" | tee /etc/modprobe.d/blacklist-floppy.conf 
 rmmod floppy
 update-initramfs -u
 apt-get -y install libxss1 libappindicator1 libindicator7

 # wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

 dpkg -i google-chrome-stable_current_amd64.deb 

 apt-get -y install -y openssh-server openssh-client git openjdk-7-jdk vim
 apt-get -y install python-pip python-dev

 apt-get clean
 apt-get autoremove
#----------------------------------------------#

#----------------------------------------------#
  add-apt-repository ppa:kivy-team/kivy
  apt-get -y install python-kivy
  apt-get -y install python-kivy-common
  apt-get -y install cython zlib1g-dev ant expect
  apt-get -f install -y
  pip install cython==0.21
  pip install jinja2

  dpkg --add-architecture i386
  apt-get -qqy update
  apt-get -qqy install libncurses5:i386 libstdc++6:i386 zlib1g:i386

  apt-get clean
  apt-get autoremove


#----------------------------------------------#

#----------------------------------------------#
# git clone https://github.com/kivy/python-for-android

mkdir $HOME/tools
cd $HOME/tools

wget http://dl.google.com/android/android-sdk_r24.0.1-linux.tgz
tar xvfz android-sdk_r24.0.1-linux.tgz
echo "now select the android sdk you want to install"

export pkgs=$(./android-sdk-linux/tools/android list sdk | grep 'Android.*API 14' | cut -d "-" -f1-1 | tr '\n' ',' | sed -e 's, ,,g;s/,$//g')

echo $pkgs

expect -c '
set timeout -1 ;
spawn $env(HOME)/tools/android-sdk-linux/tools/android update sdk -s --no-ui --filter $env(pkgs);

expect {
   "Do you accept the license" { exp_send "y\r"; exp_continue }
   eof
}
'

#----------------------------------------------#

#----------------------------------------------#
cd $HOME/tools
wget http://dl.google.com/android/ndk/android-ndk-r10d-linux-x86_64.bin
chmod +x android-ndk-r10d-linux-x86_64.bin
./android-ndk-r10d-linux-x86_64.bin

ls -1l $HOME/tools/android-ndk-r10d-linux-x86_64.bin $HOME/tools/android-sdk_r24.0.1-linux.tgz $HOME/google-chrome-stable_current_amd64.deb 

#----------------------------------------------#

#----------------------------------------------#
cat << EOF > $HOME/.android-env
export ANDROIDSDK="$HOME/tools/android-sdk-linux"
export ANDROIDNDK="$HOME/tools/android-ndk-r10d"
export ANDROIDNDKVER=r10d
export ANDROIDAPI=14
export P4A="$HOME/tools/python-for-android"
PATH=$PATH:$ANDROIDSDK/tools:$P4A/dist/default
EOF

source $HOME/.android-env

# cd $HOME/tools/python-for-android/
# ./distribute.sh -m "pil openssl kivy"


mkdir -p $HOME/p4a/eg1
cd $HOME/p4a/eg1

cat << EOF > $HOME/p4a/eg1/main.py
from kivy.uix.boxlayout import BoxLayout
from kivy.app import App

class KivyScreen(BoxLayout):
   pass

class KivyApp(App):
   def build(self):
       return KivyScreen()

if __name__ == "__main__":
   KivyApp.run()

EOF

cd $HOME/tools/python-for-android/dist/default/
./build.py --dir ~/p4a/eg1/ --package org.test.kivy --name "Kivy Test" --version 0.1 debug
ls -lrt bin


#----------------------------------------------#

