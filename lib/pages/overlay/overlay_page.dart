import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:structogrammar/riverpod/downloads.dart';

class OverlayPage extends ConsumerStatefulWidget {
  const OverlayPage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  ConsumerState createState() => _OverlayPageState();
}

class _OverlayPageState extends ConsumerState<OverlayPage> {
  @override
  Widget build(BuildContext context) {
    var downloadsStream = ref.watch(downloadsPod);
    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          downloadsStream.when(
              data: (downloads) {
                return Positioned(
                    bottom: 0,
                    right: 0,
                    child: Column(
                      children: [
                        for (int i = 0; i < downloads.length; i++)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                                width: 200,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey,
                                    )),
                                child: Column(
                                  children: [
                                    Text(
                                      downloads[i].name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    LinearProgressIndicator(value: downloads[i].progress),
                                  ],
                                )),
                          ),
                      ],
                    ));
              },
              error: (e, s) => const SizedBox(),
              loading: () => const SizedBox()),
        ],
      ),
    );
  }
}
