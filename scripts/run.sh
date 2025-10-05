#!/usr/bin/env bash

sh scripts/build.sh

export GSETTINGS_SCHEMA_DIR="$(pwd)/dist/share/glib-2.0/schemas"
export LD_PRELOAD=/usr/lib/libgtk4-layer-shell.so
export GBM_BACKEND=nvidia-drm
export GSK_RENDERER=vulkan
export GDK_BACKEND=wayland,x11

luajit dist/bin/* "${@}"
