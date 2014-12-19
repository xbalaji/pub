#----------------------------------------------#

mkdir -p $HOME/tools
cd $HOME/tools

tar xvfz android-sdk_r24.0.1-linux.tgz
echo "now select the android sdk you want to install"

# spawn $env(HOME)/tools/android-sdk-linux/tools/android update sdk -s --no-ui --filter extra,platform,platform-tool,tool,$env(pkgs);

export pkgs=$(./android-sdk-linux/tools/android list sdk | grep 'Android.*API 14' | cut -d "-" -f1-1 | tr '\n' ',' | sed -e 's, ,,g;s/,$//g')

echo $pkgs
read dummy

expect -c '
set timeout -1 ;
spawn $env(HOME)/tools/android-sdk-linux/tools/android update sdk -s --no-ui --filter $env(pkgs),tool,platform-tool,doc;

expect {
   "Do you accept the license" { exp_send "y\r"; exp_continue }
   eof
}
'

# now update tool chain
#expect -c '
#set timeout -1 ;
#spawn $env(HOME)/tools/android-sdk-linux/tools/android update sdk -u;
#
#expect {
#   "Do you accept the license" { exp_send "y\r"; exp_continue }
#   eof
#}
#'

#----------------------------------------------#


