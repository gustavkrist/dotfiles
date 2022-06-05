# -- INIT ---------------------------------------------------------------------

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# -- ZINIT --------------------------------------------------------------------

if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# # Load a few important annexes, without Turbo
# # (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# -- PLUGINS ------------------------------------------------------------------


zinit ice depth=1
zinit light romkatv/powerlevel10k
# zinit ice as"command" from"gh-r" \
#           atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
#           atpull"%atclone" src"init.zsh"
# zinit light starship/starship
# $(starship init zsh)
fpath+=${ZDOTDIR:-~}/.zsh_functions

_zshrc_after_load() {
  eval "$(zoxide init zsh)"
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  bindkey "^O" dotbare-fedit
}

zinit wait lucid light-mode for \
  Aloxaf/fzf-tab \
  atload'bindkey "^o" dotbare-fedit' \
    kazhala/dotbare \
  atload'_zsh_autosuggest_start;
  unset ZSH_AUTOSUGGEST_USE_ASYNC;
  bindkey -v "^ " autosuggest-accept' \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions \
  softmoth/zsh-vim-mode \
  hlissner/zsh-autopair \
  urbainvaes/fzf-marks \
  OMZ::lib/git.zsh \
  atload"unalias grv" OMZ::plugins/git/git.plugin.zsh \
  ael-code/zsh-colored-man-pages \
  OMZP::sudo \
  OMZP::web-search \
  OMZP::copypath \
  OMZP::copyfile \
  OMZP::dirhistory \
  OMZP::jsontools \
  kutsan/zsh-system-clipboard \
  atinit'zicompinit;
  zicdreplay;
  _dotbare_completion_cmd;
  _zshrc_after_load' \
    zdharma-continuum/fast-syntax-highlighting \

# -- SETTINGS -----------------------------------------------------------------

HISTSIZE=50000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history
setopt nobeep

# -- PATH ---------------------------------------------------------------------

export PATH=$PATH:$HOME/.ghcup/bin
export PATH=$PATH:$HOME/.npm-global-bin
export PATH="$PATH:$HOME/.local/bin"
fpath=( ~/.zsh_functions "${fpath[@]}" )

# -- SYSTEM ENV ---------------------------------------------------------------

export EDITOR='lvim'
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export COLORTERM="truecolor"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# -- ALIASES ------------------------------------------------------------------

alias ..="cd .."
alias cd="z"
alias zz="z -"
alias ls="exa"
alias ll="exa -l"
alias zshconf="lvim ~/.zshrc"
alias mux="tmuxinator"
alias tml="tmux list-sessions"
alias tma="tmux attach -t"
alias db="dotbare"
alias py="python"
alias ipy="ipython"
alias fgrep="fgrep --color"
alias egrep="egrep --color"
alias rvim="nvr --remote"
alias r="radian"
alias lg="lazygit"
alias chrome="open -a 'Google Chrome'"
alias fp="fzf-tmux -p -w 90% -h 90% -- --preview \
  'bat --theme ansi --style=numbers --color=always --line-range :500 {}'"

# -- PLUGIN CONFIG ------------------------------------------------------------

# VI MODE

bindkey -M viins 'jk' vi-cmd-mode
MODE_CURSOR_VIINS="#d8dee9 steady bar"
MODE_CURSOR_REPLACE="$MODE_CURSOR_VIINS #ff0000"
MODE_CURSOR_VICMD="white block"
MODE_CURSOR_SEARCH="#ff00ff steady underline"
MODE_CURSOR_VISUAL="$MODE_CURSOR_VICMD steady block"
MODE_CURSOR_VLINE="$MODE_CURSOR_VISUAL #00ffff"

# FZF

alias fzf="fzf-tmux -p 70%"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
  --height 40% --layout=reverse --border --cycle --info=inline --ansi
  --bind=ctrl-d:preview-page-down
  --bind=ctrl-u:preview-page-up"

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:#e5e9f0,bg:#2d3441,hl:#81a1c1
    --color=fg+:#e5e9f0,bg+:#2d3441,hl+:#81a1c1
    --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
    --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
export FZF_ALT_C_OPTS="--preview 'tree -L 1 -C --dirsfirst {} | head -200'"
export FZF_TMUX_OPTS="-p 70%"

# Use fd for fuzzy completion
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}


# FZF-TAB

zstyle ':fzf-tab:*' fzf-command fzf-tmux
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:*' fzf-flags -p 50%,50%
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'tree -L 1 -C --dirsfirst $realpath | head -200'
zstyle ':fzf-tab:complete:cd:*' fzf-flags -p 70%,50%
zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word | delta'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-flags -p 90%,90% --preview-window=right:70%
zstyle ':fzf-tab:complete:lvim:*' fzf-preview \
  'bat --theme ansi --style=numbers --color=always --line-range :500 $realpath'
zstyle ':fzf-tab:complete:lvim:*' fzf-flags -p 70%,70%

# DOTBARE

