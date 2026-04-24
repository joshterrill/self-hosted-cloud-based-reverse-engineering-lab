#!/bin/bash

QT_PLUGIN_PATH=$(find /opt -name libqxcb.so 2>/dev/null | head -n1 | xargs dirname)

export QT_QPA_PLATFORM=xcb
export QT_QPA_PLATFORM_PLUGIN_PATH="$QT_PLUGIN_PATH"
export QT_XCB_GL_INTEGRATION=none
export LIBGL_ALWAYS_SOFTWARE=1

# DO NOT REMOVE, needed to start GUI + VNC
exec /startup.sh