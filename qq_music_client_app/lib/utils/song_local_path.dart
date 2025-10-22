import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:qq_music_client_app/utils/toast.dart';

class LocalSongUtils {
  static String externalStorageDirectoryPath = "";

  static Future<void> init() async {
    Completer<void> completer = Completer();
    getExternalStorageDirectory().then((dir) {
      externalStorageDirectoryPath = dir!.path;
      completer.complete();
    }).catchError((e) {
      toastError(e);
    });
    return completer.future;
  }

  static Future<String> getSongCachePath(url) {
    Completer<String> completer = Completer();
    getExternalStorageDirectory().then((dir) {
      String name = Uri.decodeComponent(basename(url));
      String path = dir!.path + Platform.pathSeparator + name;
      completer.complete(path);
    });
    return completer.future;
  }

  static Future<String> getSongWaveCachePath(url) {
    Completer<String> completer = Completer();
    getExternalStorageDirectory().then((dir) {
      String name = Uri.decodeComponent(basename(setExtension(url, ".wave")));
      String path = dir!.path + Platform.pathSeparator + name;
      completer.complete(path);
    });
    return completer.future;
  }

  static Future<String> getSongLyricCachePath(url) {
    Completer<String> completer = Completer();
    getExternalStorageDirectory().then((dir) {
      String name = Uri.decodeComponent(basename(setExtension(url, ".lrc")));
      String path = dir!.path + Platform.pathSeparator + name;
      completer.complete(path);
    });
    return completer.future;
  }

  static String getSongCoverCachePathSync(url) {
    if (externalStorageDirectoryPath.isEmpty) {
      return url;
    }
    String name = Uri.decodeComponent(basename(setExtension(url, ".jpg")));
    return externalStorageDirectoryPath + Platform.pathSeparator + name;
  }
}