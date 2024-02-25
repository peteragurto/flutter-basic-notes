import 'package:flutter/material.dart';
import 'package:intro_flutter/constants/routes.dart';
import 'package:intro_flutter/enums/menu_actions.dart';
import 'package:intro_flutter/services/auth/auth_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

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
                if (shLogOut) {
                  await AuthService.firebase().signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
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

//Función para confirmar logOut
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
