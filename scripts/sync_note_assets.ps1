$ErrorActionPreference = "Stop"

$RootDir = Split-Path -Parent $PSScriptRoot
$DestDir = Join-Path $RootDir "assets\notes"
$LegacyRepoUrl = if ($env:NOTAKU_LEGACY_REPO_URL) {
    $env:NOTAKU_LEGACY_REPO_URL
} else {
    "https://github.com/Agien99/Notaku_Sejarah.git"
}

New-Item -ItemType Directory -Force -Path $DestDir | Out-Null

$ExpectedSha = @{
    "tingkatan_1.pdf" = "fef5b09c05021eff1bc7bb5f340c563bf625fe3bde1c88227930f925c414fa23"
    "tingkatan_2.pdf" = "514b8a03922970741fcd899e544d5e1f45810daf02f28e1bd7544f59462fe873"
    "tingkatan_3.pdf" = "2fa05dab25445d50d9baaae8557b6a60eb2a15091d1f34d585aebe491f11be79"
}

function Test-NotePdf {
    param(
        [string]$Path,
        [string]$ExpectedHash
    )

    if (-not (Test-Path $Path)) {
        return $false
    }

    $bytes = [System.IO.File]::ReadAllBytes($Path)
    if ($bytes.Length -lt 5) {
        return $false
    }

    $signature = [System.Text.Encoding]::ASCII.GetString($bytes, 0, 5)
    if ($signature -ne "%PDF-") {
        return $false
    }

    $actualHash = (Get-FileHash -Algorithm SHA256 -Path $Path).Hash.ToLowerInvariant()
    return $actualHash -eq $ExpectedHash
}

$AllValid = $true
foreach ($filename in $ExpectedSha.Keys) {
    if (-not (Test-NotePdf -Path (Join-Path $DestDir $filename) -ExpectedHash $ExpectedSha[$filename])) {
        $AllValid = $false
        break
    }
}

if ($AllValid) {
    Write-Host "Offline note PDFs are already synchronized."
    exit 0
}

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "git is required to synchronize note PDFs."
}

if (-not (Get-Command git-lfs -ErrorAction SilentlyContinue)) {
    throw "git-lfs is required to synchronize note PDFs."
}

$TempDir = Join-Path ([System.IO.Path]::GetTempPath()) ("notaku-notes-" + [guid]::NewGuid())
try {
    $env:GIT_LFS_SKIP_SMUDGE = "1"
    git clone --depth 1 $LegacyRepoUrl $TempDir
    if ($LASTEXITCODE -ne 0) { throw "Legacy repository clone failed." }

    git -C $TempDir lfs install --local
    git -C $TempDir lfs pull --include="notes/*.pdf"
    if ($LASTEXITCODE -ne 0) { throw "Git LFS download failed." }

    Copy-Item (Join-Path $TempDir "notes\Tingkatan 1.pdf") (Join-Path $DestDir "tingkatan_1.pdf") -Force
    Copy-Item (Join-Path $TempDir "notes\Tingkatan 2.pdf") (Join-Path $DestDir "tingkatan_2.pdf") -Force
    Copy-Item (Join-Path $TempDir "notes\Tingkatan 3.pdf") (Join-Path $DestDir "tingkatan_3.pdf") -Force

    foreach ($filename in $ExpectedSha.Keys) {
        if (-not (Test-NotePdf -Path (Join-Path $DestDir $filename) -ExpectedHash $ExpectedSha[$filename])) {
            throw "Validation failed for $filename."
        }
    }

    Write-Host "Offline note PDFs synchronized and verified."
}
finally {
    Remove-Item Env:GIT_LFS_SKIP_SMUDGE -ErrorAction SilentlyContinue
    if (Test-Path $TempDir) {
        Remove-Item -Recurse -Force $TempDir
    }
}
