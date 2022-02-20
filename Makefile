SCHEME = KeepingYouAwake
WORKSPACE = KeepingYouAwake.xcworkspace
VERSION = 1.6.2

OUTPUT_DIR = dist
VENDOR_DIR = Vendor

default: dist

clean:
	$(RM) -r build
	$(RM) -r $(OUTPUT_DIR)

$(VENDOR_DIR):
	$(MAKE) -C $(VENDOR_DIR)

$(OUTPUT_DIR)/$(SCHEME)-$(VERSION).zip:
	@echo "Exporting $(OUTPUT_DIR)/$(SCHEME)-$(VERSION).zip..."
	@ditto -c -k --sequesterRsrc --keepParent $(OUTPUT_DIR)/$(SCHEME).app $(OUTPUT_DIR)/$(SCHEME)-$(VERSION).zip

dist: $(OUTPUT_DIR)/$(SCHEME)-$(VERSION).zip
	@echo "Verifying code signing identity..."
	@spctl -a -vv $(OUTPUT_DIR)/$(SCHEME).app

clangformat:
	$(info Reformatting source files with clang-format...)
	clang-format -style=file -i $(shell pwd)/**/*.{h,m}

.PHONY: clean dist $(VENDOR_DIR) clang-format
