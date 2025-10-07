# Trayslator
Trayslator is a tray application for translating text. You can translate text from the clipboard or by typing it into the input window. The translation source is configurable, you can change the service used.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Build with: Lazarus](https://img.shields.io/badge/Build_with-Lazarus-blueviolet)](https://www.lazarus-ide.org/)
[![Platform: Windows Linux](https://img.shields.io/badge/Platform-Windows-yellow)](#)
[![Languages: ar be zh en fr de hi it ja ko pt ru es uk](https://img.shields.io/badge/Lang-ar_be_zh_en_fr_de_hi_it_ja_ko_pt_ru_es_uk-green)](https://www.ethnologue.com)

## Installation

[![latest version](https://img.shields.io/github/v/release/nextwordis/trayslator?color=blue&label=Latest%20release&style=for-the-badge)](https://github.com/nextwordis/trayslator/releases/latest)

### Windows

Download the installer executable from the [releases page](https://github.com/nextwordis/trayslator/releases). Run the installer and follow the on-screen instructions to complete the installation. After installation, you can launch Trayslator from the Start menu or desktop shortcut.

---

### Linux
*Debian-like systems*

Download the appropriate `.deb` package for your system from the [releases page](https://github.com/nextwordis/trayslator/releases). To install the package, open a terminal and run:

```bash
sudo dpkg -i /path/to/trayslator.deb
```
If there are missing dependencies, fix them by running:
```bash
sudo apt-get install -f
```
To remove Trayslator from your system, use:

```bash
sudo dpkg -r trayslator
```

*Fedora-like systems*

Download the appropriate .rpm package for your system. To install the package, open a terminal and run:
```bash
sudo dnf install /path/to/trayslator.rpm
```
If there are missing dependencies, fix them by running:
```bash
sudo dnf install -y gtk2
```
To remove Trayslator from your system, use:

```bash
sudo dnf remove trayslator
```

## Licensing

Trayslator is licensed under the GPL v3 license. See the LICENSE file for details.

The Trayslator application uses third-party resources licensed as described in the [THIRD_PARTIES](THIRD_PARTIES) file.