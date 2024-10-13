#!/bin/sh

config_file="/etc/flatpaks"

if [ "$#" -gt 0 ]; then
    config_file="$1"
fi

if [ ! -f "$config_file" ]; then
    echo "Error: Configuration file '$config_file' does not exist."
    exit 1
fi

flatpaks_config=$(< "$config_file")

apps=$(echo "$flatpaks_config" | awk 'NF && !/^#/{print $0}' | sort -u)

get_installed_apps() {
    flatpak list --app --columns=application | sort -u
}

install_flatpak() {
    flatpak install -y flathub "$1"
}

uninstall_flatpak() {
    flatpak uninstall -y "$1"
}

installed_apps=$(get_installed_apps)

apps_list=$(echo "$apps" | tr '\n' ' ')
installed_apps_list=$(echo "$installed_apps" | tr '\n' ' ')

to_install=$(echo "$apps_list" | tr ' ' '\n' | sort | uniq | grep -Fvxf <(echo "$installed_apps_list" | tr ' ' '\n') | tr '\n' ' ')
to_uninstall=$(echo "$installed_apps_list" | tr ' ' '\n' | sort | uniq | grep -Fvxf <(echo "$apps_list" | tr ' ' '\n') | tr '\n' ' ')

if [ -n "$to_install" ]; then
    read -p "Will install the following applications: $to_install. Press Enter to continue..."
    for app in $to_install; do
        echo "Installing $app"
        install_flatpak "$app"
    done
fi

if [ -n "$to_uninstall" ]; then
    read -p "Will uninstall the following applications: $to_uninstall. Press Enter to continue..."
    for app in $to_uninstall; do
        echo "Uninstalling $app"
        uninstall_flatpak "$app"
    done
fi

echo "Done"
