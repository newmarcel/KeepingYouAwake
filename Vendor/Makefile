BUILD_DIR = build
REPO_DIR = $(BUILD_DIR)/Sparkle
DIST_DIR = Sparkle

CODESIGN_IDENTITY = Developer ID Application
CODESIGN_CMD = codesign --verbose --force -o runtime --sign "$(CODESIGN_IDENTITY)"

SPARKLE_COMMIT = 2f9c7217196b1f5d3202ae63bb8682d6e01052a2 # ui-separation-and-xpc

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

	# Remove Redundant Updater Binaries
	$(RM) $(DIST_DIR)/Sparkle.framework/Versions/A/Resources/Autoupdate
	$(RM) -r $(DIST_DIR)/Sparkle.framework/Versions/A/Resources/Updater.app

	# Codesign XPC Services
	$(DIST_DIR)/bin/codesign_embedded_executable "$(CODESIGN_IDENTITY)" $(DIST_DIR)/XPCServices/*.xpc
