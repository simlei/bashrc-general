copyline() { printf %s "$READLINE_LINE" | xclip -selection clipboard; }
clipping() {
  bind -x '"\C-y":copyline'
}
clipl() {
  history -p !! | xargs echo -n | xclip -selection clipboard
}
# TODO: revise; make into plugin?
if $(has xclip); then clipping; fi
