NAME = KeepingYouAwake
VERSION = 1.6.3

SCHEME = $(NAME)
WORKSPACE = $(NAME).xcworkspace
CONFIGURATION = Debug

BUILD_DIR = build
OUTPUT_DIR = dist

XCODEBUILD = set -o pipefail && env NSUnbufferedIO=YES xcodebuild
BEAUTIFY = | xcbeautify
DISABLE_PACKAGE_RESOLUTION = -disableAutomaticPackageResolution -onlyUsePackageVersionsFromResolvedFile
SAVE_LOG = 2>&1 | tee "$(BUILD_DIR)/$(NAME).log"

default: clean

clean:
	$(RM) -r $(BUILD_DIR)

dist-clean:
	$(RM) -r $(OUTPUT_DIR)

test:
	@mkdir -p "$(BUILD_DIR)"
	$(XCODEBUILD) test \
	-workspace "$(WORKSPACE)" \
	-scheme "$(SCHEME)" \
	-configuration "$(CONFIGURATION)" \
	-derivedDataPath "$(BUILD_DIR)" \
	$(DISABLE_PACKAGE_RESOLUTION) \
	$(SAVE_LOG) \
	$(BEAUTIFY)

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

clangformat:
	$(info Reformatting source files with clang-format...)
	clang-format -style=file -i $(shell pwd)/**/*.{h,m}

.PHONY: clean dist-clean test dist clang-format
