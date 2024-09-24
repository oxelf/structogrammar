import 'package:flutter/material.dart';
import 'package:structogrammar/context_extension.dart';
import 'package:structogrammar/util/app_colors.dart';
import 'package:structogrammar/util/check_updates.dart';
import 'package:url_launcher/url_launcher_string.dart';

bool hasCheckedUpdate = false;

class UpdaterWidget extends StatefulWidget {
  const UpdaterWidget({super.key});

  @override
  State<UpdaterWidget> createState() => _UpdaterWidgetState();
}

class _UpdaterWidgetState extends State<UpdaterWidget> {
  String? updateUrl;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (hasCheckedUpdate) return;
      updateUrl = await checkForUpdates();
      hasCheckedUpdate = true;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return updateUrl != null
        ? LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.borderColor),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(context.l.newVersionAvailable, style: TextStyle(fontWeight: FontWeight.bold),),
                      TextButton(onPressed: () {
                        launchUrlString(updateUrl ?? "https://github.com/oxelf/structogrammar/releases");
                      }, child:  Text(context.l.downloadNow, style: TextStyle(fontSize: 16, color: Colors.blue),),),
                    ],
                  ),
                ),
              );
          }
        )
        : SizedBox();
  }
}
