import 'package:flutter/material.dart';

class UpdateFormScreen extends StatefulWidget {
  const UpdateFormScreen({ Key? key }) : super(key: key);

  @override
  _UpdateFormScreenState createState() => _UpdateFormScreenState();
}

class _UpdateFormScreenState extends State<UpdateFormScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Text("Hay ho"),
        ),
      ),
    );
  }
}