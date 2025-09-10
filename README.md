## flutter_realm

Flutter (Android · iOS · macOS · Web) sample using MongoDB Realm for local persistence with a reactive list/add/delete example.

### Features
- **Realm local database**: simple `Item` model with `ObjectId` primary key and `name` field.
- **Reactive UI**: `RealmResults<Item>.changes` streamed into a `StreamBuilder` for live updates.
- **CRUD basics**: add items by name, delete via button or swipe.
- **Multi-platform**: Android, iOS, macOS, Web.

### Tech stack
- **Flutter**: Material 3 UI
- **MongoDB Realm (Dart SDK)**: `realm`, `realm_generator` for model codegen
- **Dart null safety**

### Project structure
```text
lib/
  main.dart                 # UI + Realm setup (Configuration.local, StreamBuilder)
  models/
    item.dart               # @RealmModel with ObjectId id, name
    item.realm.dart         # Generated (do not edit)
```

### Getting started
Prerequisites: Flutter SDK; for macOS/iOS builds install Xcode and CocoaPods.

```bash
flutter pub get
dart run realm generate
```

Run on a device:
```bash
# macOS
flutter config --enable-macos-desktop
cd macos && pod install && cd ..
flutter run -d macos

# Web
flutter run -d chrome

# iOS (simulator)
flutter run -d ios

# Android (emulator/device)
flutter run -d android
```

### How it works
- Defines an `Item` Realm model (`lib/models/item.dart`) and generates types with:
```bash
dart run realm generate
```
- Opens a local Realm: `Configuration.local([Item.schema])`
- Observes `items.changes` for reactive updates
- Writes data in transactions: `realm.write(() { ... })`

### Troubleshooting (macOS)
If you see a dylib error like “Library not loaded: @rpath/librealm_dart.dylib”:
```bash
flutter clean
flutter pub get
cd macos && pod install && cd ..
flutter build macos
flutter run -d macos

# Verify the library exists after build
find build/macos/Build/Products/Debug/flutter_realm.app -name librealm_dart.dylib
```

### Commands you’ll use most
```bash
# Refresh deps & regenerate models after changing @RealmModel classes
flutter pub get
dart run realm generate

# Run on your preferred device
flutter devices
flutter run -d <device_id>
```

### Next steps
- Add fields and relationships to the `Item` model
- Try queries (`realm.query<Item>(...)`) and sorting
- Explore sync with Atlas App Services when ready

References: [Flutter docs](https://docs.flutter.dev/), [Realm Dart on pub.dev](https://pub.dev/packages/realm)
