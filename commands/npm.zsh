#!/usr/bin/env zsh
# npm command wrappers

__prithvi_npm_start() {
  __prithvi_info "Running ${PRITHVI_PINK}npm start${PRITHVI_RESET}..."
  command npm start
}

__prithvi_npm_dev() {
  __prithvi_info "Running ${PRITHVI_PINK}npm run dev${PRITHVI_RESET}..."
  command npm run dev
}

__prithvi_npm_build() {
  __prithvi_info "Running ${PRITHVI_PINK}npm run build${PRITHVI_RESET}..."
  command npm run build
}

__prithvi_npm_test() {
  __prithvi_info "Running ${PRITHVI_PINK}npm test${PRITHVI_RESET}..."
  command npm test
}

__prithvi_npm_install() {
  local pkg="${1// /}"
  if [[ -n "$pkg" ]]; then
    __prithvi_info "Installing ${PRITHVI_CYAN}$pkg${PRITHVI_RESET}..."
    command npm install "$pkg"
    if [[ $? -eq 0 ]]; then
      __prithvi_success "Installed ${PRITHVI_CYAN}$pkg${PRITHVI_RESET}"
    else
      __prithvi_error "Failed to install $pkg"
    fi
  else
    __prithvi_info "Installing dependencies..."
    command npm install
    if [[ $? -eq 0 ]]; then
      __prithvi_success "All dependencies installed"
    else
      __prithvi_error "Install failed"
    fi
  fi
}

__prithvi_npm_remove() {
  local pkg="$1"
  if [[ -z "$pkg" ]]; then
    __prithvi_ask "Which package?"
    read pkg
  fi

  __prithvi_info "Removing ${PRITHVI_CYAN}$pkg${PRITHVI_RESET}..."
  command npm uninstall "$pkg"
  if [[ $? -eq 0 ]]; then
    __prithvi_success "Removed ${PRITHVI_CYAN}$pkg${PRITHVI_RESET}"
  else
    __prithvi_error "Failed to remove $pkg"
  fi
}

__prithvi_npm_run() {
  local script="$1"
  if [[ -z "$script" ]]; then
    __prithvi_ask "Which script?"
    read script
  fi

  __prithvi_info "Running ${PRITHVI_PINK}npm run $script${PRITHVI_RESET}..."
  command npm run "$script"
}
