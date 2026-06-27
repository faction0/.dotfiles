#!/bin/bash

flatpak run --env=QT_XCB_GL_INTEGRATION=none net.ankiweb.Anki "$@"