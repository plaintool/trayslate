[:it: IT](README-it.md "Italian")&nbsp;&nbsp;

# Trayslate

Trayslate is a tray-based client for translation services. You can enter text directly, translate clipboard content, or translate selected text in any application. You can also replace text in another app with its translation using a hotkey. The app lets you choose and fully configure the translation service you use.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Build with: Lazarus](https://img.shields.io/badge/Build_with-Lazarus-blueviolet)](https://www.lazarus-ide.org/)
[![Platform: Windows](https://img.shields.io/badge/Platform-Windows-yellow)](#)
[![Latest Release](https://img.shields.io/github/v/release/plaintool/trayslate?label=Release)](https://github.com/plaintool/trayslate/releases/latest)
[![GitHub Downloads](https://img.shields.io/github/downloads/plaintool/trayslate/total?label=Downloads&cacheSeconds=3600)](https://github.com/plaintool/trayslate/releases)

<p align="left">
  <a href="https://www.majorgeeks.com/files/details/trayslate.html">
    <img src="https://majorgeeks.com/images/mg_approved.gif" alt="MajorGeeks Approved" height="80">
  </a>
  <a href="https://www.softpedia.com/get/Office-tools/Other-Office-Tools/trayslate.shtml">
    <img src="https://cdnssl.softpedia.com/_img/softpedia_100_free.png" alt="Softpedia" height="80">
  </a>
</p>

## What is it?

A **compact tray translator** that is always at hand. It acts as a web client for translation services — meaning it doesn’t include any built-in engines, everything is handled through **external configurable services**. This keeps the tool **lightweight and independent**.

It works anywhere on your system. Select text in any application and translate it instantly using a **global hotkey** — not just in the browser. You can also replace text directly inside input fields with the translated version in a single keystroke. Double-click the tray icon to quickly translate your clipboard content.

For added convenience, the main window supports **real-time translation as you type**, allowing you to draft text and see the translation simultaneously.

The interface is available in **twenty-five widely used languages**, making it accessible to a global audience.

**Always close, always ready** — a translator that fits perfectly into your workflow.

![trayslate1](samples/trayslate1.png)

---

## Features:

- **Always Available** — Runs in the system tray and is always ready  
- **External Services** — Uses configurable translation services with no built-in engines  
- **Configurability** — Fully configurable using INI files  
- **System-wide Use** — Works across all applications, not just the browser  
- **Global Hotkeys** — Translate selected text using configurable hotkeys  
- **Input Replacement** — Replace text directly inside input fields using a hotkey  
- **Clipboard Support** — Process clipboard content via tray icon double-click or hotkeys  
- **Popup Window** — Floating translation window with quick access from anywhere
- **Real-time Mode** — Live processing while typing with an adjustable delay  
- **Auto Language Swap** — Optional automatic swap based on the input language  
- **Smart Language Swap** — Automatically switches language pair if detected language is outside current pair  
- **Tray Indicator** — Shows the current language pair and translation progress on the tray icon  
- **Recent Pairs** — Manage and automatically save recently used language pairs  
- **Mouse Mode** — Translate text by simply selecting it with the mouse in any application  
- **Multilingual UI** — Interface available in twenty-five widely used languages  
- **Dark Mode** — Supports Windows dark mode and adapts to system theme  

## Tray Icon

The tray icon is fully customizable in appearance settings and adapts to any Windows color scheme. It also provides a context menu for quick access to features such as switching configurations, managing recent language pairs, and other key functions.

![trayslate2](samples/trayslate2.png)

---

## Recent Language Pairs

A convenient panel for instantly switching between your most frequently used language pairs and configurations. Each entry can belong to a different config, making it easy to jump across workflows without extra setup.

The panel can be automatically populated based on your activity when auto-add is enabled in the settings, keeping your most relevant pairs always within reach. You can also add pairs manually at any time using the plus button on the panel or middle-click any pair to remove it from the panel.

![trayslate3](samples/trayslate3.png)

---

## Popup Window

Popup translation window supports text translation using configurable hotkeys. You can translate either text from the clipboard or selected text from any application. 

Drag-and-drop of text from other applications into the popup window is also supported 

> **Note:** Depending on Windows security restrictions, drag-and-drop may require both Trayslate and the source application to run with the same privileges.

The popup window can stay on top of other windows and supports adjustable transparency, with separate settings for both idle and hover states. It also allows configuring the visibility of interface elements, which can be shown only on hover or kept always visible. All these options are configurable in Settings.

![popup1](samples/popup1.png)

---

## Mouse Mode

Mouse Mode allows translating text by selecting it with the mouse in any application. After selecting text, a translation action becomes available depending on the selected mode.

By default, a Translate button appears after text selection. Clicking this button opens the translation result in a popup window if needed.

You can configure how translation is triggered after selection:

- Only When Ctrl Is Pressed — Mouse Mode is active only while holding the Ctrl key
- Show Translate Button — Displays a translation button after selecting text (default behavior)
- Show Balloon Translation — Shows translation in a tray balloon popup (system tray notification)
- Show Popup Translation — Opens a floating popup window with the translation result
- Show Main Window — Sends the selected text to the main application window for translation

![popup2](samples/popup2.png)

---

## Hotkeys

Global hotkeys can be fully configured in the application settings. They are available at any time and work even when the application is minimized to the system tray.

| Action | Shortcut |
|--------|----------|
| **Global Hotkeys** | |
| Shows or hides the main application window | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>A</kbd> |
| Swaps the source and target languages | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>S</kbd> |
| Translates the current text from the clipboard | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>T</kbd> |
| Translates the current text in clipboard and copies the result to the clipboard | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>R</kbd> |
| Translates clipboard text to a popup window near the mouse cursor | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd> |
| Translates the selected text from the active application | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>C</kbd> |
| Replaces the selected text in the active application with the translation | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>V</kbd> |
| Translates selected text from the active application to a popup window | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>X</kbd> |
| **Recent Language Pair Hotkeys** | |
| Select recent language pair 1 | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>1</kbd> |
| Select recent language pair 2 | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>2</kbd> |
| Select recent language pair 3 | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>3</kbd> |
| Select recent language pair 4 | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>4</kbd> |
| Select recent language pair 5 | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>5</kbd> |
| Select recent language pair 6 | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>6</kbd> |
| Select recent language pair 7 | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>7</kbd> |
| Select recent language pair 8 | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>8</kbd> |
| Select recent language pair 9 | <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>9</kbd> |
| **Main Window Hotkeys** | |
| New Translate | <kbd>Ctrl</kbd> + <kbd>N</kbd> |
| Add Current Pair To Recent Panel | <kbd>Ctrl</kbd> + <kbd>F</kbd> |
| Translate | <kbd>Ctrl</kbd> + <kbd>Enter</kbd><br><kbd>Shift</kbd> + <kbd>Enter</kbd><br><kbd>Double Enter</kbd> |

---

## Auto-Swap Languages

Automatically detects the input language using the selected language detection configuration and updates the translation pair accordingly.

When enabled, the application analyzes the source text language and automatically swaps the translation direction if the detected language does not match the current source language.

> **Note:** This feature does not work during Real-Time Translation mode, where the language pair remains fixed for continuous processing.

### Smart Language Swap

Automatically adjusts the translation direction based on the detected input language and the configured Primary/Secondary language pair.

If the detected language is outside the current Primary/Secondary pair:
- The detected language becomes the new Source language
- The Target language is set to Primary language

If the detected language matches the Primary language:
- The translation pair is restored to Primary → Secondary

### Preferred Primary/Secondary Behavior
When the detected language matches the configured Target language, the application restores the original Primary/Secondary pair instead of performing a standard swap.

This ensures consistent behavior and keeps the preferred language pair as the default translation direction.

---

## Settings

Settings allow you to configure the behavior, appearance, and global hotkeys of the application.

| General | Interface |
|-------------|-------------|
| ![img](samples/settings1.png) | ![img](samples/settings2.png) | 
| **Hotkeys** | **Network** |
| ![img](samples/settings3.png) | ![img](samples/settings4.png) |

---

## Config

The application comes with a powerful configuration editor, allowing you to create your own translation service configurations or modify existing ones.

| Service | Request |
|---------|------------|
| ![configeditor1](samples/configeditor1.png) | ![configeditor1](samples/configeditor2.png) |
| **Response** | **Parameters** |
| ![configeditor1](samples/configeditor3.png) | ![configeditor1](samples/configeditor4.png) |
| **Languages** | **Target Languages** |
| ![configeditor1](samples/configeditor5.png) | ![configeditor1](samples/configeditor6.png) |

---

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

> **Warning!** Reinstalling the application will overwrite all configuration files in the installation path. Please make a backup before proceeding.

Download the installer from the [releases page](https://github.com/plaintool/trayslate/releases), run it, and follow the on-screen instructions. After installation, you can launch Trayslate from the Start menu or from the desktop shortcut.

---

## Donate 💖

If you like Trayslate and want to support its development, you can send a donation:

You can support Trayslate development through one of the following options:

💳&nbsp;[Donate with Bank Card or PayPal](https://app.lava.top/en/astverskoy?tabId=about&currency=EUR)  
&nbsp;₿&nbsp;&nbsp; [Donate with Cryptocurrency](https://nowpayments.io/donation/astverskoy)

Every contribution helps improve Trayslate and keep the project active. Thank you for your support! 🙏

---

## Licensing

Trayslate is licensed under the GPL v3 license. See the LICENSE file for details.

The Trayslate application uses third-party resources licensed as described in the [THIRD_PARTIES](THIRD_PARTIES) file.

## Disclaimer

The application does not provide any translation services. It acts as a client for third-party services only. All usage of external services is the sole responsibility of the user, including compliance with their respective terms of service.

The configuration files included in the distribution are intended to demonstrate the flexibility of setting up and integrating custom translation services. Users may obtain and use API keys from service providers and configure the application to work with those services in accordance with the providers' official guidelines and terms. The functionality, compatibility, and continued operation of the provided configuration files are not guaranteed and may change due to updates or modifications made by third-party service providers.
