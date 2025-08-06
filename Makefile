APP_NAME = Breathe
SWIFT_FILES = main.swift AppDelegate.swift BreatheView.swift

build:
	swiftc -o $(APP_NAME) $(SWIFT_FILES)

run: build
	./$(APP_NAME)

clean:
	rm -f $(APP_NAME)

.PHONY: build run clean