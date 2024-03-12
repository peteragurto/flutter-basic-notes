import 'package:flutter/material.dart';
import 'package:intro_flutter/constants/routes.dart';
import 'package:intro_flutter/enums/menu_actions.dart';
import 'package:intro_flutter/services/auth/auth_service.dart';
import 'package:intro_flutter/services/crud/notes_service.dart';
import 'package:intro_flutter/utilities/dialogs/logout_dialog.dart';
import 'package:intro_flutter/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mis Notas"),
          backgroundColor: Colors.amber,
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(newNoteRoute);
              },
              icon: const Icon(Icons.add),
            ),
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shLogOut = await showLogOutDialog(context);
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
        body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final allNotes = snapshot.data as List<DatabaseNote>;
                          debugPrint("${allNotes.toList()}");
                          return NotesListView(
                            notes: allNotes,
                            onDeleteNote: (note) async {
                              _notesService.deleteNote(id: note.id);
                            },
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      /**/
                      default:
                        return const CircularProgressIndicator();
                    }
                  },
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
