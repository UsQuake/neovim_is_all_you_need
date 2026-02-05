#!/bin/bash
set -e # 에러 발생 시 즉시 종료

# ==========================================
# Configuration
# ==========================================
CODELLDB_VERSION="v1.10.0" # 안정성이 확인된 버전 (필요시 변경)
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/codelldb"
TEMP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/codelldb_temp_download"

echo "=========================================="
echo " 🛠️  CodeLLDB Installer for Neovim"
echo "=========================================="

# ==========================================
# 1. Detect OS & Architecture
# ==========================================
OS="$(uname -s)"
ARCH="$(uname -m)"
PLATFORM_OS=""
PLATFORM_ARCH=""

# OS Detection
case "$OS" in
    Linux*)     PLATFORM_OS="linux";;
    Darwin*)    PLATFORM_OS="darwin";;
    *)          echo "❌ Unsupported OS: $OS"; exit 1;;
esac

# Architecture Detection
case "$ARCH" in
    x86_64)          PLATFORM_ARCH="x86_64";;
    aarch64|arm64)   PLATFORM_ARCH="aarch64";;
    *)               echo "❌ Unsupported Architecture: $ARCH"; exit 1;;
esac

echo "✅ System Detected: $PLATFORM_OS ($PLATFORM_ARCH)"

# ==========================================
# 2. Check Dependencies (unzip, curl/wget)
# ==========================================
if ! command -v unzip &> /dev/null; then
    echo "❌ Error: 'unzip' is required but not installed."
    echo "   -> sudo apt install unzip (Ubuntu/Debian)"
    echo "   -> sudo pacman -S unzip (Arch)"
    exit 1
fi

DOWNLOADER=""
if command -v curl &> /dev/null; then
    DOWNLOADER="curl"
elif command -v wget &> /dev/null; then
    DOWNLOADER="wget"
else
    echo "❌ Error: Neither 'curl' nor 'wget' found."
    exit 1
fi

# ==========================================
# 3. Construct Download URL
# ==========================================
FILE_NAME="codelldb-${PLATFORM_ARCH}-${PLATFORM_OS}.vsix"
DOWNLOAD_URL="https://github.com/vadimcn/codelldb/releases/download/${CODELLDB_VERSION}/${FILE_NAME}"

echo "🔗 Target URL: $DOWNLOAD_URL"

# ==========================================
# 4. Download & Install
# ==========================================

# Clean previous installation
if [ -d "$INSTALL_DIR" ]; then
    echo "🗑️  Removing existing installation..."
    rm -rf "$INSTALL_DIR"
fi
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

echo "⬇️  Downloading with $DOWNLOADER..."
if [ "$DOWNLOADER" = "curl" ]; then
    curl -L -o "$TEMP_DIR/$FILE_NAME" "$DOWNLOAD_URL"
else
    wget -O "$TEMP_DIR/$FILE_NAME" "$DOWNLOAD_URL"
fi

echo "📦 Extracting..."
# .vsix는 zip 파일임. extension 폴더만 압축 해제
unzip -q "$TEMP_DIR/$FILE_NAME" "extension/*" -d "$TEMP_DIR"

# 최종 경로로 이동
mv "$TEMP_DIR/extension" "$INSTALL_DIR"

# 임시 파일 삭제
rm -rf "$TEMP_DIR"

# ==========================================
# 5. Fix Permissions (Execution bit)
# ==========================================
echo "🔧 Setting permissions..."
chmod +x "$INSTALL_DIR/adapter/codelldb"
if [ -f "$INSTALL_DIR/lldb/bin/lldb" ]; then
    chmod +x "$INSTALL_DIR/lldb/bin/lldb" # Some versions have internal lldb
fi

# Linux의 경우 liblldb.so 라이브러리 경로 문제 해결을 위한 힌트 출력
if [ "$PLATFORM_OS" == "linux" ]; then
    echo "ℹ️  [Linux Note] If dap fails, ensure liblldb.so dependencies are met."
fi

echo "=========================================="
echo "✅ CodeLLDB Installed Successfully!"
echo "📍 Location: $INSTALL_DIR"
echo "=========================================="
