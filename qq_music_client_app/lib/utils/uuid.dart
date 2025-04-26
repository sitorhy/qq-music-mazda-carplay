import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

const Uuid uuid = Uuid();

String generateModelRenderUuid(String id) {
  if (kDebugMode) {
    return uuid.v4();
  }
  return id;
}