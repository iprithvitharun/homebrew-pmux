#!/usr/bin/env zsh
# Filesystem commands — human-friendly wrappers

__prithvi_goto() {
  local target="${1// /}"
  if [[ -z "$target" ]]; then
    __prithvi_ask "Where to?"
    read target
  fi

  if [[ -d "$target" ]]; then
    cd "$target"
    __prithvi_success "Now in ${PRITHVI_CYAN}$(basename "$PWD")${PRITHVI_RESET}"
  else
    __prithvi_error "Directory not found: ${PRITHVI_DIM}$target${PRITHVI_RESET}"
    return 1
  fi
}

__prithvi_goback() {
  cd ..
  __prithvi_success "Now in ${PRITHVI_CYAN}$(basename "$PWD")${PRITHVI_RESET}"
}

__prithvi_gohome() {
  cd ~
  __prithvi_success "Now in ${PRITHVI_CYAN}~${PRITHVI_RESET}"
}

__prithvi_showfiles() {
  local target="${1// /}"
  local dir="${target:-.}"
  local -a entries

  # Collect directory entries (dirs first, then files)
  local -a dirs files
  for f in "$dir"/*(N); do
    local name="${f:t}"
    if [[ -d "$f" ]]; then
      dirs+=("$name")
    else
      files+=("$name")
    fi
  done
  entries=("${dirs[@]}" "${files[@]}")

  if (( ${#entries} == 0 )); then
    __prithvi_info "Empty directory"
    return
  fi

  # Run interactive picker
  local selection
  selection=$(__prithvi_picker "${entries[@]}")
  local ret=$?

  if (( ret == 0 )) && [[ -n "$selection" ]]; then
    local full_path="${dir}/${selection}"
    if [[ -d "$full_path" ]]; then
      cd "$full_path"
      __prithvi_success "Now in ${PRITHVI_CYAN}$(basename "$PWD")${PRITHVI_RESET}"
    elif [[ -f "$full_path" ]]; then
      __prithvi_info "File: ${PRITHVI_CYAN}${selection}${PRITHVI_RESET} ($(wc -c < "$full_path" | tr -d ' ') bytes)"
    fi
  fi
}

__prithvi_open() {
  local file="$1"
  if [[ -z "$file" ]]; then
    __prithvi_ask "Which file?"
    read file
  fi

  if [[ -f "$file" ]]; then
    command cat "$file"
  elif [[ -d "$file" ]]; then
    __prithvi_info "That's a directory. Showing files instead:"
    __prithvi_showfiles "$file"
  else
    __prithvi_error "File not found: ${PRITHVI_DIM}$file${PRITHVI_RESET}"
    return 1
  fi
}

__prithvi_newfolder() {
  local name="$1"
  if [[ -z "$name" ]]; then
    __prithvi_ask "Folder name?"
    read name
  fi

  command mkdir -p "$name"
  __prithvi_success "Created folder ${PRITHVI_CYAN}$name${PRITHVI_RESET}"
}

__prithvi_newfile() {
  local name="$1"
  if [[ -z "$name" ]]; then
    __prithvi_ask "File name?"
    read name
  fi

  command touch "$name"
  __prithvi_success "Created file ${PRITHVI_CYAN}$name${PRITHVI_RESET}"
}

__prithvi_whereami() {
  __prithvi_info "${PRITHVI_CYAN}$PWD${PRITHVI_RESET}"
}
