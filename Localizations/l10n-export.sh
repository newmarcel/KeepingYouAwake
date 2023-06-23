#!/usr/bin/env bash
set -e
source $(dirname "$0")/l10n-config.sh

mkdir -p "${TARGET_DIR}"

EXPORT_LANG=""
for language in "${TRANSLATIONS[@]}"; do
    EXPORT_LANG="${EXPORT_LANG}-exportLanguage ${language} "
done

echo "Exporting translations..."
xcodebuild -exportLocalizations -localizationPath "${TARGET_DIR}" \
    -workspace "${WORKSPACE_FILE_PATH}" ${EXPORT_LANG} \
    -scheme "${PROJECT_NAME}" \
    -disableAutomaticPackageResolution -onlyUsePackageVersionsFromResolvedFile -skipPackageUpdates \
    PRODUCT_NAME="\$(TARGET_NAME)"
echo "Done."
