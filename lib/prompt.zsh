#!/usr/bin/env zsh
# Clean, minimal prompt: directory + git branch

__prithvi_git_prompt() {
  local branch
  branch=$(command git symbolic-ref --short HEAD 2>/dev/null) || return
  echo " %{$PRITHVI_PINK%}$branch%{$PRITHVI_RESET%}"
}

setopt PROMPT_SUBST
PROMPT=' %{$PRITHVI_CYAN%}%~%{$PRITHVI_RESET%}$(__prithvi_git_prompt) %{$PRITHVI_PINK%}❯%{$PRITHVI_RESET%} '
