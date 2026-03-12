#!/usr/bin/env zsh
# Git commands — interactive wrappers with pretty output

__prithvi_git_status() {
  print ""
  __prithvi_info "${PRITHVI_BOLD}Git Status${PRITHVI_RESET}"
  print ""
  command git status --short 2>/dev/null | while IFS= read -r line; do
    local status_code="${line:0:2}"
    local file="${line:3}"
    case "$status_code" in
      "??") print "  ${PRITHVI_RED}●${PRITHVI_RESET} ${PRITHVI_DIM}untracked${PRITHVI_RESET}  $file" ;;
      " M") print "  ${PRITHVI_YELLOW}●${PRITHVI_RESET} ${PRITHVI_DIM}modified${PRITHVI_RESET}   $file" ;;
      "M ")  print "  ${PRITHVI_GREEN}●${PRITHVI_RESET} ${PRITHVI_DIM}staged${PRITHVI_RESET}     $file" ;;
      "MM") print "  ${PRITHVI_YELLOW}●${PRITHVI_RESET} ${PRITHVI_DIM}partial${PRITHVI_RESET}    $file" ;;
      "A ")  print "  ${PRITHVI_GREEN}●${PRITHVI_RESET} ${PRITHVI_DIM}added${PRITHVI_RESET}      $file" ;;
      " D") print "  ${PRITHVI_RED}●${PRITHVI_RESET} ${PRITHVI_DIM}deleted${PRITHVI_RESET}    $file" ;;
      "D ")  print "  ${PRITHVI_GREEN}●${PRITHVI_RESET} ${PRITHVI_DIM}deleted${PRITHVI_RESET}    $file" ;;
      "R ")  print "  ${PRITHVI_BLUE}●${PRITHVI_RESET} ${PRITHVI_DIM}renamed${PRITHVI_RESET}    $file" ;;
      *)    print "  ${PRITHVI_GRAY}●${PRITHVI_RESET} ${PRITHVI_DIM}${status_code}${PRITHVI_RESET}  $file" ;;
    esac
  done

  local count=$(command git status --short 2>/dev/null | wc -l | tr -d ' ')
  if [[ "$count" -eq 0 ]]; then
    __prithvi_success "Working tree is clean"
  else
    print ""
    __prithvi_info "${count} file(s) changed"
  fi
  print ""
}

__prithvi_git_save() {
  # Show what will be committed
  __prithvi_git_status

  __prithvi_ask "Commit message?"
  local msg
  read msg

  if [[ -z "$msg" ]]; then
    __prithvi_error "Commit message cannot be empty"
    return 1
  fi

  command git add -A
  command git commit -m "$msg"

  if [[ $? -eq 0 ]]; then
    __prithvi_success "Saved: ${PRITHVI_DIM}$msg${PRITHVI_RESET}"
  else
    __prithvi_error "Commit failed"
    return 1
  fi
}

__prithvi_git_push() {
  local branch=$(command git symbolic-ref --short HEAD 2>/dev/null)
  __prithvi_info "Pushing ${PRITHVI_PINK}$branch${PRITHVI_RESET} to remote..."
  command git push -u origin "$branch" 2>&1
  if [[ $? -eq 0 ]]; then
    __prithvi_success "Pushed to remote"
  else
    __prithvi_error "Push failed"
    return 1
  fi
}

__prithvi_git_pull() {
  __prithvi_info "Pulling from remote..."
  command git pull 2>&1
  if [[ $? -eq 0 ]]; then
    __prithvi_success "Up to date"
  else
    __prithvi_error "Pull failed"
    return 1
  fi
}

__prithvi_git_branch() {
  print ""
  __prithvi_info "${PRITHVI_BOLD}Branches${PRITHVI_RESET}"
  print ""
  command git branch --list 2>/dev/null | while IFS= read -r line; do
    if [[ "$line" == "* "* ]]; then
      print "  ${PRITHVI_GREEN}●${PRITHVI_RESET} ${PRITHVI_BOLD}${line:2}${PRITHVI_RESET} ${PRITHVI_DIM}(current)${PRITHVI_RESET}"
    else
      print "  ${PRITHVI_GRAY}○${PRITHVI_RESET} ${line:2}"
    fi
  done
  print ""
}

__prithvi_git_switch() {
  __prithvi_git_branch
  __prithvi_ask "Which branch?"
  local branch
  read branch

  if [[ -z "$branch" ]]; then
    __prithvi_error "No branch specified"
    return 1
  fi

  command git checkout "$branch" 2>&1
  if [[ $? -eq 0 ]]; then
    __prithvi_success "Switched to ${PRITHVI_PINK}$branch${PRITHVI_RESET}"
  else
    __prithvi_error "Could not switch to ${PRITHVI_DIM}$branch${PRITHVI_RESET}"
    return 1
  fi
}

__prithvi_git_new_branch() {
  __prithvi_ask "Branch name?"
  local name
  read name

  if [[ -z "$name" ]]; then
    __prithvi_error "Branch name cannot be empty"
    return 1
  fi

  command git checkout -b "$name" 2>&1
  if [[ $? -eq 0 ]]; then
    __prithvi_success "Created and switched to ${PRITHVI_PINK}$name${PRITHVI_RESET}"
  else
    __prithvi_error "Could not create branch ${PRITHVI_DIM}$name${PRITHVI_RESET}"
    return 1
  fi
}

__prithvi_git_log() {
  command git log --oneline --graph --decorate --color -20 2>/dev/null
}

__prithvi_git_undo() {
  local last_msg=$(command git log -1 --pretty=%s 2>/dev/null)
  __prithvi_warn "This will undo the last commit: ${PRITHVI_DIM}$last_msg${PRITHVI_RESET}"
  __prithvi_ask "Are you sure? (yes/no)"
  local confirm
  read confirm

  if [[ "$confirm" == "yes" || "$confirm" == "y" ]]; then
    command git reset --soft HEAD~1
    __prithvi_success "Undone. Changes are still staged."
  else
    __prithvi_info "Cancelled"
  fi
}

__prithvi_git_discard() {
  __prithvi_git_status
  __prithvi_warn "${PRITHVI_RED}This will discard ALL uncommitted changes.${PRITHVI_RESET}"
  __prithvi_ask "Discard all changes? (yes/no)"
  local confirm
  read confirm

  if [[ "$confirm" == "yes" || "$confirm" == "y" ]]; then
    command git checkout -- .
    command git clean -fd
    __prithvi_success "All changes discarded"
  else
    __prithvi_info "Cancelled"
  fi
}

__prithvi_git_stash() {
  command git stash push -m "prithvi-stash-$(date +%H:%M:%S)"
  if [[ $? -eq 0 ]]; then
    __prithvi_success "Changes stashed"
  else
    __prithvi_error "Nothing to stash"
  fi
}

__prithvi_git_unstash() {
  command git stash pop
  if [[ $? -eq 0 ]]; then
    __prithvi_success "Stashed changes restored"
  else
    __prithvi_error "No stash to restore"
  fi
}

__prithvi_git_diff() {
  command git diff --color 2>/dev/null
}
