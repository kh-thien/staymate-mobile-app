#!/bin/bash

# Script to create debug symbols zip for Google Play Console
# Usage: ./scripts/create_debug_symbols.sh

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔍 Tìm thư mục debug symbols...${NC}"

# Find the debug symbols directory
DEBUG_SYMBOLS_DIR="build/app/intermediates/merged_native_libs/release/mergeReleaseNativeLibs/out"

if [ ! -d "$DEBUG_SYMBOLS_DIR/lib" ]; then
    echo -e "${RED}❌ Không tìm thấy thư mục lib trong $DEBUG_SYMBOLS_DIR${NC}"
    echo -e "${YELLOW}💡 Hãy chạy: flutter build appbundle --release${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Tìm thấy thư mục debug symbols${NC}"

# Navigate to the debug symbols directory
cd "$DEBUG_SYMBOLS_DIR"

echo -e "${YELLOW}🧹 Đang xóa các file .DS_Store...${NC}"

# Remove all .DS_Store files
find lib -name ".DS_Store" -type f -delete 2>/dev/null || true
find lib -name "._*" -type f -delete 2>/dev/null || true

echo -e "${GREEN}✅ Đã xóa các file .DS_Store${NC}"

# Create output directory if it doesn't exist
OUTPUT_DIR="$HOME/Desktop"
OUTPUT_FILE="$OUTPUT_DIR/debug_symbols.zip"

# Remove old zip file if exists
if [ -f "$OUTPUT_FILE" ]; then
    echo -e "${YELLOW}🗑️  Đang xóa file zip cũ...${NC}"
    rm -f "$OUTPUT_FILE"
fi

echo -e "${YELLOW}📦 Đang tạo file zip...${NC}"

# Navigate to lib directory to zip ABI folders directly (without lib/ prefix)
cd lib

# Create zip file with correct structure (ABI folders at root, not inside lib/)
zip -r "$OUTPUT_FILE" armeabi-v7a arm64-v8a x86 x86_64 \
    -x "*.DS_Store" \
    -x "*/.DS_Store" \
    -x "*/._*" \
    -x "*__MACOSX*" \
    > /dev/null

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Đã tạo file zip thành công!${NC}"
    echo -e "${GREEN}📁 File: $OUTPUT_FILE${NC}"
    
    # Show file size
    FILE_SIZE=$(ls -lh "$OUTPUT_FILE" | awk '{print $5}')
    echo -e "${GREEN}📊 Kích thước: $FILE_SIZE${NC}"
    
    # Show zip contents
    echo -e "${YELLOW}📋 Nội dung file zip:${NC}"
    unzip -l "$OUTPUT_FILE" | head -20
    
    echo -e "${GREEN}🎉 Hoàn thành! File sẵn sàng upload lên Google Play Console.${NC}"
else
    echo -e "${RED}❌ Lỗi khi tạo file zip${NC}"
    exit 1
fi
