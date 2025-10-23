# qq_music_client_app

QQMusic Automotive Client

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## 打包
```shell
flutter build apk --flavor prod --dart-define=API_HOST={Server IP Address}
```

## Android Studio Debug
run args 添加:  --dart-define=API_HOST={Server IP Address}
Build flavor:  dev

<br/>

或 api_config.dart 修改服务器 IP