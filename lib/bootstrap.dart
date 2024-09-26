import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/main.dart';
import 'package:structogrammar/managers/structs_manager.dart';
import 'package:structogrammar/riverpod/managers.dart';
import 'package:structogrammar/riverpod/structs.dart';

import 'managers/download_manager.dart';

Future<ProviderContainer> appBootstrap() async {
   WidgetsFlutterBinding.ensureInitialized();
  // Cache images in assets folder via using the Flutter Engine binding
  // lifecycle.
  // binding.deferFirstFrame();
  // binding.addPostFrameCallback((_) {
  //   final Element? context = binding.rootElement;
  //   if (context != null) {
  //     for (final asset in assetList) {
  //       precacheImage(
  //         AssetImage(asset),
  //         context,
  //       );
  //     }
  //   }
  //   binding.allowFirstFrame();
  // });

  final container = ProviderContainer(
    // only for Flutter, dart apps require listening to container to get changes as
    // ProviderObserver plugs into the widget lifecycle.
    observers: [_Logger()],
  );

  await appInitProviders(container);

  return container;
}

Future<void> appInitProviders(ProviderContainer container) async {
  StructsManager manager = await container.read(structManagerPod.future);
  int highest = await manager.getHighestId();
  StructsId.id = highest;
  print("highest: $highest");
  globalStructManager = manager;

  DownloadManager downloadsManager =
      await container.read(downloadManagerPod.future);
  downloadsManager.init();
}

class _Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<dynamic> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    // observability wise we do not want provider log messages in
    // production thus denugPrint is used as it is stripped out in release mode
    debugPrint(
      '''
      {
      "provider": "${provider.name ?? provider.runtimeType}",
      "newValue": "$newValue"
      }''',
    );
  }
}
