PS1='> '
function cd {
  builtin cd "$@" && ls
}
function untar {
  tar xvzf "$@"
}
function mkcdir {
  mkdir -p -- "$1" &&
  cd -P -- "$1"
}
alias fixKeyboard="ibus-daemon -rd"
alias inst="sudo apt-get install"
function mkcdir {
  mkdir -p -- "$1" &&
  cd -P -- "$1"
}

# JAVA
export PATH=/home/orestis/bin:/opt/ros/indigo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/idea-IU-141.2735.5/bin/
export JAVA_HOME=/usr/lib/jvm/java-8-oracle
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/opencv-2.4.9/bin/lib

# virtualenv
. /usr/local/bin/virtualenvwrapper.sh

# SQLite
export SQLALCHEMY_DATABASE_URI="sqlite:///foo.db"

# external IP
alias extip="curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//'"

# ssh to okeanos
alias okeanos="ssh snf-709756.vm.okeanos.grnet.gr"