#----------------------------------------------#
  sudo add-apt-repository -y ppa:kivy-team/kivy
  sudo apt-get -y install python-kivy
  sudo apt-get -y install python-kivy-common
  sudo apt-get -y install cython zlib1g-dev ant expect
  sudo apt-get -f install -y
  sudo pip install cython==0.21
  sudo pip install jinja2

  sudo dpkg --add-architecture i386
  sudo apt-get -qqy update
  sudo apt-get -qqy install libncurses5:i386 libstdc++6:i386 zlib1g:i386

  sudo apt-get clean
  sudo apt-get autoremove


#----------------------------------------------#

