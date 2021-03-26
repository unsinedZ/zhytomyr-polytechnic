import 'package:faculty_list/faculty_list.dart';
import 'package:flutter/material.dart';
import 'package:zhytomyr_polytechnic/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  runApp(App());
}
