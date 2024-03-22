import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_flutter/constants/routes.dart';
import 'package:intro_flutter/helpers/loading/loading_screen.dart';
import 'package:intro_flutter/services/auth/bloc/auth_bloc.dart';
import 'package:intro_flutter/services/auth/bloc/auth_event.dart';
import 'package:intro_flutter/services/auth/bloc/auth_state.dart';
import 'package:intro_flutter/services/auth/firebase_auth_provider.dart';
import 'package:intro_flutter/views/forgot_password_view.dart';
import 'package:intro_flutter/views/login_view.dart';
import 'package:intro_flutter/views/notes/create_update_note_view.dart';
import 'package:intro_flutter/views/notes/notes_view.dart';
import 'package:intro_flutter/views/register_view.dart';
import 'package:intro_flutter/views/verify_emailview.dart';
//import 'dart:developer' as devtools show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor:
        Colors.amber[50], // Cambia el color de la barra de botones
  ));
  runApp(
    MaterialApp(
      title: 'Flutter Notas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Espera un momento',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
