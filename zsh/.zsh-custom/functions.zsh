zmodload zsh/datetime

timed() {
  local start=$EPOCHREALTIME
  "$@"
  local end=$EPOCHREALTIME
  local elapsed=$(echo 'scale=3; ('"$end"' - '"$start"') * 1000' | bc)
  printf "Elapsed time: %.3f ms\n" "$elapsed"
}
