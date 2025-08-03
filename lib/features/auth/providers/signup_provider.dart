import 'package:calories/features/auth/models/signup_request.dart';
import 'package:flutter/cupertino.dart';

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
      await Future.delayed(const Duration(seconds: 2));
      //TODO: API

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
