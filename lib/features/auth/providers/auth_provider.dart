import 'dart:async';
import 'dart:convert';

import 'package:calories/features/auth/models/login_request.dart';
import 'package:calories/features/auth/models/signup_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  final _secureStorage = FlutterSecureStorage();

  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkLoggedIn() async {
    final refreshToken = _secureStorage.read(key: 'refreshToken');
    if (refreshToken == null) {
      _isAuthenticated = false;
      return;
    }

    final checkRefreshToken = await refreshAccessToken();
    if (checkRefreshToken) {
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
      await _secureStorage.delete(key: 'accessToken');
      await _secureStorage.delete(key: 'refreshToken');
    }

    notifyListeners();
  }

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, String> _fieldErrors = {};

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Map<String, String> get fieldErrors => _fieldErrors;

  Future<bool> signup(SignupRequest signupRequest) async {
    _isLoading = true;
    _errorMessage = null;
    _fieldErrors = {};
    notifyListeners();

    try {
      final url = Uri.parse('${dotenv.env['BASE_URL']}/auth/signup');

      final signupResponse = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': '${dotenv.env['X_API_KEY']}',
            },
            body: jsonEncode({
              'username': signupRequest.username,
              'email': signupRequest.email,
              'password': signupRequest.password,
            }),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException(
                "Request taking too long. Please try again later.",
              );
            },
          );

      if (signupResponse.statusCode == 201) {
        final data = jsonDecode(signupResponse.body);
        await _secureStorage.write(
          key: 'accessToken',
          value: data['accessToken'],
        );
        await _secureStorage.write(
          key: 'refreshToken',
          value: data['refreshToken'],
        );
        return true;
      } else {
        final data = jsonDecode(signupResponse.body);
        if (data is Map<String, dynamic>) {
          _fieldErrors = Map<String, String>.from(data);
        }
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(LoginRequest loginRequest) async {
    _isLoading = true;
    _errorMessage = null;
    _fieldErrors = {};
    notifyListeners();

    try {
      final url = Uri.parse('${dotenv.env['BASE_URL']}/auth/login');

      final loginResponse = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': '${dotenv.env['X_API_KEY']}',
            },
            body: jsonEncode({
              'email': loginRequest.email,
              'password': loginRequest.password,
            }),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException(
                "Request taking too long. Please try again later.",
              );
            },
          );

      if (loginResponse.statusCode == 200) {
        final data = jsonDecode(loginResponse.body);
        await _secureStorage.write(
          key: 'accessToken',
          value: data['accessToken'],
        );
        await _secureStorage.write(
          key: 'refreshToken',
          value: data['refreshToken'],
        );
        return true;
      } else {
        final data = jsonDecode(loginResponse.body);
        if (data is Map<String, dynamic>) {
          _fieldErrors = Map<String, String>.from(data);
        }

        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'accessToken');
  }

  Future<bool> refreshAccessToken() async {
    final refreshToken = await _secureStorage.read(key: 'refreshToken');
    if (refreshToken == null) return false;

    try {
      final url = Uri.parse("${dotenv.env['BASE_URL']}/auth/refresh-token");

      final refreshResponse = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': '${dotenv.env['X_API_KEY']}',
        },
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      if (refreshResponse.statusCode == 200) {
        final data = jsonDecode(refreshResponse.body);
        await _secureStorage.write(
          key: 'accessToken',
          value: data['accessToken'],
        );
        await _secureStorage.write(
          key: 'refreshToken',
          value: data['refreshToken'],
        );
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<http.Response> authenticatedRequest(
    Future<http.Response> Function(String token) requestFn,
  ) async {
    String? accessToken = await getAccessToken();

    http.Response response = await requestFn(accessToken!);

    if (response.statusCode == 401) {
      final refresh = await refreshAccessToken();
      if (refresh) {
        accessToken = await getAccessToken();
        response = await requestFn(accessToken!);
      } else {
        await logout();
        notifyListeners();
      }
    }

    return response;
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'accessToken');
    await _secureStorage.delete(key: 'refreshToken');
    _isAuthenticated = false;
    notifyListeners();
  }
}
