#!/bin/bash

# Script để lấy SHA-1 và SHA-256 fingerprint từ keystore
# Usage: ./scripts/get_sha_fingerprints.sh [keystore_path] [alias] [storepass] [keypass]

set -e

if [ "$#" -eq 4 ]; then
    KEYSTORE=$1
    ALIAS=$2
    STOREPASS=$3
    KEYPASS=$4
else
    echo "Usage: $0 <keystore_path> <alias> <storepass> <keypass>"
    echo ""
    echo "Examples:"
    echo "  # Get SHA from release keystore"
    echo "  $0 /path/to/keystore.jks upload storepass keypass"
    echo ""
    echo "  # Get SHA from debug keystore"
    echo "  $0 ~/.android/debug.keystore androiddebugkey android android"
    exit 1
fi

if [ ! -f "$KEYSTORE" ]; then
    echo "❌ Error: Keystore file not found: $KEYSTORE"
    exit 1
fi

echo "🔑 Getting SHA fingerprints from keystore..."
echo "📁 Keystore: $KEYSTORE"
echo "🏷️  Alias: $ALIAS"
echo ""

# Get SHA-1
SHA1=$(keytool -list -v -keystore "$KEYSTORE" -alias "$ALIAS" -storepass "$STOREPASS" -keypass "$KEYPASS" 2>/dev/null | grep -i "SHA1:" | sed 's/.*SHA1: //' | tr -d ' ')

# Get SHA-256
SHA256=$(keytool -list -v -keystore "$KEYSTORE" -alias "$ALIAS" -storepass "$STOREPASS" -keypass "$KEYPASS" 2>/dev/null | grep -i "SHA256:" | sed 's/.*SHA256: //' | tr -d ' ')

if [ -z "$SHA1" ] || [ -z "$SHA256" ]; then
    echo "❌ Error: Could not extract SHA fingerprints. Please check your keystore path and credentials."
    exit 1
fi

echo "✅ SHA-1:"
echo "   $SHA1"
echo ""
echo "✅ SHA-256:"
echo "   $SHA256"
echo ""
echo "📋 Copy these fingerprints to Firebase Console:"
echo "   1. Go to Firebase Console → Project Settings → Your apps"
echo "   2. Select your Android app"
echo "   3. Scroll to 'SHA certificate fingerprints'"
echo "   4. Click 'Add fingerprint' and add both SHA-1 and SHA-256"
echo "   5. Download the updated google-services.json"
echo ""










