#  HackTUI

    ██╗  ██╗ █████╗  ██████╗██╗  ██╗ ████████╗██╗   ██╗██╗
    ██║  ██║██╔══██╗██╔════╝██║ ██╔╝ ╚══██╔══╝██║   ██║██║
    ███████║███████║██║     █████╔╝     ██║   ██║   ██║██║
    ██╔══██║██╔══██║██║     ██╔═██╗     ██║   ██║   ██║██║
    ██║  ██║██║  ██║╚██████╗██║  ██╗    ██║   ╚██████╔╝██║
    ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═╝    ╚═════╝ ╚═╝

------------------------------------------------------------------------

##  Project Overview

HackTUI is an Elixir-native Security Operations Center (SOC) dashboard.\
It provides real-time visibility into system-level events and network
traffic by leveraging the BEAM's concurrency model to stream data from
low-level system tools into a centralized terminal interface.

------------------------------------------------------------------------

##  Core Features

-   **Real-time DNS Monitoring**\
    Captures outbound DNS queries using `tcpdump` to identify potential
    data exfiltration or beaconing to suspicious TLDs.

-   **System Journal Streaming**\
    Integrates directly with `journalctl` to provide a live feed of
    authentication attempts, sudo usage, and kernel events.

-   **Automated Threat Detection**\
    Heuristic-based alerting system that flags suspicious network
    destinations and system permission failures in real-time.

-   **Reactive UI Architecture**\
    Built on ExRatatui, featuring a multi-pane layout with color-coded
    severity levels for rapid incident response.

------------------------------------------------------------------------

##  Architecture

The system operates as a supervised tree of specialized GenServers:

-   **NetScout** -- Manages a Port-based interface to `tcpdump` for
    network packet inspection.
-   **LogSentinel** -- Streams systemd journal entries into the
    application state.
-   **State** -- A centralized GenServer acting as the single source of
    truth for the UI.
-   **Dashboard** -- The rendering engine that transforms application
    state into the terminal layout.

------------------------------------------------------------------------

## ⚙ Installation and Setup

### 1️⃣ System Dependencies

The monitoring agents require specific Linux capabilities to run without
root privileges:

``` bash
# Grant network sniffing permissions
sudo setcap 'cap_net_raw,cap_net_admin=eip' $(which tcpdump)
```

``` bash
# Grant journal access
sudo usermod -a -G systemd-journal $USER
```

After running the above command, log out and back in for group changes
to apply.

------------------------------------------------------------------------

### 2️⃣ Application Setup

``` bash
# Clone the repository
git clone https://github.com/HackTuah/HackTUI.git
```

``` bash
cd HackTUI
```

``` bash
# Compile the project
mix compile
```

------------------------------------------------------------------------

## ▶ Usage

Run the dashboard:

``` bash
mix run --no-halt
```

------------------------------------------------------------------------

## 🎛 Controls

  Key   Action
  ----- ---------------------
  Q     Graceful Shutdown
  C     Clear Active Alerts

------------------------------------------------------------------------

## 🛠 Development

-   **Language:** Elixir 1.19.5\
-   **Runtime:** OTP 28.1\
-   **TUI Framework:** ExRatatui 0.4.1

------------------------------------------------------------------------

## 📜 License

MIT License
