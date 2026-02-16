for f in ~/.config/zsh/*.zsh; do
  [[ "$f" != */init.zsh ]] && source "$f"
done
