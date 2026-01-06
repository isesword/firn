#!/bin/bash
set -e

echo "🦀 Building Rust library..."

cd rust
mkdir -p ../lib

# Set macOS deployment target to avoid version warnings
if [[ "$OSTYPE" == "darwin"* ]]; then
    export MACOSX_DEPLOYMENT_TARGET=15.0
fi

# Build for release (native by default)
cargo build --release

echo "✅ Rust library built successfully"

LIB_NAME="firn"
TARGET_DIR="target/release"

if [[ "$OSTYPE" == "darwin"* ]]; then
    cp "${TARGET_DIR}/lib${LIB_NAME}.a" "../lib/libfirn_darwin_arm64.a"
    echo "📦 Static library copied to: ../lib/libfirn_darwin_arm64.a"
    ls -la "../lib/libfirn_darwin_arm64.a"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cp "${TARGET_DIR}/lib${LIB_NAME}.a" "../lib/libfirn_linux_amd64.a"
    echo "📦 Static library copied to: ../lib/libfirn_linux_amd64.a"
    ls -la "../lib/libfirn_linux_amd64.a"
elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* || "$OSTYPE" == "win"* ]]; then
    # Build for MSVC target to match Windows runners
    cargo build --release --target x86_64-pc-windows-msvc
    TARGET_DIR="target/x86_64-pc-windows-msvc/release"
    cp "${TARGET_DIR}/${LIB_NAME}.lib" "../lib/firn_windows_amd64.lib"
    echo "📦 Static library copied to: ../lib/firn_windows_amd64.lib"
    ls -la "../lib/firn_windows_amd64.lib"
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

echo "🎉 Build complete!"
