import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import 'code_block.dart';

class StepScaffold extends StatefulWidget {
  final List<String> tutorial;
  final Widget game;

  const StepScaffold({
    super.key,
    required this.tutorial,
    required this.game,
  });

  @override
  State<StepScaffold> createState() => _StepScaffoldState();
}

class _StepScaffoldState extends State<StepScaffold> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tutorial'),
              Tab(text: 'Running example'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: SingleChildScrollView(
                child: Column(
                  children: widget.tutorial.map(
                    (text) {
                      if (text.startsWith('```')) {
                        return CodeBlock(value: text);
                      } else {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: MarkdownBody(
                            data: text,
                            selectable: true,
                            extensionSet: md.ExtensionSet(
                              md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                              [
                                md.EmojiSyntax(),
                                ...md
                                    .ExtensionSet.gitHubFlavored.inlineSyntaxes,
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ).toList(),
                ),
              ),
            ),
            widget.game,
          ],
        ),
      ),
    );
  }
}
