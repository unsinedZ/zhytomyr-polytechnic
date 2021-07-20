import 'package:flutter/material.dart';

class UpdateFormScreen extends StatefulWidget {
  const UpdateFormScreen({Key? key}) : super(key: key);

  @override
  _UpdateFormScreenState createState() => _UpdateFormScreenState();
}

class _UpdateFormScreenState extends State<UpdateFormScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TextFormField(
              maxLength: 10,
              // controller: totalSumController,
              // onFieldSubmitted: (_) => _bonusesFieldFocusNode.requestFocus(),
              keyboardType: TextInputType.number,
              // validator: (_) =>
              //     ModelValidatorService.total(totalSumController.text),
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                suffixIcon: Icon(Icons.monetization_on_outlined),
                labelText: "Назва пари",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
