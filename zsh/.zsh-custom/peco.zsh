# history
function peco-history-selection() {
  BUFFER=`history -n 1 | tail -r | awk '!a[$0]++' | peco`
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

# cdr
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':completion:*' recent-dirs-insert both
  zstyle ':chpwd:*' recent-dirs-default true
  zstyle ':chpwd:*' recent-dirs-max 1000
  zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

function peco-cdr () {
  local selected_dir="$(cdr -l | sed -E 's/^[0-9]+ *//' | peco --prompt="cdr >" --query "$LBUFFER")"
  if [[ -n "$selected_dir" ]]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N peco-cdr
bindkey '^E' peco-cdr

# git worktree
function peco-git-worktree () {
  local git_dir=$(git rev-parse --git-dir 2>/dev/null)
  if [[ -z "$git_dir" ]]; then
    zle -M "not a git repository"
    return 0
  fi

  local selected="$(git worktree list --porcelain 2>/dev/null \
    | awk '
      /^worktree / {
        # 前のエントリを出力
        if (w != "") {
          printf "%s [%s]\t%s\n", (b != "" ? b : "(unknown)"), (h != "" ? h : "-------"), w
        }
        w = substr($0, 10)
        b = ""
        h = ""
      }
      /^HEAD / { h = substr($2, 1, 7) }
      /^branch / { b = $2; sub(/^refs\/heads\//, "", b) }
      /^detached/ { b = "(detached)" }
      END {
        if (w != "") {
          printf "%s [%s]\t%s\n", (b != "" ? b : "(unknown)"), (h != "" ? h : "-------"), w
        }
      }
    ' \
    | peco --prompt="worktree >" --query "$LBUFFER")"

  if [[ -n "$selected" ]]; then
    local selected_dir="${selected#*$'\t'}"
    BUFFER="cd -- ${(q)selected_dir}"
    zle accept-line
  fi
  zle redisplay
}
zle -N peco-git-worktree
bindkey '^w' peco-git-worktree

# ghq source
function peco-src() {
  local ghq_root="$(ghq root)"
  local selected=$(fd . "$ghq_root" --type d --min-depth 3 --max-depth 3 \
          --exclude 'worktrees' |
          sed "s|$ghq_root/||" |
          peco --query "$LBUFFER")
  if [[ -n "$selected" ]]; then
    BUFFER="cd -- \"$ghq_root/$selected\""
    zle accept-line
  fi
  zle redisplay
}
zle -N peco-src
bindkey '^G' peco-src

# ghq parent directory
function peco-src-parent() {
  local ghq_root="$(ghq root)"
  local selected=$(fd . "$ghq_root" --type d --min-depth 2 --max-depth 2 |
          sed "s|$ghq_root/||" |
          peco --query "$LBUFFER")
  if [[ -n "$selected" ]]; then
    BUFFER="cd -- \"$ghq_root/$selected\""
    zle accept-line
  fi
  zle redisplay
}
zle -N peco-src-parent
bindkey '^T' peco-src-parent
