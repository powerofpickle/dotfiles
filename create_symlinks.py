#!/usr/bin/env python3

from pathlib import Path

mappings = {
    "nvim/init.lua":                    "~/.config/nvim/init.lua",
    "nvim/lua/config":                  "~/.config/nvim/lua/config",
    "vim/vimrc":                        "~/.config/vim/vimrc",
    "vim/config":                       "~/.config/vim/config",
    "fish/themes":                      "~/.config/fish/themes",
    "fish/conf.d":                      "~/.config/fish/conf.d",
    "sway":                             "~/.config/sway",
    "waybar":                           "~/.config/waybar",
    "tmux.conf":                        "~/.config/tmux/tmux.conf",
    "alacritty":                        "~/.config/alacritty",
    "overrides":                        "~/.local/share/flatpak/overrides",
    "mimeapps.list":                    "~/.config/mimeapps.list",
    "python/pdbrc":                     "~/.pdbrc",
}

dotfiles_dir = Path(__file__).parent

for source, target in mappings.items():
    source_path = dotfiles_dir / Path(source)
    target_path = Path(target).expanduser()

    if target_path.exists():
        continue

    parent_directory = target_path.parent

    if not parent_directory.exists():
        parent_directory.mkdir(parents=True, exist_ok=True)

    target_path.symlink_to(source_path)

