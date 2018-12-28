BUILD_DIR = build
REPO_DIR = $(BUILD_DIR)/Sparkle
DIST_DIR = Sparkle

CODESIGN_IDENTITY = Developer ID Application
CODESIGN_CMD = codesign --verbose --force -o runtime --sign "$(CODESIGN_IDENTITY)"

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

	# Codesign Updater Binaries
	$(CODESIGN_CMD) --deep "$(DIST_DIR)/Sparkle.framework/Versions/A/Resources/Autoupdate"
	$(CODESIGN_CMD) --deep "$(DIST_DIR)/Sparkle.framework/Versions/A/Resources/Updater.app"
	$(CODESIGN_CMD) "$(DIST_DIR)/Sparkle.framework/Versions/A"

	# Codesign XPC Services
	patch $(DIST_DIR)/bin/codesign_xpc < codesign_xpc_hardened.patch
	$(DIST_DIR)/bin/codesign_xpc "$(CODESIGN_IDENTITY)" $(DIST_DIR)/XPCServices/*.xpc
