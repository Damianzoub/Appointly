# Notes


if you want to add more localizations files , add .arb file in lib/l10n and later run 
```bash
flutter clean
flutter pub get
flutter gen-l10n
```

# Running the app 
Is better/faster to insert a usb cable in the laptop and connect it with your phone , so that it runs faster and see it in your phone (in case you don't have android phone use an emulator)

after connecting your phone , do
```bash
flutter devices
```
**What it tells you**
- **Physical phones** (Android/iOS)
- **Emulators/Simulators**
- **Desktop targets**
- Whether the device is **connected and usable**

Example Output:
```bash
3 connected devices:

2201116SG (mobile) • RZ8N123ABC • android-arm64 • Android 14
macOS (desktop)    • macos     • darwin-x64    • macOS 14.3
Chrome (web)       • chrome    • web-javascript
```

When you have one device run
```bash
flutter run
```

When you have many devices run 
```bash 
flutter run -d <device_id>
```

## Check connection with phone if used an usb cable

```bash
adb devices
```
if you seee **unauthorized** -> Look at your phone screen and accept the RSA prompt and also take the previlege of developer in your phone
