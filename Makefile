NAME = KeepingYouAwake
VERSION = 1.6.6

SCHEME = $(NAME)
TARGET = $(NAME)
DIST_TARGET = $(NAME) (Direct)
WORKSPACE = $(NAME).xcworkspace

BUILD_DIR = build
OUTPUT_DIR = dist
LOCALIZATIONS_DIR = Localizations

XCODEBUILD = set -o pipefail && env NSUnbufferedIO=YES xcodebuild
BEAUTIFY = | xcbeautify
DISABLE_PACKAGE_RESOLUTION = -disableAutomaticPackageResolution -onlyUsePackageVersionsFromResolvedFile
SAVE_LOG = 2>&1 | tee "$(BUILD_DIR)/$(NAME).log"

default: clean

clean:
	$(RM) -r $(BUILD_DIR)
PHONY: clean

dist-clean:
	$(RM) -r $(OUTPUT_DIR)
PHONY: dist-clean

test:
	@mkdir -p "$(BUILD_DIR)"
	$(XCODEBUILD) test \
	-workspace "$(WORKSPACE)" \
	-scheme "$(SCHEME)" \
	-derivedDataPath "$(BUILD_DIR)" \
	$(DISABLE_PACKAGE_RESOLUTION) \
	$(SAVE_LOG) \
	$(BEAUTIFY)
PHONY: test

test-with-sanitizers:
	@mkdir -p "$(BUILD_DIR)"
	$(XCODEBUILD) test \
	-workspace "$(WORKSPACE)" \
	-scheme "$(SCHEME)" \
	-testPlan "SanitizerTestPlan" \
	-derivedDataPath "$(BUILD_DIR)" \
	$(DISABLE_PACKAGE_RESOLUTION) \
	$(SAVE_LOG) \
	$(BEAUTIFY)
PHONY: test-with-sanitizers

l10n-export:
	Localizations/l10n-export.sh
.PHONY: l10n-export

l10n-import:
	Localizations/l10n-import.sh
.PHONY: l10n-export

l10n-update:
	$(MAKE) l10n-export
	$(MAKE) l10n-import
	$(MAKE) l10n-export
.PHONY: l10n-update

$(OUTPUT_DIR)/$(NAME).xcarchive:
	$(XCODEBUILD) archive \
	-workspace "$(WORKSPACE)" \
	-scheme "$(SCHEME)" \
	-archivePath "$(OUTPUT_DIR)/$(NAME).xcarchive" \
	$(DISABLE_PACKAGE_RESOLUTION) \
	$(SAVE_LOG) \
	$(BEAUTIFY)

$(OUTPUT_DIR)/$(NAME).pkg: $(OUTPUT_DIR)/$(NAME).xcarchive
	$(XCODEBUILD) \
	-exportArchive \
	-archivePath "$(OUTPUT_DIR)/$(NAME).xcarchive" \
	-exportPath "$(OUTPUT_DIR)/" \
	-exportOptionsPlist "ExportOptions.plist" \
	$(DISABLE_PACKAGE_RESOLUTION) \
	$(SAVE_LOG) \
	$(BEAUTIFY)

$(OUTPUT_DIR)/$(NAME)-$(VERSION).zip:
	@echo "Exporting $(OUTPUT_DIR)/$(NAME)-$(VERSION).zip..."
	@ditto -c -k --sequesterRsrc --keepParent $(OUTPUT_DIR)/$(NAME).app $(OUTPUT_DIR)/$(NAME)-$(VERSION).zip

dist: $(OUTPUT_DIR)/$(NAME)-$(VERSION).zip
	@echo "Verifying code signing identity..."
	@spctl -a -vv $(OUTPUT_DIR)/$(NAME).app
PHONY: dist
