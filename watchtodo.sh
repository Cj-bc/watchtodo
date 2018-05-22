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


# see detail: /usr/include/sysexits.h
EX_OSFILE=72
EX_OSERR=71
EX_OK=0


# treat functions related with files.
# @param <string command>
function watchtodo.file {

  [ -d "~/.watchtodo" ] && mkdir ~/.watchtodo
  case $1 in
    "filename" | "oldPS1" ) echo $2 > ~/.watchtodo/$1;;
  esac

  return 0
}


# remove flag.
# @param <string path of flag>
# @return 0 success
# @return 71 couldn't remove flag
# @return 72 flag was not exist
function watchtodo.rmflag {
  # 1. check whether flag exists
  # 2. try to remove flag.
  # 3. If failed to remove, try for 10 times.
  local flagfile=$1
  [-f "$flagfile" ] || echo "Flag: $flagfile is not exist" && return $EX_OSFILE
  while ! ${success?:-1} && [ $i -lt 10 ]; do
    rm $flagfile
    local success?=$?
    local i=$i+1
  done
  [ $success? -ne 0 ] && echo "Couldn't remove the flag: $flagfile" return $EX_OSERR

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
      [ -z "$pre_pid" ] || kill $pre_pid 1>/dev/null 2>&1
      if [ -f "$pwd/$(cat ~/.watchtodo/filename || echo todo.txt)" ]; then
        watchfile $pwd/$(cat ~/.watchtodo/filename || echo todo.txt) &
        readonly pre_pid=$!
      fi
    fi
    sleep 1
  done
  rm ~/.watchtodo/flag
}


# finish watchtodo
function watchtodo.end {
  watchtodo.rmflag ~/.watchtodo/flag
  trap - SIGKILL
  exit 0
}


trap watchtodo.end SIGKILL

case $1 in
  "start" | "stop" | "recieve" ) watchtodo.$1;;
  "filename" ) watchtodo.file filename $2;;
esac
