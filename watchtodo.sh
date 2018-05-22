#!/usr/local/bin/bash
#
# watchtodo -- watch todo on current directory.
#
# usage:  watchtodo start
#         watchtodo stop
#         watchtodo recieve
#         watchtodo filename <todo-txt's file path(from current dir)>
# copyright (c) 2018 Cj-bc
# This software is released under MIT License.


# treat functions related with files.
# @param <string command>
function watchtodo.file {

  [ -d "~/.watchtodo" ] && mkdir ~/.watchtodo
  case $1 in
    "filename" | "oldPS1" ) echo $2 > ~/.watchtodo/$1;;
  esac
}

# start watchtodo. Change PS1 to get pwd
# @return 0 success
function watchtodo.start {
  old_PS1=$(echo $PS1)
  watchtodo.file oldPS1 $PS1
  export PS1="${old_PS1}\$(echo \\$(pwd) >~/.watchtodo/pwd 2>/dev/null)" || return 1
  return 0
}

# reset PS1 to previous one
# @return 0 success
function watchtodo.stop {
  export PS1=$(cat ~/.watchtodo/oldPS1)
  return 0
}


# check ~/.watchtodo/pwd, and display todo.txt under there
function watchtodo.recieve {
  [ -f "~/.watchtodo/flag" ] && echo "watchtodo already running" >2
  touch ~/.watchtodo/flag
  # if ~/.watchtodo/flag is disappeared, finish this loop
  while [ -f ~/.watchtodo/flag ];do
    # 1. Check if current working directory is changed.
    # 2. if changed, kill previous watchfile process (if exists)
    # 3. start new watchfile process on background
    # 4, Get process ID of watchfile
    if [ "$pre_pwd" != "$(cat ~/.watchtodo/pwd)" ]; then
      pre_pwd=$(cat ~/.watchtodo/pwd)
      pwd=$(cat ~/.watchtodo/pwd)
      [ -f "$pwd/$(cat ~/.watchtodo/filename || echo todo.txt)" ] && watchfile $pwd/$(cat ~/.watchtodo/filename || echo todo.txt) &
      readonly pre_pid=$!
      [ -z "$pre_pid" ] || kill $pre_pid 1>/dev/null 2>&1
    fi
    sleep 1
  done
  rm ~/.watchtodo/flag
}




case $1 in
  "start" | "stop" | "recieve" ) watchtodo.$1;;
  "filename" ) watchtodo.file filename $2;;
esac
