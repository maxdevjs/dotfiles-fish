# pure prompt settings
set -g async_prompt_functions _pure_prompt_git

function fish_right_prompt_loading_indicator
    echo (set_color '#aaa')' … '(set_color normal)
end

# universal variable are stored in $HOME/.config/fish/fish_variables

function set_universal_nvm_default_version
    #Ex.: set --universal nvm_default_version v18.9.0
    set --universal nvm_default_version $argv
    # Packages to install every change of version
    #Ex.: set --universal nvm_default_packages neovim typescript yarn
end

# Question: Make nvm use usable for my own auto-switching? #186
# https://github.com/jorgebucaran/nvm.fish/pull/186
# Node is unavailable in new shells #196
# https://github.com/jorgebucaran/nvm.fish/issues/196
function __nvm_auto --on-variable PWD
    nvm use --silent 2>/dev/null
end
__nvm_auto

#if status is-interactive && ! set --query nvm_default_version
#	nvm use --silent $nvm_default_version
#end

abbr -a c clear
abbr -a flutter-run 'docker run --rm -e UID=$(id -u) -e GID=$(id -g) --workdir /project -v "$PWD":/project --device /dev/bus/usb matspfeiffer/flutter:beta run'
abbr -a flutter-run-emulator 'xhost local:$USER && docker run --rm -ti -e UID=(id -u) -e GID=(id -g) -p 42000:42000 --workdir /project --device /dev/kvm --device /dev/dri:/dev/dri -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY -v "$PWD":/project --entrypoint flutter-android-emulator  matspfeiffer/flutter:beta'
# https://github.com/fish-shell/fish-shell/issues/3907
abbr -a yd 'youtube-dl ""'


if type -q n exa
    #alias la="exa -la"
    alias la="li -a"
    alias li="exa -l -g --icons"
    alias lg="exa --git -l"
    alias lt="exa --tree -D -L 3"
end

# vi mode
fish_vi_key_bindings

# Set the cursor shapes for the different vi modes.
set fish_cursor_default block blink
set fish_cursor_insert line blink
set fish_cursor_replace_one underscore blink
set fish_cursor_visual block


# Miscellaneous
alias ks="$XDG_CONFIG_HOME/kitty/sessions/kitty-startup"
alias rmfi='complete -C | fzf | xargs | cut -d " " -f 1 | xargs man' # read manual for item

### Dev

# TODO: does not return the /package.json
#alias pnm='fd -H "node_modules" --type directory | xargs du -sh | sort -hr | fzf -m --header "Select what you wish to delete" --preview "cat $(dirname {})/package.json" | awk "{print $2}" | xargs -r rm -rf'
#alias pnm='fd -g "node_modules" --type directory 2>/dev/null | xargs du -sh 2>/dev/null | sort -hr | fzf -m --header "Select what you wish to delete" --preview "cat $(dirname {})/package.json" | awk "{print $2}"'
#alias purge-node-modules=pnm

# Docker

# Kubernetes
alias kgpd='kubectl get pods -A --no-headers | fzf | awk \'{print $2, $1}\' | xargs -n 2 sh -c \'kubectl describe pod $0 -n $1\''

# System
alias :e="exit"
alias ee=:e
alias :q=:e

# Kitty
# Reset padding/margin to 0 when opening nvim
# TODO: search for fish hook to use in all applications
# ANSWER: does not exist
#alias kmp0='kitty @ set-spacing padding=0 margin=0'
alias kmp0='kitten @ set-spacing padding=20 margin=10; kitten @ set-font-size 0'
# Reset padding/margin to config values when closing nvim
# TODO: store/retrieve from...?
alias kmpV='kitty @ set-spacing padding=20 margin=10'

# [e]dit[i]n[n]vim
# https://github.com/junegunn/fzf#turning-into-a-different-process
# https://github.com/junegunn/fzf#preview-window
#alias ein='fd -t f -p -a -H | fzf --bind "enter:become(n {})"'
#alias fzfeinp='fd -t f -p -a -H | fzf --preview "bat {}" --header " 📝 Edit file in nvim" --bind "enter:become(n {})"'
alias fzfein='fd -t f -p -a -H | fzf --height=60% --preview "bat --color=always {}" --preview-window "~3" --bind "enter:become(n {})" --header " 📝 Edit file in nvim"'

# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#introduction
alias fzfkp='ps -ef | fzf-tmux -p 80%,80% --header "☠️ Kill a process" | awk "{print $2}" | xargs kill -9 '

alias irssi='irssi --home=$XDG_CONFIG_HOME/irssi/ --config=$XDG_CONFIG_HOME/irssi/config'

# https://www.inmotionhosting.com/support/server/linux/send-files-to-trash-with-gio-trash/
alias 2048='kitty +kitten themes --reload-in=parent Catppuccin-Mocha; 2048-in-terminal'
alias spf='kitten @ set-font-size 16; superfile'
alias trash='gio trash'

# bat
if type -q bat
    alias cat=bat
end

if type -q rga
    alias rg=rga
end

