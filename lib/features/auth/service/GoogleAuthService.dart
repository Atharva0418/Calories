import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static const String _androidClientId =
      "596931131874-0aihfcd86lk9eaoa40odkr3ips9i0n0m.apps.googleusercontent.com";

  static const String _webClientId =
      "596931131874-bofsd9pgggjcmsu1pmco1cbp6s7r5mql.apps.googleusercontent.com";

  static const List<String> _scopes = ['openid', 'email', 'profile'];

  static bool _initialized = false;

  static Future<void> _initialize() async {
    if (_initialized) return;
    await GoogleSignIn.instance.initialize(
      clientId: _androidClientId,
      serverClientId: _webClientId,
    );
    _initialized = true;
  }

  static Future<String> getAuthCode() async {
    await _initialize();

    final account = await GoogleSignIn.instance.authenticate();

    final GoogleSignInServerAuthorization? serverAuth = await account
        .authorizationClient
        .authorizeServer(_scopes);

    if (serverAuth == null) {
      throw GoogleAuthException('No serverAuthCode returned');
    }

    return serverAuth.serverAuthCode;
  }

  static Future<void> signOut() async {
    await _initialize();
    await GoogleSignIn.instance.disconnect();
  }
}

class GoogleAuthException implements Exception {
  final String message;
  const GoogleAuthException(this.message);

  @override
  String toString() => 'GoogleAuthException: $message';
}
