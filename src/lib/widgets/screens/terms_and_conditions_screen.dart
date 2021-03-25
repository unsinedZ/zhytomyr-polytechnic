import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TermsAndCondition extends StatelessWidget {
  final String text;

  TermsAndCondition({required this.text}) : super();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          middle: Text('Terms and conditions'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(text: text),
                  Text(
                    text,
                    style: TextStyle(),
                    textScaleFactor: 1.25,
                    textAlign: TextAlign.justify,
                    //strutStyle: StrutStyle.disabled.,
                    textHeightBehavior: TextHeightBehavior.fromEncoded(2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
