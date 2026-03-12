#!/usr/bin/env zsh
# Color and formatting constants
# Using $'...' syntax so \033 is interpreted as a real escape character.

PRITHVI_RESET=$'\033[0m'
PRITHVI_BOLD=$'\033[1m'
PRITHVI_DIM=$'\033[2m'
PRITHVI_ITALIC=$'\033[3m'

# Colors
PRITHVI_RED=$'\033[38;5;203m'
PRITHVI_GREEN=$'\033[38;5;114m'
PRITHVI_YELLOW=$'\033[38;5;221m'
PRITHVI_BLUE=$'\033[38;5;111m'
PRITHVI_PINK=$'\033[38;5;210m'
PRITHVI_CYAN=$'\033[38;5;117m'
PRITHVI_GRAY=$'\033[38;5;243m'
PRITHVI_WHITE=$'\033[38;5;255m'

# Utility print functions
__prithvi_success() { print "  ${PRITHVI_GREEN}✓${PRITHVI_RESET} $1" }
__prithvi_error()   { print "  ${PRITHVI_RED}✗${PRITHVI_RESET} $1" }
__prithvi_info()    { print "  ${PRITHVI_BLUE}→${PRITHVI_RESET} $1" }
__prithvi_warn()    { print "  ${PRITHVI_YELLOW}!${PRITHVI_RESET} $1" }
__prithvi_ask()     { print -n "  ${PRITHVI_PINK}?${PRITHVI_RESET} $1 " }
