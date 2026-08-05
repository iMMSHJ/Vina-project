#!/usr/bin/env bash

LOG_DIR="/opt/installer/logs"
LOG_FILE="${LOG_DIR}/installer.log"

mkdir -p "$LOG_DIR"

exec > >(tee -a "$LOG_FILE") 2>&1
