#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST_DIR="$ROOT_DIR/assets/notes"
LEGACY_REPO_URL="${NOTAKU_LEGACY_REPO_URL:-https://github.com/Agien99/Notaku_Sejarah.git}"

mkdir -p "$DEST_DIR"

declare -A EXPECTED_SHA=(
  ["tingkatan_1.pdf"]="fef5b09c05021eff1bc7bb5f340c563bf625fe3bde1c88227930f925c414fa23"
  ["tingkatan_2.pdf"]="514b8a03922970741fcd899e544d5e1f45810daf02f28e1bd7544f59462fe873"
  ["tingkatan_3.pdf"]="2fa05dab25445d50d9baaae8557b6a60eb2a15091d1f34d585aebe491f11be79"
)

validate_pdf() {
  local file="$1"
  local expected_sha="$2"

  [[ -f "$file" ]] || return 1
  [[ "$(head -c 5 "$file")" == "%PDF-" ]] || return 1

  local actual_sha
  actual_sha="$(sha256sum "$file" | awk '{print $1}')"
  [[ "$actual_sha" == "$expected_sha" ]]
}

all_valid=true
for filename in "${!EXPECTED_SHA[@]}"; do
  if ! validate_pdf "$DEST_DIR/$filename" "${EXPECTED_SHA[$filename]}"; then
    all_valid=false
    break
  fi
done

if [[ "$all_valid" == true ]]; then
  echo "Offline note PDFs are already synchronized."
  exit 0
fi

command -v git >/dev/null 2>&1 || {
  echo "git is required to synchronize note PDFs." >&2
  exit 1
}

command -v git-lfs >/dev/null 2>&1 || {
  echo "git-lfs is required to synchronize note PDFs." >&2
  exit 1
}

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Synchronizing Tingkatan 1-3 PDFs from the legacy Notaku Sejarah repository..."
GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1 "$LEGACY_REPO_URL" "$TMP_DIR/legacy"
git -C "$TMP_DIR/legacy" lfs install --local
git -C "$TMP_DIR/legacy" lfs pull --include="notes/*.pdf"

cp "$TMP_DIR/legacy/notes/Tingkatan 1.pdf" "$DEST_DIR/tingkatan_1.pdf"
cp "$TMP_DIR/legacy/notes/Tingkatan 2.pdf" "$DEST_DIR/tingkatan_2.pdf"
cp "$TMP_DIR/legacy/notes/Tingkatan 3.pdf" "$DEST_DIR/tingkatan_3.pdf"

for filename in "${!EXPECTED_SHA[@]}"; do
  if ! validate_pdf "$DEST_DIR/$filename" "${EXPECTED_SHA[$filename]}"; then
    echo "Validation failed for $filename." >&2
    exit 1
  fi
done

echo "Offline note PDFs synchronized and verified."
