import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final String _androidClientId =
      "${dotenv.env['GOOGLE_OAUTH_ANDROID_CLIENT_ID']}";

  static final String _webClientId =
      "${dotenv.env['GOOGLE_OAUTH_WEB_CLIENT_ID']}";

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
