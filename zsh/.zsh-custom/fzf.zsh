# fzf defaults (can be overridden in ~/.zshrc.local)
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:-} --height=40% --reverse --border"

# history
function fzf-history-selection() {
  local selected
  selected="$(history -n 1 | tail -r | awk '!a[$0]++' | fzf --scheme=history --prompt="history > " --query "$LBUFFER")"
  if [[ -n "$selected" ]]; then
    BUFFER="$selected"
  fi
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N fzf-history-selection
bindkey '^R' fzf-history-selection

# cdr
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':completion:*' recent-dirs-insert both
  zstyle ':chpwd:*' recent-dirs-default true
  zstyle ':chpwd:*' recent-dirs-max 1000
  zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

function fzf-cdr () {
  local selected_dir="$(cdr -l | sed -E 's/^[0-9]+ *//' | fzf --prompt="cdr > " --query "$LBUFFER")"
  if [[ -n "$selected_dir" ]]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
}
zle -N fzf-cdr
bindkey '^E' fzf-cdr

# git worktree
function fzf-git-worktree () {
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
    | fzf --prompt="worktree > " --query "$LBUFFER" --delimiter='\t' --with-nth=1)"

  if [[ -n "$selected" ]]; then
    local selected_dir="${selected#*$'\t'}"
    BUFFER="cd -- ${(q)selected_dir}"
    zle accept-line
  fi
  zle redisplay
}
zle -N fzf-git-worktree
bindkey '^w' fzf-git-worktree

# ghq source
function fzf-src() {
  local ghq_root="$(ghq root)"
  local selected=$(fd . "$ghq_root" --type d --min-depth 3 --max-depth 3 \
          --exclude 'worktrees' |
          sed "s|$ghq_root/||" |
          fzf --prompt="ghq > " --query "$LBUFFER")
  if [[ -n "$selected" ]]; then
    BUFFER="cd -- \"$ghq_root/$selected\""
    zle accept-line
  fi
  zle redisplay
}
zle -N fzf-src
bindkey '^G' fzf-src

# ghq parent directory
function fzf-src-parent() {
  local ghq_root="$(ghq root)"
  local selected=$(fd . "$ghq_root" --type d --min-depth 2 --max-depth 2 |
          sed "s|$ghq_root/||" |
          fzf --prompt="ghq-parent > " --query "$LBUFFER")
  if [[ -n "$selected" ]]; then
    BUFFER="cd -- \"$ghq_root/$selected\""
    zle accept-line
  fi
  zle redisplay
}
zle -N fzf-src-parent
bindkey '^T' fzf-src-parent
