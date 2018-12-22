SCHEME = KeepingYouAwake
WORKSPACE = KeepingYouAwake.xcworkspace
VERSION = 1.4.3

OUTPUT_DIR = dist
VENDOR_DIR = Vendor

FASTLANE = FASTLANE_SKIP_UPDATE_CHECK=1 FASTLANE_DISABLE_ANIMATION=1 fastlane

default: dist

clean:
	$(RM) -r build
	$(RM) -r $(OUTPUT_DIR)

$(VENDOR_DIR):
	$(MAKE) -C $(VENDOR_DIR)

$(OUTPUT_DIR)/$(SCHEME).app: $(VENDOR_DIR)
	$(MAKE) $(VENDOR_DIR)
	$(FASTLANE) gym \
	--workspace $(WORKSPACE) \
	--scheme $(SCHEME) \
	--output_directory $(OUTPUT_DIR) \
	--buildlog_path $(OUTPUT_DIR) \
	--archive_path $(OUTPUT_DIR)/$(SCHEME).xcarchive

$(OUTPUT_DIR)/$(SCHEME)-$(VERSION).zip: $(OUTPUT_DIR)/$(SCHEME).app
	@echo "Exporting $(OUTPUT_DIR)/$(SCHEME)-$(VERSION).zip..."
	@ditto -c -k --sequesterRsrc --keepParent $(OUTPUT_DIR)/$(SCHEME).app $(OUTPUT_DIR)/$(SCHEME)-$(VERSION).zip

dist: $(OUTPUT_DIR)/$(SCHEME)-$(VERSION).zip
	@echo "Verifying code signing identity..."
	@spctl -a -vv $(OUTPUT_DIR)/$(SCHEME).app

clangformat:
	$(info Reformatting source files with clang-format...)
	clang-format -style=file -i $(shell pwd)/**/*.{h,m}

.PHONY: clean dist $(VENDOR_DIR) clang-format
