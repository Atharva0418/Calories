import 'dart:async';
import 'dart:convert';

import 'package:calories/features/auth/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/food_log.dart';

class FoodLogProvider with ChangeNotifier {
  final AuthProvider authProvider;

  FoodLogProvider({required this.authProvider});

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<bool> saveFoodLog(FoodLog foodLog) async {
    try {
      final response = await authProvider.authenticatedRequest((
        accessToken,
      ) async {
        final url = Uri.parse('${dotenv.env['BASE_URL']}/log/addFood');

        final logResponse = await http
            .post(
              url,
              headers: {
                'Content-Type': 'application/json',
                'x-api-key': '${dotenv.env['X_API_KEY']}',
                'Authorization': 'Bearer $accessToken',
              },
              body: jsonEncode(foodLog.toJson()),
            )
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                throw TimeoutException(
                  "Request taking too long. Please try again later.",
                );
              },
            );

        return logResponse;
      });

      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }
}
