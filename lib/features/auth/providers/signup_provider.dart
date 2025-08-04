import 'dart:convert';

import 'package:calories/features/auth/models/signup_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SignupProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<bool> signup(SignupRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse('${dotenv.env['BASE_URL']}/api/signup');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': '${dotenv.env['X_API_KEY']}',
            },
            body: jsonEncode({
              'name': request.name,
              'email': request.email,
              'password': request.password,
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 201) {
        return true;
      } else {
        final data = jsonDecode(response.body);
        _errorMessage = data['error'] ?? "Signup Failed";
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
