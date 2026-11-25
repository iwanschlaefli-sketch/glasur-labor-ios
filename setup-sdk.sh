#!/bin/bash
# Lädt die nötigen Android-SDK-Teile nach ./android-sdk (einmalig, ca. 300 MB). Braucht Java 17+.
set -e
cd "$(dirname "$0")"; SDK=$PWD/android-sdk; mkdir -p "$SDK"
if [ ! -x "$SDK/cmdline-tools/latest/bin/sdkmanager" ]; then
  curl -sSLo /tmp/cmdtools.zip https://dl.google.com/android/repository/commandlinetools-linux-13114758_latest.zip
  rm -rf "$SDK/cmdline-tools"; mkdir -p "$SDK/cmdline-tools"; unzip -q /tmp/cmdtools.zip -d "$SDK/cmdline-tools"
  mv "$SDK/cmdline-tools/cmdline-tools" "$SDK/cmdline-tools/latest"
fi
yes | "$SDK/cmdline-tools/latest/bin/sdkmanager" --sdk_root="$SDK" "platforms;android-35" "build-tools;35.0.0" >/dev/null
echo "SDK bereit in $SDK"
