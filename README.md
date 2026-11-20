# drx

The command line for Shadow Twin: know whether every app and database could be rebuilt, without touching a production server.

## Install

macOS and Linux:

```sh
curl -fsSL https://raw.githubusercontent.com/getwingback/drx/main/install.sh | sh
```

Windows (PowerShell):

```powershell
irm https://raw.githubusercontent.com/getwingback/drx/main/install.ps1 | iex
```

Homebrew:

```sh
brew tap getwingback/drx https://github.com/getwingback/drx
brew install drx
```

The installer picks the right build for your system, checks its SHA-256 checksum, and installs to `/usr/local/bin`
(or `~/.local/bin` if that isn't writable). Set `DRX_VERSION=v0.1.0` for a specific version, or `DRX_INSTALL_DIR` for
another folder. Builds are also on the [releases page](https://github.com/getwingback/drx/releases).

## Get started

```sh
drx login        # your hub's URL and token
drx connect      # add Dokploy, Coolify, a VPS provider, AWS or a backup bucket
drx              # the live view
drx web          # the dashboard in your browser
```

## Update

Run the install command again.
