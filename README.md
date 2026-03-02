# HackTUI 

    ██╗  ██╗ █████╗  ██████╗██╗  ██╗ ████████╗██╗   ██╗██╗
    ██║  ██║██╔══██╗██╔════╝██║ ██╔╝ ╚══██╔══╝██║   ██║██║
    ███████║███████║██║     █████╔╝     ██║   ██║   ██║██║
    ██╔══██║██╔══██║██║     ██╔═██╗     ██║   ██║   ██║██║
    ██║  ██║██║  ██║╚██████╗██║  ██╗    ██║   ╚██████╔╝██║
    ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═╝    ╚═════╝ ╚═╝

------------------------------------------------------------------------

##  Project Overview

HackTUI is a unified **SIEM** and **NDR** platform built on Elixir/OTP.\
It transforms raw telemetry into actionable security intelligence.

------------------------------------------------------------------------

##  Dashboard Preview

![HackTUI Security Interface](assets/images/UI.png)

------------------------------------------------------------------------

##  Advanced SIEM Features

-   Stateful Correlation Engine\
-   Asynchronous Threat Enrichment\
-   PostgreSQL-backed Historical Storage\
-   Interactive Forensic Search (press **s**)\
-   OTP Fault-Tolerant Architecture

------------------------------------------------------------------------

## 🌐 Threat Intelligence & Risk ## 🌐 Threat Intelligence & Risk Assessment

HackTUI features a custom Risk Engine that classifies network connections based on ISP reputation, domain TLD, and resolution status:

| Indicator | Status | Context |
| :--- | :--- | :--- |
| 🟢 **[TRUSTED]** | Verified | Known-safe corporate infrastructure (Google, Amazon, Cloudflare). |
| 🟡 **[ANOMALY]** | Warning | Suspicious TLDs (.xyz, .cloud) utilizing reputable CDNs to mask origin. |
| 🔴 **[CRITICAL]**| High Risk | High-risk TLDs on unknown or non-reputable infrastructure. |
| 🔴 **[DEAD]** | NXDOMAIN | Unresolved domains, often indicative of DGA (Domain Generation Algorithms). |


------------------------------------------------------------------------

##  Architecture

-   NetScout -- Packet capture via tcpdump\
-   Enricher -- GeoIP & threat metadata\
-   Repo -- PostgreSQL interface\
-   State -- Correlation engine\
-   Dashboard -- ExRatatui rendering

------------------------------------------------------------------------

# ⚙ Installation & Setup

## 🐧 Linux

``` bash
sudo setcap 'cap_net_raw,cap_net_admin=eip' $(which tcpdump)
```

``` bash
sudo usermod -a -G systemd-journal $USER
```

Log out and back in after modifying group permissions.

------------------------------------------------------------------------

## 🍎 macOS

macOS does not support setcap. To capture traffic:

``` bash
brew install tcpdump
```

``` bash
sudo mix run --no-halt
```

Note: The journal sentinel is disabled on macOS.

------------------------------------------------------------------------

## 3️⃣ Database & Environment

Create a `.env` file:

``` bash
export HACKTUI_DB_PASS="your_secure_password"
```

Initialize:

``` bash
source .env
mix deps.get
mix ecto.setup
```

------------------------------------------------------------------------

## 4️⃣ Launching the SOC

``` bash
source .env
mix run --no-halt
```

------------------------------------------------------------------------

## 🎛 Controls

  Key   Action
  ----- -------------------------
  q     Graceful Shutdown
  c     Clear Alerts
  h     Fetch Historical Alerts
  s     Search

------------------------------------------------------------------------

##  Tech Stack

-   Elixir 1.19+ (OTP 28)
-   PostgreSQL 16+ (Ecto)
-   Req, Port-based TCPDump
-   ExRatatui 0.4.1

------------------------------------------------------------------------

##  Roadmap

-   [ ] ML-based anomaly detection (Nx)
-   [ ] Distributed ingestion agents
-   [ ] IPS auto-mitigation
-   [ ] GeoIP visual map

------------------------------------------------------------------------

##  License

MIT License

Copyright (c) 2026 aylac
