BUILD_DIR = build
REPO_DIR = $(BUILD_DIR)/Sparkle
DIST_DIR = Sparkle

SPARKLE_COMMIT = b1c3b313f53c95a91c8adc07b991ff9a306e6cf8 # ui-separation-and-xpc

default: $(DIST_DIR)

clean:
	$(RM) -r $(BUILD_DIR)
	$(RM) -r $(DIST_DIR)

$(REPO_DIR):
	mkdir -p $(BUILD_DIR)
	git clone git@github.com:sparkle-project/Sparkle.git $(REPO_DIR)
	cd $(REPO_DIR) && git checkout $(SPARKLE_COMMIT)

$(DIST_DIR): $(REPO_DIR)
	mkdir -p $(DIST_DIR)
	cd $(REPO_DIR) && xcodebuild \
		-scheme Distribution \
		-configuration Release \
		-derivedDataPath "../$(BUILD_DIR)" \
		build
	cd $(DIST_DIR) && tar xfvj ../$(BUILD_DIR)/build/Build/Products/Release/Sparkle-*.tar.bz2
	$(DIST_DIR)/bin/codesign_xpc "Developer ID Application" $(DIST_DIR)/XPCServices/*.xpc
