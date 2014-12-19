source $HOME/.android-env

# $HOME/tools/android-sdk-linux/tools/android update sdk -u

cd $HOME/tools/python-for-android/
./distribute.sh -m "pil openssl kivy"


cd $HOME/tools/python-for-android/dist/default/
./build.py --dir ~/p4a/eg1/ --package org.test.kivy --name "Kivy Test" --version 0.1 debug
ls -lrt bin


#----------------------------------------------#

