# Install drx, the Shadow Twin CLI, on Windows.
#   irm https://raw.githubusercontent.com/getwingback/drx/main/install.ps1 | iex
$ErrorActionPreference = "Stop"
$repo = "getwingback/drx"
$version = if ($env:DRX_VERSION) { $env:DRX_VERSION } else { (Invoke-RestMethod "https://api.github.com/repos/$repo/releases/latest").tag_name }
$arch = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { "arm64" } else { "amd64" }
$file = "drx_$($version.TrimStart('v'))_windows_$arch.zip"
$base = "https://github.com/$repo/releases/download/$version"
$tmp = Join-Path ([IO.Path]::GetTempPath()) ("drx-" + [guid]::NewGuid())
New-Item -ItemType Directory $tmp | Out-Null
try {
  Write-Host "Downloading drx $version for windows/$arch"
  Invoke-WebRequest "$base/$file" -OutFile "$tmp\$file" -UseBasicParsing
  Invoke-WebRequest "$base/checksums.txt" -OutFile "$tmp\checksums.txt" -UseBasicParsing
  $want = ((Get-Content "$tmp\checksums.txt") | Where-Object { $_ -match " $([regex]::Escape($file))$" }) -split ' ' | Select-Object -First 1
  $got = (Get-FileHash "$tmp\$file" -Algorithm SHA256).Hash.ToLower()
  if (-not $want -or $want -ne $got) { throw "checksum mismatch, not installing" }
  $dir = if ($env:DRX_INSTALL_DIR) { $env:DRX_INSTALL_DIR } else { Join-Path $env:LOCALAPPDATA "drx" }
  New-Item -ItemType Directory -Force $dir | Out-Null
  Expand-Archive "$tmp\$file" -DestinationPath $dir -Force
  $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
  if (($userPath -split ';') -notcontains $dir) {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$dir", "User")
    Write-Host "Added $dir to your PATH. Open a new terminal to use it."
  }
  Write-Host "Installed drx $version to $dir\drx.exe"
  Write-Host "Next: drx login"
} finally { Remove-Item -Recurse -Force $tmp }
