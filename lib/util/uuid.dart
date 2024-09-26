import 'package:uuid/uuid.dart';

String generateUUID() {
  var uuid = const Uuid();
  return uuid.v4();
}