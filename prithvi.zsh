#!/usr/bin/env zsh
# ╔══════════════════════════════════════════════════════╗
# ║  Prithvi CLI — A human-friendly shell for Ghostty   ║
# ╚══════════════════════════════════════════════════════╝

PRITHVI_DIR="${0:A:h}"

# ── Source all modules ──────────────────────────────────
source "$PRITHVI_DIR/lib/colors.zsh"
source "$PRITHVI_DIR/lib/prompt.zsh"
source "$PRITHVI_DIR/commands/filesystem.zsh"
source "$PRITHVI_DIR/commands/git.zsh"
source "$PRITHVI_DIR/commands/tabs.zsh"
source "$PRITHVI_DIR/commands/npm.zsh"
source "$PRITHVI_DIR/commands/claude.zsh"

# ── Command interception via accept-line widget ─────────
# Overrides the Enter key handler. If the typed command matches
# a custom command, we run it directly (in the current shell)
# and reset the buffer. Otherwise, we let zsh execute normally.
__prithvi_accept_line() {
  local cmd="$BUFFER"

  case "$cmd" in
    "go to "*)     BUFFER=""; zle accept-line; __prithvi_goto "${cmd#go to }" ;;
    "go back")     BUFFER=""; zle accept-line; __prithvi_goback ;;
    "go home")     BUFFER=""; zle accept-line; __prithvi_gohome ;;
    "show files"*) BUFFER=""; zle accept-line; __prithvi_showfiles "${cmd#show files}" ;;
    "open "*)      BUFFER=""; zle accept-line; __prithvi_open "${cmd#open }" ;;
    "new folder "*)BUFFER=""; zle accept-line; __prithvi_newfolder "${cmd#new folder }" ;;
    "new file "*)  BUFFER=""; zle accept-line; __prithvi_newfile "${cmd#new file }" ;;
    "where am i")  BUFFER=""; zle accept-line; __prithvi_whereami ;;

    "git status")     BUFFER=""; zle accept-line; __prithvi_git_status ;;
    "git save")       BUFFER=""; zle accept-line; __prithvi_git_save ;;
    "git push")       BUFFER=""; zle accept-line; __prithvi_git_push ;;
    "git pull")       BUFFER=""; zle accept-line; __prithvi_git_pull ;;
    "git branch")     BUFFER=""; zle accept-line; __prithvi_git_branch ;;
    "git switch")     BUFFER=""; zle accept-line; __prithvi_git_switch ;;
    "git new branch") BUFFER=""; zle accept-line; __prithvi_git_new_branch ;;
    "git log")        BUFFER=""; zle accept-line; __prithvi_git_log ;;
    "git undo")       BUFFER=""; zle accept-line; __prithvi_git_undo ;;
    "git discard")    BUFFER=""; zle accept-line; __prithvi_git_discard ;;
    "git stash")      BUFFER=""; zle accept-line; __prithvi_git_stash ;;
    "git unstash")    BUFFER=""; zle accept-line; __prithvi_git_unstash ;;
    "git diff")       BUFFER=""; zle accept-line; __prithvi_git_diff ;;

    "tab new"*)    BUFFER=""; zle accept-line; __prithvi_tab_new "${cmd#tab new}" ;;
    "tab split"*)  BUFFER=""; zle accept-line; __prithvi_tab_split "${cmd#tab split}" ;;
    "tab rename "*)BUFFER=""; zle accept-line; __prithvi_tab_rename "${cmd#tab rename }" ;;
    "tab list")    BUFFER=""; zle accept-line; __prithvi_tab_list ;;
    "tab close")   BUFFER=""; zle accept-line; __prithvi_tab_close ;;

    "npm start")   BUFFER=""; zle accept-line; __prithvi_npm_start ;;
    "npm dev")     BUFFER=""; zle accept-line; __prithvi_npm_dev ;;
    "npm build")   BUFFER=""; zle accept-line; __prithvi_npm_build ;;
    "npm test")    BUFFER=""; zle accept-line; __prithvi_npm_test ;;
    "npm install"*)BUFFER=""; zle accept-line; __prithvi_npm_install "${cmd#npm install}" ;;
    "npm remove "*)BUFFER=""; zle accept-line; __prithvi_npm_remove "${cmd#npm remove }" ;;
    "npm run "*)   BUFFER=""; zle accept-line; __prithvi_npm_run "${cmd#npm run }" ;;

    "claude"*)     BUFFER=""; zle accept-line; __prithvi_claude "${cmd#claude}" ;;

    "help"|"commands") BUFFER=""; zle accept-line; __prithvi_help ;;

    *)
      # Not a custom command — let zsh handle it normally
      zle .accept-line
      ;;
  esac
}

zle -N accept-line __prithvi_accept_line

