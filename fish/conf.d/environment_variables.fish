set script_path (realpath (status --current-filename))
set dotfiles_dir (dirname (dirname (dirname "$script_path")))

set -x EDITOR nvim
set -x PYTHONSTARTUP "$dotfiles_dir/python/python_startup.py"
