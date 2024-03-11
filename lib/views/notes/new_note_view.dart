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
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _noteservice.getUser(email: email);

    return await _noteservice.createNote(owner: owner);
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
      body: const Text("Escribe tu nueva nota"),
    );
  }
}
