# Build a release APK you can share with others (no USB needed).
# Usage: .\scripts\build_and_share.ps1

$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

Write-Host "Building Nenavi release APK..." -ForegroundColor Cyan
flutter build apk --release

$apk = "build\app\outputs\flutter-apk\app-release.apk"
if (-not (Test-Path $apk)) {
    Write-Error "APK not found at $apk"
}

Write-Host ""
Write-Host "APK ready:" -ForegroundColor Green
Write-Host (Resolve-Path $apk)
Write-Host ""
Write-Host "=== Share via Firebase App Distribution (recommended) ===" -ForegroundColor Yellow
Write-Host ""
Write-Host "One-time setup in Firebase Console:"
Write-Host "  App Distribution -> Testers and Groups -> Add group 'testers'"
Write-Host "  Add tester email addresses (patients, caregivers, etc.)"
Write-Host ""
Write-Host "Upload and notify testers:"
Write-Host "  firebase login"
Write-Host "  firebase appdistribution:distribute `"$apk`" --app 1:205522915457:android:c7349d529c68f854437d80 --groups testers --project nenavi-5230b"
Write-Host ""
Write-Host "Testers receive an email with an install link. They install once, then open Nenavi from their home screen."
Write-Host ""
Write-Host "=== Other options ===" -ForegroundColor Yellow
Write-Host "Google Drive: upload the APK and share the download link (Android only, enable 'Install unknown apps')"
Write-Host "Google Play: use Internal testing in Play Console for a Play Store install link"
