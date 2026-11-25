# Glasur-Labor (Android)

Android-App aus dem Artefakt „Glasur-Labor“: eine WebView, die die Seite samt Bibliotheken offline aus `assets/` lädt.

## Aufbau
- `assets/index.html`: die Seite (CDN-Links durch lokale Dateien ersetzt, PDF-Export und Kopieren über die Android-Brücke)
- `assets/glazes.json`: Glasur-Datenbank (900 Einträge)
- `assets/three.min.js` (r128), `assets/jspdf.umd.min.js` (2.5.1), `assets/outfit-*.woff2`: Bibliotheken und Schrift
- `src/ch/glasurlabor/app/MainActivity.java`: WebView, liefert die Assets unter `https://appassets.androidplatform.net/` aus; Brücke `Android.copy()` und `Android.savePdf()` (speichert nach Downloads)
- `AndroidManifest.xml`, `res/`: Manifest, Theme, Icon

## Bauen (Linux, ohne Gradle)
```
./setup-sdk.sh     # einmalig: Android-SDK nach ./android-sdk
./build.sh         # erzeugt Glasur-Labor.apk
```
Ein vorhandenes SDK lässt sich mit `ANDROID_SDK=/pfad ./build.sh` nutzen (braucht build-tools 35.0.0 und platforms;android-35).

## Signatur
`build.sh` signiert mit `glasurlabor.keystore` (Alias und Passwort `glasurlabor`) und legt den Schlüssel an, falls er fehlt.
Updates lassen sich nur über die installierte App spielen, wenn sie mit **demselben** Schlüssel signiert sind: den Keystore aufbewahren. Er ist absichtlich nicht im Git-Repository.

## Seite aktualisieren
Neue Version des Artefakts nach `assets/index.html` übernehmen, dabei die drei Anpassungen beibehalten: lokale Skript-/Schrift-Pfade, `Android.copy` und `Android.savePdf`. Danach `versionCode` im Manifest erhöhen und `./build.sh` ausführen.

## Web-App für iPhone/iPad (`docs/`)
Dieselbe Seite als installierbare Web-App: funktioniert nach dem ersten Öffnen offline (`sw.js`), PDF-Export über das Teilen-Menü.
Wird über GitHub Pages (Branch `main`, Ordner `/docs`) veröffentlicht, in Safari öffnen, „Teilen“ → „Zum Home-Bildschirm“.
Nach Änderungen an Dateien in `docs/` die `VERSION` in `docs/sw.js` erhöhen, damit installierte Apps die neue Fassung laden.
