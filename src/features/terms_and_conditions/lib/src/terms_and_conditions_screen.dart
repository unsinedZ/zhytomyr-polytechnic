import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  final Widget Function({required Widget child}) bodyWrapper;

  TermsAndConditionsScreen({required this.bodyWrapper});

  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  String? text;

  @override
  void initState() {
    loadTermsAndConditions().then((str) {
      setState(() {
        text = str;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Terms and conditions',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: widget.bodyWrapper(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (text == null)
                      Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      MarkdownBody(
                        data: text!,
                        selectable: true,
                        onTapLink: (_, uri, ___) async {
                          await launch(uri!);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> loadTermsAndConditions() async {
    return await rootBundle
        .loadString(getAssetPathPrefix() + 'assets/terms_and_conditions.md');
  }
}
