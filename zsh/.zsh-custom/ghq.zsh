function mkp() {
  local ghq_root="$(ghq root)"

  # 1. 既存のオーナー/カテゴリから選択
  local parent=$(fd . "$ghq_root" --type d --min-depth 2 --max-depth 2 |
          sed "s|$ghq_root/||" |
          peco --prompt "location > ")
  [[ -z "$parent" ]] && return

  # 2. プロジェクト名を入力
  echo -n "project name: "
  local name; read -r name
  [[ -z "$name" ]] && return

  # 3. 作成
  local dir="$ghq_root/$parent/$name"

  if [[ -d "$dir" ]]; then
    echo "already exists: $dir"
    return 1
  fi

  mkdir -p "$dir"
  cd -- "$dir"
  git init
  git commit --allow-empty -m "initial commit"

  echo "created: $(pwd)"
}
