
if [ -z "$TODOTXT_DEFAULT_ACTION" ]; then
  # typing 't' by itself will list current todos
  export TODOTXT_DEFAULT_ACTION=ls
fi

alias t='todo.sh'
