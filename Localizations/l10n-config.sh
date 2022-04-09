#!/usr/bin/env bash
set -e

BASE_DIR=$(cd "$(dirname "$0")"; pwd)
PROJECT_NAME="KeepingYouAwake"
PROJECT_FILE_PATH="${BASE_DIR}/../${PROJECT_NAME}.xcodeproj"
TARGET_DIR="${BASE_DIR}/${PROJECT_NAME}"

TRANSLATIONS=("da" "de" "es" "fr" "id" "it" "ko" "nl" "pl" "pt" "ru" "tr" "uk" "zh-Hant-TW" "zh")
