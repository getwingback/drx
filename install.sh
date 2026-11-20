#!/bin/sh
# Install drx, the Shadow Twin CLI.
#   curl -fsSL https://raw.githubusercontent.com/getwingback/drx/main/install.sh | sh
# Options (environment variables):
#   DRX_VERSION=v0.1.0      install a specific version instead of the latest
#   DRX_INSTALL_DIR=~/bin   install somewhere else
set -eu

REPO="getwingback/drx"
say() { printf '%s\n' "$*"; }
die() { printf 'drx install: %s\n' "$*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || die "needs $1"; }
need curl; need tar; need uname

case "$(uname -s)" in
  Darwin) os=darwin ;;
  Linux) os=linux ;;
  *) die "unsupported system $(uname -s). On Windows, use install.ps1" ;;
esac
case "$(uname -m)" in
  x86_64|amd64) arch=amd64 ;;
  arm64|aarch64) arch=arm64 ;;
  *) die "unsupported processor $(uname -m)" ;;
esac

version="${DRX_VERSION:-}"
if [ -z "$version" ]; then
  version="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1)"
  [ -n "$version" ] || die "could not find the latest version"
fi
file="drx_${version#v}_${os}_${arch}.tar.gz"
base="https://github.com/$REPO/releases/download/$version"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
say "Downloading drx $version for $os/$arch"
curl -fsSL -o "$tmp/$file" "$base/$file" || die "download failed: $base/$file"
curl -fsSL -o "$tmp/checksums.txt" "$base/checksums.txt" || die "could not download checksums"

want="$(grep " $file\$" "$tmp/checksums.txt" | cut -d' ' -f1)"
if command -v sha256sum >/dev/null 2>&1; then got="$(sha256sum "$tmp/$file" | cut -d' ' -f1)"
else got="$(shasum -a 256 "$tmp/$file" | cut -d' ' -f1)"; fi
[ -n "$want" ] && [ "$want" = "$got" ] || die "checksum mismatch, not installing"
tar -xzf "$tmp/$file" -C "$tmp" drx

dir="${DRX_INSTALL_DIR:-}"
if [ -z "$dir" ]; then
  if [ -w /usr/local/bin ]; then dir=/usr/local/bin
  elif command -v sudo >/dev/null 2>&1 && [ -t 0 -o -t 1 ]; then dir=/usr/local/bin; use_sudo=1
  else dir="$HOME/.local/bin"; fi
fi
mkdir -p "$dir" 2>/dev/null || true
if [ "${use_sudo:-}" = 1 ]; then
  say "Installing to $dir (needs your password)"
  sudo install -m 0755 "$tmp/drx" "$dir/drx"
else
  install -m 0755 "$tmp/drx" "$dir/drx"
fi

say "Installed drx $version to $dir/drx"
case ":$PATH:" in
  *":$dir:"*) ;;
  *) say "Add $dir to your PATH:  export PATH=\"$dir:\$PATH\"" ;;
esac
say "Next: drx login"
