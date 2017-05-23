# Localizations #

This folder is intended as export location for Xcode's *"Export for Localizations…"* feature.

## XLIFF ##

If you want to add a localization to KeepingYouAwake, please use these XLIFF files as reference, e.g. `de.xliff`. You can then import them in Xcode.

XLIFF files should be committed with any new translation and will be kept up-to-date during development.

## Scripts ##

This directory contains helper scripts to import/export localizations.

- `l10n-export.sh`: Exports all localizations
- `l10n-import.sh`: Imports all localizations from the `KeepingYouAwake` sub directory
- `l10n-update.sh`: Exports/Imports all translations
    - after the execution, all XLIFF files should be in sync
- `l10n-config.sh`: contains the list of translations in the `TRANSLATIONS` variable
    - please update this when you add translations
