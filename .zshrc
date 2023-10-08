# shellcheck shell=bash

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

setopt appendhistory
setopt sharehistory
bindkey -e

zstyle :compinstall filename '/Users/ashinn/.zshrc'

autoload -Uz compinit
compinit

autoload -Uz bashcompinit
autoload zmv
bashcompinit

setopt NO_NOMATCH

export HOMEBREW_GITHUB_API_TOKEN=""
export HOMEBREW_NO_ENV_HINTS=1
export DOCKER_BUILDKIT=1
export _ARGCOMPLETE_SHELL=tcsh
export NPM_CONFIG_FUND=false
export NPM_CONFIG_AUDIT=false
export KICS_QUERIES_PATH=/usr/local/opt/kics/share/kics/assets/queries

# export PATH="/usr/local/opt/python@3.7/bin:$PATH"
# export PATH="/usr/local/opt/python@3.9/bin:$PATH"
# export PATH="/usr/local/opt/python@3.8/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"

alias dri='docker run --rm -ti'
alias d='docker'
alias g='git'
alias a='awsume'
alias t='terraform'
alias rplay='dri -v $PWD:$PWD -w $PWD -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN -e AWS_REGION -e ANSIBLE_INVENTORY_ENABLED -e ANSIBLE_TRANSFORM_INVALID_GROUP_CHARS -e TWILIO_ACCOUNT_SID -e TERRAFORM_ENV --mount type=bind,src=/run/host-services/ssh-auth.sock,target=/run/host-services/ssh-auth.sock -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" ghcr.io/vht/ansible:latest'
alias awsume="source awsume"

eval "$(starship init zsh)"
eval "$(jump shell)"
eval "$(direnv hook zsh)"
eval "$(rbenv init - zsh)"
eval "$(rtx activate zsh)"

fpath=(~/.awsume/zsh-autocomplete/ $fpath)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f /usr/local/opt/asdf/libexec/asdf.sh ] && source /usr/local/opt/asdf/libexec/asdf.sh

function tfe() {
    if [ -z "$1" ]; then
        echo "Usage: tf <project> <terraform arguments>"
        return
    fi

    local folder
    folder="$1"; shift

    pushd "$folder" > /dev/null || exit 1
    command terraform "$@"
    popd > /dev/null || exit 1

}

function find() {
  { LC_ALL=C command find -x "$@" 3>&2 2>&1 1>&3 | \
    grep -v -e 'Permission denied' -e 'Operation not permitted' >&3; \
    [ $? = 1 ]; \
  } 3>&2 2>&1
}

function decodests() {
  aws sts decode-authorization-message --encoded-message "$@" | jq '.DecodedMessage | fromjson'
}
