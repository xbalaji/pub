#----------------------------------------------#

mkdir -p $HOME/tools
cd $HOME/tools

git clone https://github.com/kivy/python-for-android

# wget http://dl.google.com/android/android-sdk_r24.0.1-linux.tgz
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
# wget http://dl.google.com/android/ndk/android-ndk-r10d-linux-x86_64.bin
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

cd $HOME/tools/python-for-android/
./distribute.sh -m "pil openssl kivy"


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

