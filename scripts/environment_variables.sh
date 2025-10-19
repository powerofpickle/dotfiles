#!/bin/sh
script_dir="$(cd -- "$(dirname -- "$0")" && pwd -P)"
dotfiles_dir="$(dirname -- "$script_dir")"

cat << EOF
EDITOR=nvim
PYTHONSTARTUP="$dotfiles_dir/python/python_startup.py
EOF
