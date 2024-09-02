@echo off

:: Set variables
set APP_NAME=expense_tracker
set VERSION=0.0.6-alpha
set TYPE=signed
set OUTPUT_DIR=..\expense_tracker\build\app\outputs\flutter-apk\

:: Rename APKs
rename "%OUTPUT_DIR%app-armeabi-v7a-release.apk" "%APP_NAME%_%VERSION%_%TYPE%_armeabi-v7a.apk"
rename "%OUTPUT_DIR%app-arm64-v8a-release.apk" "%APP_NAME%_%VERSION%_%TYPE%_arm64-v8a.apk"
rename "%OUTPUT_DIR%app-x86_64-release.apk" "%APP_NAME%_%VERSION%_%TYPE%_x86_64.apk"

echo APKs have been renamed successfully.
pause
