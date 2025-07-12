#!/usr/bin/env bash
set -e

BASE_DIR=$(cd "$(dirname "$0")"; pwd)
PROJECT_NAME="KeepingYouAwake"
PROJECT_FILE_PATH="${BASE_DIR}/../${PROJECT_NAME}.xcodeproj"
WORKSPACE_FILE_PATH="${BASE_DIR}/../${PROJECT_NAME}.xcworkspace"
TARGET_DIR="${BASE_DIR}/${PROJECT_NAME}"

TRANSLATIONS=("da" "de" "el" "es" "fi" "fr" "hi" "id" "it" "ja" "ko" "nl" "pl" "pt" "ru" "sk" "tr" "uk" "vi" "zh-Hant" "zh")