export DOTBARE_FZF_DEFAULT_OPTS="--height=100% --preview-window=right:60%"
export DOTBARE_PREVIEW="bat --theme ansi --style=numbers --color=always --line-range :500 {}"
export DOTBARE_DIFF_PAGER="delta --diff-so-fancy"
export DOTBARE_KEY="
  --bind=alt-a:toggle-all
  --bind=alt-j:jump
  --bind=alt-0:top
  --bind=alt-s:toggle-sort
  --bind=alt-t:toggle-preview
"

# LUNAR/NEOVIM

export LUNARVIM_RUNTIME_DIR="${LUNARVIM_RUNTIME_DIR:-"$HOME/.local/share/lunarvim"}"
export LUNARVIM_CONFIG_DIR="${LUNARVIM_CONFIG_DIR:-"$HOME/.config/lvim"}"
export LUNARVIM_CACHE_DIR="${LUNARVIM_CACHE_DIR:-"$HOME/.cache/nvim"}"
export NVIM_LISTEN_ADDRESS='/tmp/nvimsocket'

# MISCELLANIOUS

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
export ZSH_SYSTEM_CLIPBOARD_TMUX_SUPPORT="true"
export BAT_THEME="ansi"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#bddedc"
export LS_COLORS="$(vivid generate nord):*.plist=0;38;2;180;142;173:*.cson=0;38;2;180;142;173"
export GOKU_EDN_CONFIG_FILE="$XDG_CONFIG_HOME/karabiner/karabiner.edn"

# -- OS SPECIFIC --------------------------------------------------------------

if [[ "$OSTYPE" == 'darwin'* ]]; then
  alias grep="ggrep --color"
  export TERMINFO="/Users/gustavkristensen/opt/anaconda3/share/terminfo"
  export ANACONDA_PATH="/Users/gustavkristensen/opt/anaconda3"
  export FZF_PATH="/opt/homebrew/opt/fzf/"
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
elif [[ "$OSTYPE" == "linux-gnu"* ]] && [[ $(lsb_release -ds) =~ "Ubuntu" ]]; then
  if [[ "${WSL_DISTRO_NAME}" =~ Ubuntu.* ]]; then
    export TERM="xterm-256color"
    alias grep="grep --color"
    alias pbcopy="clip.exe"
    alias pbpaste="powershell.exe -command 'Get-Clipboard' | head -n -1"
    export ANACONDA_PATH="$HOME/anaconda3"
    export FZF_PATH="/home/linuxbrew/.linuxbrew/opt/fzf/"
    export DISPLAY="`grep nameserver /etc/resolv.conf | sed 's/nameserver //'`:0"
  fi
fi

# -- FUNCTIONS ----------------------------------------------------------------

autoload -Uz ${fpath[1]}/*(.:t)

# Rich print of file with less
richer () {
  rich "$@" --force-terminal | less -R
}

# Count files/dirs in directory (depth 1)
count () {
  local DIR=${1:?"Directory to count must be specified."}
  find $DIR ! -name $DIR -prune -print | grep -c /
}

# Count all files/dirs in directory and subdirectories
countall () {
  local DIR=${1:?"Directory to count must be specified."}
  find $DIR//. ! -name . | grep -c //
}

# Change tmux session wd
tmux-cwd () {
    tmux command-prompt -I $PWD -p "New session dir:" "attach -c %1"
 }

# fe [FUZZY PATTERN] - Open the selected file with the default editor
fe() {
  IFS=$'\n' files=($(fzf-tmux -p -w 90% -h 90% -- --query="$1" --multi --select-1 --exit-0 --preview 'bat --theme ansi --style=numbers --color=always --line-range :500 {}'))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  IFS=$'\n' out=("$(fzf-tmux -p -w 90% -h 90% -- --query="$1" --exit-0 --expect=ctrl-o,ctrl-e --preview 'bat --theme ansi --style=numbers --color=always --line-range :500 {}')")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

# find-in-file - usage: fif <searchTerm> or fif "string with spaces" or fif "regex"
fif() {
    if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
    local file
    file="$(rga --max-count=1 --ignore-case --files-with-matches --no-messages "$*" | fzf-tmux -p -w 80% -h 80% -- +m --preview="rga --ignore-case --pretty --context 10 '"$*"' {}")" && echo "opening $file" && lvim "$file" || return 1;
}

# Search though Lastpass vault and copy password
lp() {
  lpass show -c --password $(lpass ls  | fzf-tmux | awk '{print $(NF)}' | sed 's/\]//g')
}

# -- CONDA --------------------------------------------------------------------

# __conda_setup="$('${ANACONDA_PATH}/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
__conda_setup="$($ANACONDA_PATH'/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$ANACONDA_PATH/etc/profile.d/conda.sh" ]; then
        . "$ANACONDA_PATH/etc/profile.d/conda.sh"
    else
        export PATH="$ANACONDA_PATH/bin:$PATH"
    fi
fi
unset __conda_setup

if [[ $TMUX ]]; then
    conda deactivate
    conda activate base
fi

# -- MISC ---------------------------------------------------------------------

# eval "$(zoxide init zsh)"
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# -- FINAL --------------------------------------------------------------------

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
