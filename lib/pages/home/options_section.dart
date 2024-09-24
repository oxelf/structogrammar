import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:structogrammar/context_extension.dart';
import 'package:structogrammar/util/app_colors.dart';
import 'package:structogrammar/widgets/updater.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OptionsSubSection extends StatefulWidget {
  const OptionsSubSection({
    super.key,
    required this.onTap,
    required this.child,
    this.icon,
    this.suffix,
    this.bottomBorder = true,
  });

  final Function() onTap;
  final Widget child;
  final Widget? icon;
  final Widget? suffix;
  final bool bottomBorder;

  @override
  State<OptionsSubSection> createState() => _OptionsSubSectionState();
}

class _OptionsSubSectionState extends State<OptionsSubSection> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onHover: (_) {
          setState(() {
            hovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            hovered = false;
          });
        },
        child: Container(
          decoration: BoxDecoration(
              color: hovered ? AppColors.editorBackground : Colors.transparent,
              border: Border(
                top: !widget.bottomBorder
                    ? BorderSide(color: AppColors.borderColor)
                    : BorderSide(color: Colors.transparent),
                bottom: widget.bottomBorder
                    ? BorderSide(color: AppColors.borderColor)
                    : BorderSide(color: Colors.transparent),
              )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.icon ??
                    SizedBox(
                      width: 8,
                    ),
                widget.child,
                widget.suffix ??
                    SizedBox(
                      width: 8,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OptionsSection extends ConsumerStatefulWidget {
  const OptionsSection({super.key});

  @override
  ConsumerState createState() => _OptionsSectionState();
}

class _OptionsSectionState extends ConsumerState<OptionsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: context.height,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              UpdaterWidget(),
              OptionsSubSection(
                onTap: () {
                  launchUrlString("http://github.com/oxelf/structogrammar");
                },
                icon: Icon(FontAwesomeIcons.github),
                child: Text(context.l.giveUsAStar),
                suffix: Icon(
                  Icons.open_in_new,
                  size: 16,
                ),
              ),
              OptionsSubSection(
                onTap: () {
                  launchUrlString("https://github.com/oxelf/structogrammar/issues");
                },
                icon: Icon(Icons.report_problem_outlined),
                child: Text(context.l.reportAnIssue),
                suffix: Icon(
                  Icons.open_in_new,
                  size: 16,
                ),
              ),
            ],
          ),
          Column(
            children: [
              OptionsSubSection(
                  onTap: () {},
                  icon: Icon(Icons.settings_outlined),
                  bottomBorder: false,
                  child: Text(
                    context.l.settings,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          )
          // Container(
          //   decoration: BoxDecoration(
          //       border: Border(
          //     bottom: BorderSide(color: Colors.grey),
          //   )),
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         Icon(
          //           FontAwesomeIcons.github,
          //         ),
          //         Text("Give ous a star"),
          //         Icon(
          //           Icons.open_in_new,
          //           size: 16,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Column(
          //   children: [
          //     Container(
          //       decoration: BoxDecoration(
          //           border: Border(
          //         top: BorderSide(color: Colors.grey),
          //       )),
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Row(
          //           children: [
          //             Icon(
          //               Icons.settings_outlined,
          //             ),
          //             SizedBox(
          //               width: 16,
          //             ),
          //             Text(
          //               "Settings",
          //               style: TextStyle(fontWeight: FontWeight.bold),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
