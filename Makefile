.PHONY: build test lint format

build:
	swift build

test:
	swift test

lint:
	swiftlint

format:
	swiftlint --fix
