
alias_file_linepath() {
    echo "$ALIAS_FILE_PATH" | linewise : | linetest -f | deduplicate
}
alias_source() {
    lambda file : 'source "$file"' < <(alias_file_linepath )
}
alias_addsource() {
    ALIAS_FILE_PATH="$1:$ALIAS_FILE_PATH"
    alias_source
}
alias_file_choose() {
    local chosen="$1"
    if [[ "$chosen" == '--reset' ]]; then
        ALIAS_FILE=
        return 0
    fi
    if [[ ! -f "$chosen" ]]; then
        chosen="$( alias_file_linepath | interactiveSelect --multi --preview 'cat {}' )" || return 1
    fi
    ALIAS_FILE="$chosen"
}
alias_file_check() {
    local aliasfile="$( _get_aliasfile )"
    if [[ ! $ALIAS_FILE ]]; then
        echo the alias file is the last file in the ALIAS_FILE_PATH
    fi
    echo "active file: $aliasfile"
}

_get_aliasfile() {
    local result
    if [[ ! $ALIAS_FILE ]]; then
        result="$(alias_file_linepath | head -n 1)"
    else
        result="$ALIAS_FILE"
    fi
    
    if [[ ! -f "$result" ]]; then
        log_error "ALIAS_FILE: '$aliasfile' doesnt exist"
        return 1
    fi
    echo "$result"
}

alias_addsource "$mod_bashrc_general_root/aliases/aliases.sh"
alias_make() {
    author 'Simon Leischnig'
    about 'makes and sources an alias directly'
    param '1: alias name'
    param '2: alias stub'
    example ''
    group 'system'
    helppath ''
    url ''

    if [[ ! $ALIAS_FILE_PATH ]]; then
        "ALIAS_FILE_PATH is not set!"
        return 1
    fi
    local aliasfile="$( _get_aliasfile )"

    local remove=0
    if [[ "$1" == '--remove' ]]; then
        local remove=1
        shift
    fi
   
    if [[ "$remove" == 0 ]]; then
        local name="$1"
        shift
        local body="$*"
        if [[ ! $name || ! $body ]]; then
            log_error "not enough args, see reference alias_make"
        fi
        local aliasstub="$( printf 'alias %s' "$name" )"
        local aliasbody="'$body'"
        local greppattern='^'"$aliasstub"'='"'"'.+'"'"''
        if alias | grep -E "$greppattern" > /dev/null; then
            log_error alias with definition "$aliasstub" already exists
            return 1
        fi
        local aliascmd="$aliasstub=$aliasbody"
        echo "$aliascmd" >> "$aliasfile"
        eval "$aliascmd"
    else
        local name="$1"
        if [[ ! $name ]]; then
            log_error "provide a name to remove"
        fi
        local aliasstub="$( printf 'alias %s' "$name" )"
        alias_file_linepath | lambda file : 'sed -i "/^$aliasstub=/d" "$file"'
        local aliascmd="$aliasstub="
        eval "$aliascmd"
    fi

}
