import "package:intro_flutter/services/auth/auth_exceptions.dart";
import "package:intro_flutter/services/auth/auth_provider.dart";
import "package:intro_flutter/services/auth/auth_user.dart";
import "package:test/test.dart";

void main() {
  group("Mock Authentication -", () {
    final provider = MockAuthProvider();
    test("Should not be initialized to begin with", () {
      expect(provider.isInitialized, false);
    });

    test("NO hacer singOut si no esta inicializado", () {
      expect(
        provider.signOut(),
        throwsA(const TypeMatcher<IsNotInitializedException>()),
      );
    });

    test("Deberia estar disponible para iniciar", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test("Usuario deberia ser nulo, despues de iniciación", () {
      expect(provider.currentUser, null);
    });

    test(
      "Deberia iniciar en menos de 2 seg.",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test("Crear usuario deberia delegar a login", () async {
      final badEmailUser = provider.createUser(
          email: "pedroagurto@gmail.com", password: "12345");
      expect(
        badEmailUser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );

      final badPassUser = provider.createUser(
          email: "peteragurto@gmail.com", password: "trululu");
      expect(
        badPassUser,
        throwsA(const TypeMatcher<WrongPasswordAuthException>()),
      );

      final user = await provider.createUser(
        email: "peter",
        password: "1234",
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test("Usuario loggeado deberia poder verificarse", () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("Deberia poder signOut y logIn, otra vez", () async {
      await provider.signOut();
      await provider.logIn(
        email: "email",
        password: "password",
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class IsNotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw IsNotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw IsNotInitializedException();
    if (email == "pedroagurto@gmail.com") throw UserNotFoundAuthException();
    if (password == "trululu") throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw IsNotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }

  @override
  Future<void> signOut() async {
    if (!isInitialized) throw IsNotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }
}
