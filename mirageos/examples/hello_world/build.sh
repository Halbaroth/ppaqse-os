#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(dirname "$0")"
DIST_DIR="/dist/hello_world"

cd "$SCRIPT_DIR"
mirage configure -t unix
make
mkdir -p "$DIST_DIR"
cp -Rf ./dist/* "$DIST_DIR"
