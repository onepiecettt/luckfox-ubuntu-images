#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  upload-release-assets.sh [--repo OWNER/REPO] [--clobber] TAG IMAGE.img.xz [IMAGE.img.xz ...]

Examples:
  upload-release-assets.sh ubuntu-images-202609 Ubuntu_Luckfox_*.img.xz
  upload-release-assets.sh --clobber ubuntu-images-202609 Ubuntu_Luckfox_*.img.xz

Each image must have a matching IMAGE.img.xz.sha256 file in the same directory.
The script verifies every checksum before uploading either file.
EOF
}

repo="${GH_REPO:-onepiecettt/luckfox-ubuntu-images}"
clobber=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      if [[ $# -lt 2 ]]; then
        echo "--repo requires OWNER/REPO" >&2
        exit 2
      fi
      repo="$2"
      shift 2
      ;;
    --clobber)
      clobber=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      break
      ;;
  esac
done

if [[ $# -lt 2 ]]; then
  usage >&2
  exit 2
fi

tag="$1"
shift

if [[ ! "$tag" =~ ^[0-9A-Za-z][0-9A-Za-z._/-]*$ ]]; then
  echo "Invalid release tag: $tag" >&2
  exit 2
fi

for command_name in gh sha256sum; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Required command not found: $command_name" >&2
    exit 1
  fi
done

assets=()
for archive in "$@"; do
  if [[ ! -f "$archive" ]]; then
    echo "Image not found: $archive" >&2
    exit 1
  fi

  if [[ "$archive" != *.img.xz ]]; then
    echo "Expected an .img.xz file: $archive" >&2
    exit 1
  fi

  checksum="${archive}.sha256"
  if [[ ! -f "$checksum" ]]; then
    echo "Checksum file not found: $checksum" >&2
    exit 1
  fi

  archive_dir="$(dirname "$archive")"
  checksum_name="$(basename "$checksum")"
  (
    cd "$archive_dir"
    sha256sum -c "$checksum_name"
  )

  assets+=("$archive" "$checksum")
done

gh release view "$tag" --repo "$repo" >/dev/null

upload_options=()
if [[ "$clobber" == true ]]; then
  upload_options+=(--clobber)
fi

gh release upload "$tag" \
  "${assets[@]}" \
  --repo "$repo" \
  "${upload_options[@]}"

echo "Uploaded ${#assets[@]} assets to $repo release $tag"
