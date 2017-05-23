#!/usr/bin/env bash
set -e

$(dirname "$0")/l10n-export.sh
$(dirname "$0")/l10n-import.sh
$(dirname "$0")/l10n-export.sh # re-export to update the XLIFF files
