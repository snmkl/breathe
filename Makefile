APP_NAME = Breathe
SWIFT_FILES = main.swift AppDelegate.swift BreatheView.swift
BUNDLE_ID = com.breathe.app
PREFIX = /usr/local

build: $(APP_NAME).app

$(APP_NAME).app:
	mkdir -p $(APP_NAME).app/Contents/MacOS
	mkdir -p $(APP_NAME).app/Contents/Resources
	swiftc -o $(APP_NAME).app/Contents/MacOS/$(APP_NAME) $(SWIFT_FILES)
	echo '<?xml version="1.0" encoding="UTF-8"?>' > $(APP_NAME).app/Contents/Info.plist
	echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> $(APP_NAME).app/Contents/Info.plist
	echo '<plist version="1.0">' >> $(APP_NAME).app/Contents/Info.plist
	echo '<dict>' >> $(APP_NAME).app/Contents/Info.plist
	echo '	<key>CFBundleExecutable</key>' >> $(APP_NAME).app/Contents/Info.plist
	echo '	<string>$(APP_NAME)</string>' >> $(APP_NAME).app/Contents/Info.plist
	echo '	<key>CFBundleIdentifier</key>' >> $(APP_NAME).app/Contents/Info.plist
	echo '	<string>$(BUNDLE_ID)</string>' >> $(APP_NAME).app/Contents/Info.plist
	echo '	<key>CFBundleName</key>' >> $(APP_NAME).app/Contents/Info.plist
	echo '	<string>$(APP_NAME)</string>' >> $(APP_NAME).app/Contents/Info.plist
	echo '	<key>CFBundleVersion</key>' >> $(APP_NAME).app/Contents/Info.plist
	echo '	<string>1.0</string>' >> $(APP_NAME).app/Contents/Info.plist
	echo '	<key>LSUIElement</key>' >> $(APP_NAME).app/Contents/Info.plist
	echo '	<string>1</string>' >> $(APP_NAME).app/Contents/Info.plist
	echo '</dict>' >> $(APP_NAME).app/Contents/Info.plist
	echo '</plist>' >> $(APP_NAME).app/Contents/Info.plist

install: build
	cp -R $(APP_NAME).app /Applications/
	osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/$(APP_NAME).app", hidden:false}'
	@echo "$(APP_NAME) installed to Applications and added to login items"

uninstall:
	rm -rf /Applications/$(APP_NAME).app
	osascript -e 'tell application "System Events" to delete login item "$(APP_NAME)"' 2>/dev/null || true
	@echo "$(APP_NAME) removed from Applications and login items"

run: build
	open $(APP_NAME).app

re: clean build

clean:
	rm -rf $(APP_NAME).app
	rm -f $(APP_NAME)

.PHONY: build install uninstall run clean
