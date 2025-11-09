```
██╗  ██╗ █████╗  ██████╗██╗  ██╗ ████████╗██╗   ██╗██╗
██║  ██║██╔══██╗██╔════╝██║ ██╔╝ ╚══██╔══╝██║   ██║██║
███████║███████║██║     █████╔╝     ██║   ██║   ██║██║
██╔══██║██╔══██║██║     ██╔═██╗     ██║   ██║   ██║██║
██║  ██║██║  ██║╚██████╗██║  ██╗    ██║   ╚██████╔╝██║
╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═╝    ╚═════╝ ╚═╝
```


# 🌌 HackTUI

**HackTUI** is a **Elixir-native Terminal User Interface (TUI)** framework built entirely from scratch... no dependencies, no macros, just pure OTP, ANSI control codes, and a touch of aurora magic.

![HackTUI Aurora Preview](https://github.com/HackTuah/HackTUI/assets/preview.png)

---

## ✨ Features

- ⚙️ **Pure Elixir / OTP** — No NIFs, no Curses, no dependencies.
- 🧠 **Reactive Render Loop** — Redraws in place using ANSI cursor control.
- 🌈 **Aurora Color Cycle** — Frame edges shimmer through purple, cyan, magenta, and green.
- 🔄 **Live State Sync** — Shared GenServer state (`HackTUI.State`) provides instant message updates.
- 🎛️ **Keyboard Input Loop** — Key events processed through `HackTUI.Input` → `HackTUI.Router` → `HackTUI.MCP`.
- 🧩 **Extensible Architecture** — Add panels, logs, or C2 dashboard modules with minimal coupling.

---

## 🧠 Architecture Overview

```
 ┌────────────────────────────────────┐
 │              HackTUI               │
 ├────────────────────────────────────┤
 │  Application Supervisor            │
 │   ├── Renderer (GenServer)         │
 │   ├── Input (Key Reader)           │
 │   ├── Router (Dispatch Layer)      │
 │   ├── MCP (Message / Command Proc.)│
 │   └── State (Global ETS / Map)     │
 └────────────────────────────────────┘
```

---

## ⚡ Installation

```bash
# Clone the repository
git clone https://github.com/HackTuah/HackTUI.git
cd HackTUI

# Ensure Erlang and Elixir (>= 1.19 / OTP 28)
asdf install erlang 28.1.1
asdf install elixir 1.19.2-otp-28
asdf local erlang 28.1.1
asdf local elixir 1.19.2-otp-28

# Compile
mix compile
```

---

## 🚀 Run

```bash
mix run --no-halt
```

### Keys
| Key | Action |
|-----|--------|
| **H** | Help |
| **R** | Refresh animation |
| **X** | Execute placeholder |
| **Q** | Quit |

---

## 🌈 Aurora Renderer

HackTUI uses ANSI escape sequences to repaint a single terminal region each frame.  
The border cycles through a soft aurora palette:

```
magenta → light_magenta → cyan → light_cyan → green → light_green
```

The effect looks best on **dark terminals** that support 256-color or TrueColor.

---

## 🧩 Example Module Reference

| Module | Purpose |
|---------|----------|
| `HackTUI.Renderer` | Draws frame at fixed FPS with aurora color cycling |
| `HackTUI.Input` | Non-echo raw key reader |
| `HackTUI.Router` | Routes key events to MCP |
| `HackTUI.MCP` | Command processor with refresh animation |
| `HackTUI.State` | Central state server for messages |

---

## 💡 Extending HackTUI

- Add a **log panel** by introducing a `HackTUI.Log` GenServer that keeps the last 10 messages.
- Create **MCP plugins** that dispatch to command handlers dynamically.
- Replace the aurora palette with your own RGB gradients (true-color terminals supported).

---

## 🛠️ Development

```bash
mix compile --force
iex -S mix
```

---

## 📜 License

MIT License © 2025 **HackTuah**

Crafted with ☕, ⚡, and Elixir’s OTP soul.

---

> _"The terminal isn’t just text — it’s canvas."_  
> — **ChatGPT**
