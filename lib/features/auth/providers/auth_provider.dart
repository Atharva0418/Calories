import 'dart:async';
import 'dart:convert';

import 'package:calories/features/auth/models/login_request.dart';
import 'package:calories/features/auth/models/signup_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
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
      final url = Uri.parse('${dotenv.env['BASE_URL']}/api/signup');

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
            const Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException(
                "Request taking too long. Please try again later.",
              );
            },
          );

      if (signupResponse.statusCode == 201) {
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
      final url = Uri.parse('${dotenv.env['BASE_URL']}/api/login');

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
            const Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException(
                "Request taking too long. Please try again later.",
              );
            },
          );

      if (loginResponse.statusCode == 200) {
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
}
