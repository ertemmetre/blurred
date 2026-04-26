#!/bin/sh
set -eu

# BLURRED-2026: Build one local Debug app containing both Apple Silicon and Intel slices.
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-"$ROOT_DIR/.DerivedDataUniversal"}"
SOURCE_PACKAGES_PATH="${SOURCE_PACKAGES_PATH:-"$ROOT_DIR/.SourcePackages"}"

# BLURRED-2026: Clear generated file-provider metadata before codesign sees the bundle.
/usr/bin/xattr -cr "$DERIVED_DATA_PATH" 2>/dev/null || true

# BLURRED-2026: Ask current Xcode for the standard macOS universal architecture pair.
xcodebuild \
  -project "$ROOT_DIR/Blurred.xcodeproj" \
  -scheme Blurred \
  -configuration Debug \
  -destination generic/platform=macOS \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  -clonedSourcePackagesDirPath "$SOURCE_PACKAGES_PATH" \
  ARCHS="arm64 x86_64" \
  ONLY_ACTIVE_ARCH=NO \
  build