import 'package:flutter/material.dart';
import 'package:update_form/src/bl/models/activity_name.dart';
import 'package:update_form/src/widgets/screens/update_form_screen.dart';

class ActivityNameTextField extends StatelessWidget {
  final Stream<List<ActivityName>?> namesStream;
  final void Function(TextEditingController) setController;

  ActivityNameTextField({
    required this.namesStream,
    required this.setController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<String>?>(
          stream: namesStream
              .map((names) => names?.map((name) => name.name).toList()),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            return Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return snapshot.data!.where((String name) {
                  return name
                      .toLowerCase()
                      .startsWith(textEditingValue.text.toLowerCase());
                });
              },
              fieldViewBuilder: (_, controller, focusNode, onSubmit) {
                setController(controller);
                return TextFormField(
                  controller: controller,
                  validator: (value) {
                    dynamic error = defaultValidator(value, 'Введіть назву заняття');
                    if(error != null) {
                      return error;
                    }
                    if(!snapshot.data!.contains(value)){
                      return 'Введіть назву зі списку';
                    }
                  },
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelText: "Назва пари",
                  ),
                  onFieldSubmitted: (_) => onSubmit(),
                  focusNode: focusNode,
                );
              },
              onSelected: (_) => null,
            );
          }),
    );
  }
}
