#/bin/bash/env bats

# needed test case:
#   check all configuration files are automatically generated by watchtodo.
#   as interactive shell, is file `~/.watchtodo/pwd` changing?
#   `watchtodo recieve` -- test to load not exit file -> success, catch message(stdout)
#   `watchtodo recieve` -- test to load exist file -> success



# setup environment
# 1. Backup ~/.watchtodo
# 2. Make 2 temporary directory and make 'todo' under each dir
# 3. Make todo.txt for each dir
function setup {
  [ -d ~/watchtodo ] && mv ~/.watchtodo ~/.watchtodo.backup
  mkdir -p $BATS_TMPDIR/{dev1,dev2}/todo
  echo "here's under dev1" > $BATS_TMPDIR/dev1/todo/todo.txt
  echo "here's under dev2" > $BATS_TMPDIR/dev2/todo/todo.txt
}


# test watchtodo.filename
# 1. Set filename to "todo/todo.txt"
# 2. Check status
# 3. Check if directory is exist
# 4. Check if "filename" is exist
# 5. Check if the contents of "filename" is correct
@test "'watchtodo filename' test" {
  run watchtodo filename todo/todo.txt
  [ $status -eq 0 ]
  [ -d ~/watchtodo ]
  [ -f ~/watchtodo/filename ]
  [ "$(cat ~/watchtodo/filename)" = "todo/todo.txt" ]
}


# test watchtodo.recieve
# 1. Move under tempdir
# 2. Check stdout
# 3. Move to another tempdir
# 4. Check stdout
# 5. Move to $BATS_TMPDIR which doesn't have 'todo' dir
# 6. Check stdout
@test "'watchtodo recieve' test" {
  cd $BATS_TMPDIR/dev1
  run watchtodo recieve
  [ "${lines[0]}" = "here's under dev1" ]
  cd $BATS_TMPDIR/dev2
  [ "${lines[0]}" = "here's under dev2" ]
  cd $BATS_TMPDIR
  [ "${lines[0]}" = "file: todo/todo.txt dosn't exist here." ]
}

# test run watchtodo.recieve when another one is running -> should be failed
@test "run `watchtodo recieve` twice -> fail" {
  touch ~/.watchtodo/flag
  run watchtodo recieve
  [ $status -eq 70 ]
}


function teardown {
  [ -d ~/watchtodo.backup ] && mv ~/.watchtodo.backup ~/.watchtodo
  rm -rf $BATS_TMPDIR
}
