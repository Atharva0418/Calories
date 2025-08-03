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

  Future<void> signup(SignupRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = Uri.parse('${dotenv.env['BASE_URL']}/api/signup');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': request.name,
          'email': request.email,
          'password': request.password,
        }),
      );

      if (response.statusCode == 200) {
        print("Signup successful");
      } else {
        final data = jsonDecode(response.body);
        _errorMessage = data['error'] ?? "Signup Failed";
      }
      if (request.email == 'fail@example.com') {
        throw Exception('Signup failed.');
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
