#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(dirname "$0")"
DIST_DIR="/unikernels/memtrace"

cd "$SCRIPT_DIR"
mirage configure -t xen
make
mkdir -p "$DIST_DIR"
cp -Rf ./dist/* "$DIST_DIR"
