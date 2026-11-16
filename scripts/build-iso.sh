#!/bin/sh
set -eu

output_dir=$(cd "$(dirname "$1")" && pwd)
iso_name=$(basename "$1")
staging_dir=$(cd "$2" && pwd)

docker run --rm --platform linux/amd64 \
    -v "$output_dir:/out" \
    -v "$staging_dir:/iso:ro" \
    debian:trixie-slim sh -ec '
        apt-get update
        apt-get install -y --no-install-recommends grub-common grub-pc-bin xorriso
        grub-mkrescue -o "/out/$1" /iso
    ' sh "$iso_name"
