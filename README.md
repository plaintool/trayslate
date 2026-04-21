# Trayslate

Trayslate is a tray-based client for translation services. You can enter text directly, translate clipboard content, or translate selected text in any application. You can also replace text in another app with its translation using a hotkey. The app lets you choose and fully configure the translation service you use.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Build with: Lazarus](https://img.shields.io/badge/Build_with-Lazarus-blueviolet)](https://www.lazarus-ide.org/)
[![Platform: Windows](https://img.shields.io/badge/Platform-Windows-yellow)](#)
[![Latest Release](https://img.shields.io/github/v/release/plaintool/trayslate?label=Release)](https://github.com/plaintool/trayslate/releases/latest)
[![GitHub Downloads](https://img.shields.io/github/downloads/plaintool/trayslate/total?label=Downloads&cacheSeconds=3600)](https://github.com/plaintool/trayslate/releases)

## What is it?

A **compact tray translator** that is always at hand. It acts as a web client for translation services — meaning it doesn’t include any built-in engines, everything is handled through **external configurable services**. This keeps the tool **lightweight and independent**.

It works anywhere on your system. Select text in any application and translate it instantly using a **global hotkey** — not just in the browser. You can also replace text directly inside input fields with the translated version in a single keystroke. Double-click the tray icon to quickly translate your clipboard content.

For added convenience, the main window supports **real-time translation as you type**, allowing you to draft text and see the translation simultaneously.

The interface is available in **twenty-five widely used languages**, making it accessible to a global audience.

**Always close, always ready** — a translator that fits perfectly into your workflow.

![trayslate1](samples/trayslate1.png)

## Features:

- **Always Available** — Runs in the system tray and is always ready  
- **External Services** — Uses configurable translation services with no built-in engines  
- **Configurability** — Fully configurable using INI files  
- **System-wide Use** — Works across all applications, not just the browser  
- **Global Hotkeys** — Translate selected text using configurable hotkeys  
- **Input Replacement** — Replace text directly inside input fields using a hotkey  
- **Clipboard Support** — Process clipboard content via tray icon double-click or hotkeys  
- **Real-time Mode** — Live processing while typing with an adjustable delay  
- **Auto Language Swap** — Optional automatic swap based on the input language  
- **Tray Indicator** — Shows the current language pair and translation progress on the tray icon  
- **Recent Pairs** — Manage and automatically save recently used language pairs  
- **Multilingual UI** — Interface available in twenty-five widely used languages  
- **Dark Mode** — Supports Windows dark mode and adapts to system theme  

## Tray Icon

The tray icon is fully customizable in appearance settings and adapts to any Windows color scheme. It also provides a context menu for quick access to features such as switching configurations, managing recent language pairs, and other key functions.

![trayslate2](samples/trayslate2.png)

## Hotkeys

Global hotkeys can be fully configured in the application settings. They are available at any time and work even when the application is minimized to the system tray.

| Action | Shortcut |
|--------|----------|
| **Global Hotkeys** | |
| Shows or hides the main application window | `Ctrl + Shift + A` |
| Swaps the source and target languages | `Ctrl + Shift + S` |
| Translates the current text from the clipboard | `Ctrl + Shift + T` |
| Translates the current text in clipboard and copies the result to the clipboard | `Ctrl + Shift + R` |
| Translates the selected text from the active application | `Ctrl + Shift + C` |
| Replaces the selected text in the active application with the translation | `Ctrl + Shift + V` |
| Select recent language pair | `Ctrl + Shift + Number` |
| **Main Window Hotkeys** | |
| New Translate | `Ctrl + N` |
| Add Current Pair To Recent Panel | `Ctrl + F` |
| Translate | `Ctrl + Enter`<br>`Shift + Enter`<br>`Double Enter`|

## Settings

Settings allow you to configure the behavior, appearance, and global hotkeys of the application.

| General | Interface | Global Hotkeys |
|-------------|-------------|-------------|
| ![img](samples/settings1.png) | ![img](samples/settings2.png) | ![img](samples/settings3.png) |

## Config

The application comes with a powerful configuration editor, allowing you to create your own translation service configurations or modify existing ones.

| Service | Parameters |
|---------|------------|
| ![configeditor1](samples/configeditor1.png) | ![configeditor1](samples/configeditor2.png) |
| **Response** | **Languages** |
| ![configeditor1](samples/configeditor3.png) | ![configeditor1](samples/configeditor4.png) |
| **Target Languages** | |
| ![configeditor1](samples/configeditor5.png) | ![configeditor1](samples/configeditor6.png) |

## Installation

[![latest version](https://img.shields.io/github/v/release/plaintool/trayslate?color=blue&label=Latest%20release&style=for-the-badge)](https://github.com/plaintool/trayslate/releases/latest)

### Windows

Several installer options are available on the releases page:

| Description | Files |
|-------------|-------|
| **Universal installer (EXE)** — universal installer for **x86 and x64**, supports installation **for the current user or for all users** | `trayslate‑any‑x86‑x64.exe` |
| **User installer (MSI)** — installs the application **for the current user** | `trayslate‑x64.msi`<br>`trayslate‑x86.msi` |
| **System installer (MSI)** — installs the application **for all users on the system** | `trayslate‑x64‑allusers.msi`<br>`trayslate‑x86‑allusers.msi` |
| **Portable version** — saves its settings to `form_settings.json` if it is near the executable; otherwise, in the user directory | `trayslate‑x86‑x64‑portable.zip` |

> **Note:** Windows XP supports installation **only via MSI installers**. The EXE installer is **not compatible** with Windows XP.

Download the installer from the [releases page](https://github.com/plaintool/trayslate/releases), run it, and follow the on-screen instructions. After installation, you can launch Trayslate from the Start menu or from the desktop shortcut.

## Donate 💖

If you like Trayslate and want to support its development, you can send a donation:

| Currency | Network | Wallet Address |
|----------|-----------------|----------------|
| USDT     | Tron (TRC20)    | `TYSJJHjpu6aqr8UsGaCTLxDyh6HKWoNQ8k` |
| USDT     | Ethereum (ERC20), Binance Smart Chain (BEP20) | `0x328e689E961c3Abb143835f8677947Fa9eaF9f6F` |
| BTC      | Bitcoin (BTC)   | `bc1qp8m5j75yd58zhf9hl0a753shay093j2548f84e` |
| ETH      | Ethereum (ERC20)| `0x328e689E961c3Abb143835f8677947Fa9eaF9f6F` |

Every little help is appreciated! 🙏

## Licensing

Trayslate is licensed under the GPL v3 license. See the LICENSE file for details.

The Trayslate application uses third-party resources licensed as described in the [THIRD_PARTIES](THIRD_PARTIES) file.

## Disclaimer

The application does not provide any translation services. It acts as a client for third-party services only. All usage of external services is the sole responsibility of the user, including compliance with their respective terms of service.

The configuration files included in the distribution are intended to demonstrate the flexibility of setting up and integrating custom translation services. Users may obtain and use API keys from service providers and configure the application to work with those services in accordance with the providers official guidelines and terms.