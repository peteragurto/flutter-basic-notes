// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_flutter/constants/routes.dart';
import 'package:intro_flutter/enums/menu_actions.dart';
import 'package:intro_flutter/services/auth/auth_service.dart';
import 'package:intro_flutter/services/auth/bloc/auth_bloc.dart';
import 'package:intro_flutter/services/auth/bloc/auth_event.dart';
import 'package:intro_flutter/services/cloud/cloud_note.dart';
import 'package:intro_flutter/services/cloud/firebase_cloud_storage.dart';
import 'package:intro_flutter/utilities/dialogs/logout_dialog.dart';
import 'package:intro_flutter/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[50],
        appBar: AppBar(
          title: const Row(
            children: [
              Text(
                'Tus Notas ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
              Icon(Icons.notes_outlined)
            ],
          ),
          backgroundColor: Colors.amber,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.note_add_outlined),
            ),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogOutDialog(context);
                    if (shouldLogout) {
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                    }
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Cerrar sesión'),
                  ),
                ];
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: NotesListView(
                      notes: allNotes,
                      onDeleteNote: (note) async {
                        await _notesService.deleteNote(
                            documentId: note.documentId);
                      },
                      onTap: (note) {
                        Navigator.of(context).pushNamed(
                          createOrUpdateNoteRoute,
                          arguments: note,
                        );
                      },
                    ),
                  );
                } else {
                  return const Scaffold();
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
