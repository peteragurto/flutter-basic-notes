import 'package:flutter/material.dart';
import 'package:intro_flutter/services/auth/auth_service.dart';
import 'package:intro_flutter/services/crud/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NotesService _noteservice;
  late final TextEditingController _textController;

  @override
  void initState() {
    _noteservice = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  Future<DatabaseNote> createNoteInView() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser;
    debugPrint("Usuario actual: $currentUser");
    if (currentUser == null) {
      return Future.error("No hay usuario actual");
    }

    final email = currentUser.email;
    debugPrint("Correo electrónico: $email");
    if (email == null) {
      return Future.error("El usuario no tiene correo electrónico");
    }

    final owner = await _noteservice.getUser(email: email);
    debugPrint("Propietario: $owner");

    final nNote = await _noteservice.createNote(owner: owner);
    debugPrint("Nota: $nNote");
    return nNote;
  }

  void _deleteNoteIfIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _noteservice.deleteNote(id: note.id);
    }
  }

  void _saveNotIfIsNotEmpty() async {
    final note = _note;
    if (_textController.text.isNotEmpty && note != null) {
      await _noteservice.updateNote(
        note: note,
        text: _textController.text,
      );
    }
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _noteservice.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void dispose() {
    _deleteNoteIfIsEmpty();
    _saveNotIfIsNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Añadir nueva nota"),
          backgroundColor: Colors.amber,
        ),
        body: FutureBuilder(
            future: createNoteInView(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    final note = snapshot.data as DatabaseNote;
                    _note = note;
                    _setupTextControllerListener();
                    return TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration:
                          const InputDecoration(hintText: "Escribe tu nota"),
                    );
                  } else {
                    return const Text("Error: No se pudo crear la nota");
                  }
                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}