# nvim 🦾
if type -q nvim
    set -gx EDITOR 'nvim -u NONE'
    set -gx VISUAL nvim
    set -gx MANPAGER "nvim +Man!"

    # Padding 0
    alias n='kmp0 && nvim '
    #alias n='nvim '
    #alias nl='nvim -u ~/.config/nvim/init.lua '
    alias vimdiff="n -d"
    # FIX: $XDG_CONFIG_HOME # https://www.reddit.com/r/fishshell/comments/r1r3cn/comment/hm1jqsk/
    alias ecf="n $XDG_CONFIG_HOME/fish/config.fish"
    alias ecn="n $XDG_CONFIG_HOME/nvim/init.lua"
    #alias ncx="n $HOME/System/nixos-config/"
end

set -gx FZF_DEFAULT_OPTS "--height=60% --layout=reverse --info=inline --border --margin=1 --padding=1"
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --follow -g \"!.git/\" 2> /dev/null"
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

set -gx XDG_CONFIG_HOME "$HOME/.config"

# https://github.com/haslersn/any-nix-shell
#any-nix-shell fish --info-right | source

# http://fishshell.com/docs/current/index.html#initialization
# https://stackoverflow.com/questions/26208231/modifying-path-with-fish-shell
# https://fishshell.com/docs/current/tutorial.html#path
# https://fishshell.com/docs/current/tutorial.html#path-example
# https://fishshell.com/docs/current/cmds/fish_add_path.html

#set DENO_INSTALL "/home/maxdevjs/.deno"
#set -x PATH $HOME/.guix-profile/bin $HOME/.local/bin $DENO_INSTALL/bin $HOME/.cargo/bin $PATH

set GOPATH "$HOME/go"
set GOBIN $GOPATH/bin
set GOMODCACHE $GOPATH/pkg/mod
set -x PATH $GOPATH $GOBIN $GOMODCACHE $HOME/.local/bin $HOME/.local/scripts $PATH

# https://github.com/jarun/nnn/tree/master/plugins#configuration
#"NNN_FIFO=/tmp/nnn.fifo NNN_PLUG='p:preview-tui' nnn "
set -gx NNN_FIFO /tmp/nnn.fifo

# https://github.com/jarun/nnn/tree/master/plugins#skip-user-confirmation-after-command-execution-
# https://github.com/jarun/nnn/tree/master/plugins#page-non-interactive-command-output-
set NNN_PLUG_COM 't:-!|tree -ps;l:-!|ls -lah --group-directories-first'
set -gx NNN_COLORS 1234 '#0a1b2c3d''#0a1b2c3d;1234'
set NNN_PLUG_DEV 'g:-!git diff*;l:-!git log*;o:!dev-git-open-repo-in-browser*'
set NNN_PLUG_MEDIA 'm:-!|mediainfo $nnn;w:!&mpv $nnn*'
set NNN_PLUG_NNN 'p:preview-tui;u:nmount'
set -gx NNN_PLUG "$NNN_PLUG_DEV;$NNN_PLUG_MEDIA;$NNN_PLUG_NNN"
alias nnn="nnn -i -o -U"

# https://github.com/Olical/dotfiles/blob/master/stowed/.config/fish/config.fish
if type -q direnv
    #   eval (direnv hook fish)
    direnv hook fish | source
end

# TODO: https://github.com/folke/tokyonight.nvim/blob/main/extras/fish_tokyonight_night.fish

# https://github.com/oh-my-fish/oh-my-fish/blob/master/pkg/omf/functions/themes/omf.theme.set.fish
# https://github.com/oh-my-fish/oh-my-fish/blob/master/pkg/omf/functions/cli/omf.cli.theme.fish
# https://github.com/oh-my-fish/oh-my-fish/blob/master/pkg/omf/functions/themes/omf.theme.set.fish
# https://github.com/pure-fish/pure#-colours
# https://fishshell.com/docs/current/cmds/set_color.html
# source $XDG_CONFIG_HOME/fish/themes/fish_tokyonight_storm.fish

# TODO: port https://github.com/mvllow/dots/blob/main/guides/update-kitty-config-from-neovim.md






#set DISTRO (lsb_release -a) > /dev/null 2>&1;

#if string match -r 'Solus' $DISTRO
#  echo sooooolus
#end

# Guix
# Temporary workaround to access binaries
# until I do not get it (refer to `how to use guix in fish shell` search)
#set -x GUIX_PROFILE /home/maxdevjs/.guix-profile/bin
#set -x PATH $HOME/Me/system/bin $HOME/.local/bin $HOME/Dev/.node_modules/bin $GUIX_PROFILE $PATH
#source $GUIX_PROFILE/etc/profile

# Nix
# $HOME/.profile
#set NIX_LINK $HOME/.nix-profile # 🤔
# https://github.com/lilyball/nix-env.fish

# error: experimental Nix feature 'nix-command' is disabled; use '--extra-experimental-features nix-command' to override
alias nix='nix --extra-experimental-features nix-command --extra-experimental-features flakes '

set -gx NIXPKGS_ALLOW_UNFREE 1
