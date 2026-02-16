# kill process by port
function killport() {
  kill -9 $(lsof -ti :$1)
}
alias kp="killport"

function zf() {
  local search_path=${1:-$HOME}

  local exclude_dirs="{.git,node_modules,target,dist,build,venv,.venv,.cache,.Trash,.docker,.gradle,.local,Application,Library,Music,Pictures,Movies}"
  local fd_opts=("--hidden" "--exclude" "$exclude_dirs")

  local selection
  selection=$(fd "${fd_opts[@]}" . "$search_path" | fzf)

  if [[ -z "$selection" ]]; then
    return
  fi

  if [[ -d "$selection" ]]; then
    z "$selection"
  elif [[ -f "$selection" ]]; then
    z "$(dirname "$selection")"
  fi
}
