import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intro_flutter/firebase_options.dart';
import 'package:intro_flutter/views/login_view.dart';
import 'package:intro_flutter/views/register_view.dart';
import 'package:intro_flutter/views/verify_emailview.dart';
import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: "Flutter Demo",
    theme: ThemeData(primaryColor: Colors.amber),
    home: const HomePage(),
    routes: {
      "/login/": (context) => const LoginView(),
      "/register/": (context) => const RegisterView(),
      "/notes/": (context) => const NotesView()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              // Forzar la actualización de la información del usuario
              if (user.emailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          /*if (user?.emailVerified ?? false) {
                return const Text("Listo");
              } else {
                return const VerifyEmailView();
              }*/
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

enum MenuAction { logout }

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UI Principal"),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shLogOut = await showLogoutDialog(context);
                devtools.log(shLogOut.toString());
                if (shLogOut) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login/',
                    (route) => false,
                  );
                }
                break;
              default:
            }
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                  value: MenuAction.logout, child: Text("Cerrar sesión"))
            ];
          })
        ],
      ),
      body: const Text("Hola mundo"),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cerrando sesión"),
          content: const Text("Seguro que quieres cerrar sesión"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancelar")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Cerrar sesión"))
          ],
        );
      }).then((value) => value ?? false);
}
