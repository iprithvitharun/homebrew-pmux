#!/usr/bin/env zsh
# Claude Code integration

__prithvi_claude() {
  local prompt="${1// /}"

  # Check if Claude Code is installed
  if ! command -v claude &>/dev/null; then
    __prithvi_error "Claude Code is not installed"
    __prithvi_info "Install it with: ${PRITHVI_PINK}npm install -g @anthropic-ai/claude-code${PRITHVI_RESET}"
    return 1
  fi

  if [[ -z "$prompt" ]]; then
    # Launch interactive Claude Code
    __prithvi_info "Launching ${PRITHVI_PINK}Claude Code${PRITHVI_RESET}..."
    command claude
  else
    # Pass prompt directly
    command claude "$prompt"
  fi
}
