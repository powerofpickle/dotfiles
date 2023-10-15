#!/usr/bin/env python3

import subprocess

with open('/etc/flatpaks') as f:
    flatpaks_config = f.read()

apps = set(line for line in flatpaks_config.splitlines() if line and not line.startswith('#'))

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
