#!/bin/bash
# Baut Glasur-Labor.apk ohne Gradle. ANDROID_SDK muss build-tools 35.0.0 und platforms;android-35 enthalten.
set -e
SDK=${ANDROID_SDK:-${ANDROID_HOME:-$(cd "$(dirname "$0")" && pwd)/android-sdk}}; BT=$SDK/build-tools/35.0.0; AJ=$SDK/platforms/android-35/android.jar
cd "$(dirname "$0")"; rm -rf build; mkdir -p build/classes build/dex
$BT/aapt2 compile --dir res -o build/res.zip
$BT/aapt2 link -I $AJ --manifest AndroidManifest.xml -A assets -o build/base.apk build/res.zip --java build/gen --min-sdk-version 26 --target-sdk-version 35
javac -source 8 -target 8 -bootclasspath $AJ -classpath $AJ -d build/classes -sourcepath src:build/gen $(find src build/gen -name '*.java') 2>&1 | grep -v 'warning' || true
$BT/d8 --min-api 26 --lib $AJ --output build/dex $(find build/classes -name '*.class')
cp build/base.apk build/unsigned.apk; (cd build/dex && zip -q ../unsigned.apk classes.dex)
$BT/zipalign -f -p 4 build/unsigned.apk build/aligned.apk
[ -f glasurlabor.keystore ] || keytool -genkeypair -keystore glasurlabor.keystore -storepass glasurlabor -keypass glasurlabor -alias glasurlabor -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Glasur-Labor" >/dev/null 2>&1
$BT/apksigner sign --ks glasurlabor.keystore --ks-pass pass:glasurlabor --key-pass pass:glasurlabor --out Glasur-Labor.apk build/aligned.apk
$BT/apksigner verify Glasur-Labor.apk && ls -la Glasur-Labor.apk
