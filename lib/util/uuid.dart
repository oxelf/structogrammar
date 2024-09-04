import 'package:uuid/uuid.dart';

String generateUUID() {
  var uuid = Uuid();
  return uuid.v4();
}