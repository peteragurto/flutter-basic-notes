import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intro_flutter/firebase_options.dart';
import 'package:intro_flutter/views/login_view.dart';
import 'package:intro_flutter/views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: "Flutter Demo",
    theme: ThemeData(primaryColor: Colors.amber),
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Home Page"),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              /*final user = FirebaseAuth.instance.currentUser;
              if (user?.emailVerified ?? false) {
                return const Text("Listo");
              } else {
                return const VerifyEmailView();
              }*/
              return const LoginView();
            default:
              return const Text("Cargando");
          }
        },
      ),
    );
  }
}

//Widget de verificacion de email
class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Por favor, verifica tu email"),
        TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text("Enviar verificación de email"))
      ],
    );
  }
}
