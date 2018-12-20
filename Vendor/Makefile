BUILD_DIR = build
REPO_DIR = $(BUILD_DIR)/Sparkle
DIST_DIR = Sparkle

default: $(DIST_DIR)

clean:
	$(RM) -r $(BUILD_DIR)
	$(RM) -r $(DIST_DIR)

$(REPO_DIR):
	mkdir -p $(BUILD_DIR)
	git clone git@github.com:sparkle-project/Sparkle.git $(REPO_DIR)
	cd $(REPO_DIR) && git checkout ui-separation-and-xpc

$(DIST_DIR): $(REPO_DIR)
	mkdir -p $(DIST_DIR)
	cd $(REPO_DIR) && xcodebuild \
		-scheme Distribution \
		-configuration Release \
		-derivedDataPath "../$(BUILD_DIR)" \
		build
	cd $(DIST_DIR) && tar xfvj ../$(BUILD_DIR)/build/Build/Products/Release/Sparkle-*.tar.bz2
	$(DIST_DIR)/bin/codesign_xpc "Developer ID Application" $(DIST_DIR)/XPCServices/*.xpc
