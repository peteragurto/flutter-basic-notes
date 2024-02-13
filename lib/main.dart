import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "Flutter Demo",
    theme: ThemeData(primarySwatch: Colors.green),
    home: const HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Registro"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: "Introduce tu email"),
          ),
          TextField(
            controller: _password,
            decoration:
                const InputDecoration(hintText: "Introduce tu contraseña"),
          ),
          TextButton(
            onPressed: () async {},
            child: const Text("Registrarse"),
          ),
        ],
      ),
    );
  }
}
