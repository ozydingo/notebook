## .bash_profile

* `PS1='\[${BLUE}\]\w\[${NORMAL}\] '`
* `export CLICOLOR=1`: Use colors in `ls` output (e.g. directories display blue, executables red, etc).
* `export LESS=-R`: Parse special characters when using `less`. This is very useful for a lot of logs that use colors, e.g. Rails logger.
* `export EDITOR=emacs`: You really wanna use `vi`? Go for it.
