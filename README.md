# watchtodo -- watch todo on your directory, in other pane in tmux

this is wrapper of [watchfile](https://github.com/Cj-bc/watchfile) specialized in [todo-txt](https://github.com/todotxt/todo.txt).
If you define your TODO_DIR to somewhere one place, this won't help you.
In that case, please use my [watchfile](https://github.com/Cj-bc/watchfile).

Please use with tmux/GNU screen so that you can feel its magical power ;)

# what is watchfile (which is made by Cj-bc)

the [watchfile](https://github.com/Cj-bc/watchfile) is real time file viewer.
While running, watchfile automatically detect the changing and show it in the same window.


# feature

  * display todo.txt at current directory automatically.


# usage

If you don't use 'todo.txt' for todo file, please set it:

```bash
$ watchtodo filename <your todo.txt file name>
```

1. In your working pane, run:

```bash
$ watchtodo start
```

2. In non working pane(which todo contents will be displayed), run:

```bash
$ watchtodo recieve
```


# Installation

## for all types of installation

  Please set your PS1 to output $(pwd) to specific file so that `watchtodo recieve` can know where you are now.

  ```
  export PS1="${PS1} \$(echo \$(pwd) >~/.watchtodo/pwd 2>/dev/null)"
  ```

## homebrew

## bpkg

## from source
