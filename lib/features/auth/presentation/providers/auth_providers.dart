import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

// Auth service provider
final authServiceProvider = Provider((ref) => AuthService(ref));

class AuthService {
  final Ref _ref;
  AuthService(this._ref);

  AuthRepository get _authRepository => _ref.read(authRepositoryProvider);

  Future<String?> signIn(String email, String password) async {
    try {
      await _authRepository.signInWithEmailAndPassword(email, password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e);
    } catch (e) {
      return 'Une erreur inattendue s\'est produite';
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      await _authRepository.createUserWithEmailAndPassword(email, password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e);
    } catch (e) {
      return 'Une erreur inattendue s\'est produite';
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Aucun utilisateur trouvé avec cet email';
      case 'wrong-password':
        return 'Mot de passe incorrect';
      case 'email-already-in-use':
        return 'Un compte existe déjà avec cet email';
      case 'weak-password':
        return 'Le mot de passe est trop faible';
      case 'invalid-email':
        return 'Email invalide';
      case 'invalid-credential':
        return 'Identifiants invalides';
      case 'configuration-not-found':
        return 'Firebase Authentication n\'est pas configuré. Activez-le dans la console Firebase.';
      default:
        return 'Erreur d\'authentification (${e.code}): ${e.message}';
    }
  }
}
