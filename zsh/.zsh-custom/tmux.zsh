# カレントディレクトリで tmux セッションを開始/再開
# 新規セッション時は nvim（左）+ claude code（右）のレイアウトで起動
function tm() {
  local session_name=$(basename "$(pwd)" | tr '.' '_')
  local dir="$(pwd)"

  if tmux has-session -t="$session_name" 2>/dev/null; then
    if [[ -z "${TMUX:-}" ]]; then
      tmux attach-session -t "$session_name"
    else
      tmux switch-client -t "$session_name"
    fi
  else
    # セッション作成 + dev レイアウト
    tmux new-session -ds "$session_name" -c "$dir"
    tmux split-window -h -l 50% -t "$session_name" -c "$dir"
    tmux send-keys -t "${session_name}:1.1" "nvim" Enter
    tmux send-keys -t "${session_name}:1.2" "claude" Enter
    tmux select-pane -t "${session_name}:1.1"

    if [[ -z "${TMUX:-}" ]]; then
      tmux attach-session -t "$session_name"
    else
      tmux switch-client -t "$session_name"
    fi
  fi
}

# TODO: 将来的に peco で既存セッション一覧から選択する機能を追加
# function tms() {
#   local selected=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | peco)
#   ...
# }
