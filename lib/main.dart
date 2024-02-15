import 'package:flutter/material.dart';
import 'package:intro_flutter/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: "Flutter Demo",
    theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
    home: const RegisterView(),
  ));
}
