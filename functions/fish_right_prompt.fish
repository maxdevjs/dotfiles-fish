# https://github.com/reitzig/theme-dmorrell/blob/master/fish_right_prompt.fish

set -g __git_icon_branch   '🜉'
set -g __git_icon_tag      '⌂'
set -g __git_icon_commit   '⌀'

set -g __git_icon_diverged '⭿'
set -g __git_icon_ahead    '⭱'
set -g __git_icon_behind   '⭳'

set -g __git_icon_added     "+ "
set -g __git_icon_dirty     "⚹ "
set -g __git_icon_changed   "↺ "
set -g __git_icon_removed   "🗴"
set -g __git_icon_stashed   "≡ "
set -g __git_icon_untracked "? "

function get_git_status -d "Gets the current git status"
  if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
    set -l dirty (command git status -s --ignore-submodules=dirty | wc -l | sed -e 's/^ *//' -e 's/ *$//' 2> /dev/null)
    set -l added (command git status --porcelain=v1 --ignore-submodules=dirty \
                | grep -e '^ \?A' | wc -l)
    set -l del (command git status --porcelain=v1 --ignore-submodules=dirty \
                | grep -e '^ \?D' | wc -l)
    set -l mod (command git status --porcelain=v1 --ignore-submodules=dirty \
                | grep -e '^ \?\(M\|R\)' | wc -l)
    set -l short (command git rev-parse --short HEAD)
    set -l stashed (command git stash list --no-decorate \
                | wc -l)
    set -l untracked (command git status --porcelain=v1 --ignore-submodules=dirty \
                | grep -e '^ \?\(?\)' | wc -l)
    set -l ref (command git describe --tags --exact-match 2> /dev/null ; or command git symbolic-ref --short HEAD 2> /dev/null ; or command git rev-parse --short HEAD 2> /dev/null)
    
    if [ "$dirty" != "0" ]
      set_color -b normal
      set_color $pure_color_warning
#       set_color $pure_color_danger
      echo "$dirty$__git_icon_dirty"
      
      if [ "$added" != "0" ]
        echo "$mod $__git_icon_added"
      end
  
      if [ "$del" != "0" ]
        echo "$del $__git_icon_removed"
      end
        
      if [ "$mod" != "0" ]
        echo "$mod$__git_icon_changed"
      end
      
      if [ "$stashed" != "0" ]
      echo "$stashed$__git_icon_stashed"
      end
      
      if [ "$untracked" != "0" ]
        echo "$untracked$__git_icon_untracked"
      end
      echo "$short "
      else
      set_color $pure_color_mute
      echo "$short "
      #echo " $ref "
    end
  end
  set_color normal
end

#TODO: fix it
# https://nixos.wiki/wiki/Fish
function nix_shell_info -d "Gets nix-shell status"
  set -l ns (test -n "$IN_NIX_SHELL")
  if [ ns  != "" ]
    set_color $pure_color_warning
    echo "<nix-shell> "
    set_color normal
  end
end

function fish_right_prompt -d "Prints right prompt"
  get_git_status
end