# ── Help system ─────────────────────────────────────────
__prithvi_help() {
  print ""
  print "${PRITHVI_BOLD}${PRITHVI_CYAN}  Prithvi CLI${PRITHVI_RESET} — Human-friendly commands for your terminal"
  print ""
  print "  ${PRITHVI_DIM}────────────────────────────────────────────${PRITHVI_RESET}"
  print ""
  print "  ${PRITHVI_BOLD}Filesystem${PRITHVI_RESET}"
  print "  ${PRITHVI_PINK}go to${PRITHVI_RESET} <folder>        cd into a directory"
  print "  ${PRITHVI_PINK}go back${PRITHVI_RESET}               cd .."
  print "  ${PRITHVI_PINK}go home${PRITHVI_RESET}               cd ~"
  print "  ${PRITHVI_PINK}show files${PRITHVI_RESET} [path]     ls (with optional path)"
  print "  ${PRITHVI_PINK}open${PRITHVI_RESET} <file>           cat a file"
  print "  ${PRITHVI_PINK}new folder${PRITHVI_RESET} <name>     mkdir"
  print "  ${PRITHVI_PINK}new file${PRITHVI_RESET} <name>       touch"
  print "  ${PRITHVI_PINK}where am i${PRITHVI_RESET}            pwd"
  print ""
  print "  ${PRITHVI_BOLD}Git${PRITHVI_RESET}"
  print "  ${PRITHVI_PINK}git status${PRITHVI_RESET}            working tree status"
  print "  ${PRITHVI_PINK}git save${PRITHVI_RESET}              stage all + commit (asks message)"
  print "  ${PRITHVI_PINK}git push${PRITHVI_RESET}              push to remote"
  print "  ${PRITHVI_PINK}git pull${PRITHVI_RESET}              pull from remote"
  print "  ${PRITHVI_PINK}git branch${PRITHVI_RESET}            list branches"
  print "  ${PRITHVI_PINK}git switch${PRITHVI_RESET}            switch branch (asks which)"
  print "  ${PRITHVI_PINK}git new branch${PRITHVI_RESET}        create + switch (asks name)"
  print "  ${PRITHVI_PINK}git log${PRITHVI_RESET}               pretty commit history"
  print "  ${PRITHVI_PINK}git undo${PRITHVI_RESET}              undo last commit (asks confirm)"
  print "  ${PRITHVI_PINK}git discard${PRITHVI_RESET}           discard all changes (asks confirm)"
  print "  ${PRITHVI_PINK}git stash${PRITHVI_RESET}             stash changes"
  print "  ${PRITHVI_PINK}git unstash${PRITHVI_RESET}           restore stashed changes"
  print "  ${PRITHVI_PINK}git diff${PRITHVI_RESET}              show unstaged changes"
  print ""
  print "  ${PRITHVI_BOLD}Tabs${PRITHVI_RESET}"
  print "  ${PRITHVI_PINK}tab new${PRITHVI_RESET} [name]        open a new tab"
  print "  ${PRITHVI_PINK}tab split${PRITHVI_RESET} [dir]       split pane (right/down)"
  print "  ${PRITHVI_PINK}tab rename${PRITHVI_RESET} <name>     rename current tab"
  print "  ${PRITHVI_PINK}tab close${PRITHVI_RESET}             close current tab"
  print ""
  print "  ${PRITHVI_BOLD}npm${PRITHVI_RESET}"
  print "  ${PRITHVI_PINK}npm dev${PRITHVI_RESET}               npm run dev"
  print "  ${PRITHVI_PINK}npm build${PRITHVI_RESET}             npm run build"
  print "  ${PRITHVI_PINK}npm install${PRITHVI_RESET} [pkg]     install packages"
  print "  ${PRITHVI_PINK}npm remove${PRITHVI_RESET} <pkg>      uninstall a package"
  print ""
  print "  ${PRITHVI_BOLD}Claude${PRITHVI_RESET}"
  print "  ${PRITHVI_PINK}claude${PRITHVI_RESET}                launch Claude Code"
  print "  ${PRITHVI_PINK}claude${PRITHVI_RESET} <prompt>       ask Claude a question"
  print ""
  print "  ${PRITHVI_DIM}All native commands (cd, ls, git, etc.) still work normally.${PRITHVI_RESET}"
  print ""
}

# ── Welcome message (only in standalone mode, not inside Prithvi Terminal app) ──
if [[ -z "$PRITHVI_TERMINAL" ]]; then
  print ""
  print "  ${PRITHVI_BOLD}${PRITHVI_CYAN}Prithvi CLI${PRITHVI_RESET} ${PRITHVI_DIM}v0.1.0${PRITHVI_RESET} — type ${PRITHVI_PINK}help${PRITHVI_RESET} for commands"
  print ""
fi
