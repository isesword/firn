#!/bin/bash
set -e

echo "🦀 Building Rust library..."

cd rust
mkdir -p ../lib

# Set macOS deployment target to avoid version warnings
if [[ "$OSTYPE" == "darwin"* ]]; then
    export MACOSX_DEPLOYMENT_TARGET=14.0
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
    # 复制动态链接库（.dylib）
    if [ -f "${TARGET_DIR}/lib${LIB_NAME}.dylib" ]; then
        cp "${TARGET_DIR}/lib${LIB_NAME}.dylib" "../lib/libfirn_darwin_arm64.dylib"
        echo "📦 Dynamic library copied to: ../lib/libfirn_darwin_arm64.dylib"
        ls -la "../lib/libfirn_darwin_arm64.dylib"
            install_name_tool -id "@rpath/libfirn_darwin_arm64.dylib" "../lib/libfirn_darwin_arm64.dylib"
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cp "${TARGET_DIR}/lib${LIB_NAME}.a" "../lib/libfirn_linux_amd64.a"
    echo "📦 Static library copied to: ../lib/libfirn_linux_amd64.a"
    ls -la "../lib/libfirn_linux_amd64.a"
    # 复制动态链接库（.so）
    if [ -f "${TARGET_DIR}/lib${LIB_NAME}.so" ]; then
        cp "${TARGET_DIR}/lib${LIB_NAME}.so" "../lib/libfirn_linux_amd64.so"
        echo "📦 Dynamic library copied to: ../lib/libfirn_linux_amd64.so"
        ls -la "../lib/libfirn_linux_amd64.so"
    fi
elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* || "$OSTYPE" == "win"* ]]; then
    # Build for MSVC target to match Windows runners
    cargo build --release --target x86_64-pc-windows-msvc
    TARGET_DIR="target/x86_64-pc-windows-msvc/release"
    cp "${TARGET_DIR}/${LIB_NAME}.lib" "../lib/firn_windows_amd64.lib"
    echo "📦 Static library copied to: ../lib/firn_windows_amd64.lib"
    ls -la "../lib/firn_windows_amd64.lib"
    # 复制动态链接库（.dll）
    if [ -f "${TARGET_DIR}/${LIB_NAME}.dll" ]; then
        cp "${TARGET_DIR}/${LIB_NAME}.dll" "../lib/firn_windows_amd64.dll"
        echo "📦 Dynamic library copied to: ../lib/firn_windows_amd64.dll"
        ls -la "../lib/firn_windows_amd64.dll"
    fi
else
    echo "❌ Unsupported OS: $OSTYPE"
    exit 1
fi

echo "🎉 Build complete!"
