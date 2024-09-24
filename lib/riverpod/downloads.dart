import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/riverpod/managers.dart';

final downloadsPod = StreamProvider((ref) async* {
  final manager = await ref.watch(downloadManagerPod.future);
  yield* manager.watchDownloads();
});
