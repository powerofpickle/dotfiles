#!/usr/bin/env python3

import subprocess

apps = {
    'net.cozic.joplin_desktop',
    'io.gitlab.librewolf-community',
    'org.libreoffice.LibreOffice',
    'org.signal.Signal',
    'com.obsproject.Studio',
    'org.gimp.GIMP',
    'com.github.tchx84.Flatseal',
    'com.github.Eloston.UngoogledChromium',
    'com.google.AndroidStudio',
    'com.nextcloud.desktopclient.nextcloud',
    'org.gnome.seahorse.Application',
    'org.inkscape.Inkscape',
    'org.deluge_torrent.deluge',
    'com.vscodium.codium',

    # Games
    'org.xonotic.Xonotic',
    'net.veloren.airshipper',
    'org.DolphinEmu.dolphin-emu',
    'net.minetest.Minetest',
    'org.prismlauncher.PrismLauncher',
}

def run(cmd):
    return subprocess.check_output(cmd.split()).decode()

def get_installed_apps():
    return set(run('flatpak list --app --columns=application').splitlines())

def install_flatpak(app):
    run(f'flatpak install -y flathub {app}')

def uninstall_flatpak(app):
    run(f'flatpak uninstall -y {app}')

installed_apps = get_installed_apps()

to_install = apps - installed_apps
to_uninstall = installed_apps - apps

if to_install:
    input(f'Will install {to_install}. Enter to continue')
    for app in to_install:
        print(f'Installing {app}')
        install_flatpak(app)

if to_uninstall:
    input(f'Will uninstall {to_uninstall}. Enter to continue')
    for app in to_uninstall:
        print(f'Uninstalling {app}')
        uninstall_flatpak(app)

print('Done')
