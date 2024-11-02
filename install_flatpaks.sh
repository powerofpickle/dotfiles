#!/bin/sh

get_installed_apps() {
    flatpak list --app --columns=application | sort -u
}

install_flatpak() {
    flatpak install -y flathub "$1"
}

uninstall_flatpak() {
    flatpak uninstall -y "$1"
}

subtract_set() {
    # Returns elements that are in $1 and not in $2
    pattern_file=$(mktemp)
    printf "%s" "$2" > "$pattern_file"
    printf "%s" "$1" | grep -Fvxf "$pattern_file"
    rm -f "$pattern_file"
}

format_list() {
    printf "%s" "$1" | sed 's/^/ - /'
}

main() {
    config_file="/etc/flatpaks"

    if [ "$#" -gt 0 ]; then
        config_file="$1"
    fi

    if [ ! -f "$config_file" ]; then
        printf "Error: Configuration file '%s' does not exist.\n" "$config_file"
        exit 1
    fi

    flatpaks_config=$(cat "$config_file")

    apps=$(printf "%s" "$flatpaks_config" | awk 'NF && !/^#/{print $0}' | sort -u)
    installed_apps=$(get_installed_apps)

    to_install=$(subtract_set "$apps" "$installed_apps")
    to_uninstall=$(subtract_set "$installed_apps" "$apps")

    if [ -n "$to_install" ]; then
        printf "Will install the following applications:\n%s\n\nPress Enter to continue" "$(format_list "$to_install")"
        read -r _
        for app in $to_install; do
            printf "Installing %s\n" "$app"
            install_flatpak "$app"
        done
    fi

    if [ -n "$to_uninstall" ]; then
        printf "Will uninstall the following applications:\n%s\n\nPress Enter to continue" "$(format_list "$to_uninstall")"
        read -r _
        for app in $to_uninstall; do
            printf "Uninstalling %s\n" "$app"
            uninstall_flatpak "$app"
        done
    fi

    printf "Done\n"
}

main "$@"
