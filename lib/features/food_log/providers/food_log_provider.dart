import 'dart:async';
import 'dart:convert';

import 'package:calories/features/auth/providers/auth_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/food_log.dart';

class FoodLogProvider with ChangeNotifier {
  final AuthProvider authProvider;

  FoodLogProvider({required this.authProvider});

  final List<FoodLog> _foodLogs = [];

  List<FoodLog> get foodLogs => _foodLogs;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> saveFoodLog(FoodLog foodLog) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await authProvider.authenticatedRequest((
        accessToken,
      ) async {
        final userEmail = await authProvider.secureStorage.read(
          key: 'userEmail',
        );
        final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/log/addFood/$userEmail',
        );

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
              const Duration(seconds: 10),
              onTimeout: () {
                throw TimeoutException(
                  "Request taking too long. Please try again later.",
                );
              },
            );

        return logResponse;
      });

      if (response.statusCode == 201) {
        _foodLogs.add(foodLog);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateFoodLog(FoodLog foodLog) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await authProvider.authenticatedRequest((
        accessToken,
      ) async {
        final url = Uri.parse('${dotenv.env['BASE_URL']}/log/edit');

        final logResponse = await http
            .patch(
              url,
              headers: {
                'Content-Type': 'application/json',
                'x-api-key': '${dotenv.env['X_API_KEY']}',
                'Authorization': 'Bearer $accessToken',
              },
              body: jsonEncode(foodLog.toJson()),
            )
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                throw TimeoutException(
                  "Request taking too long. Please try again later.",
                );
              },
            );

        return logResponse;
      });

      if (response.statusCode == 200) {
        final index = _foodLogs.indexWhere((log) => log.id == foodLog.id);
        if (index != -1) _foodLogs[index] = foodLog;
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchFoodLogs() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await authProvider.authenticatedRequest((
        accessToken,
      ) async {
        final userEmail = await authProvider.secureStorage.read(
          key: 'userEmail',
        );
        final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/log/allLogs/$userEmail',
        );

        final allLogsResponse = await http
            .get(
              url,
              headers: {
                'Content-Type': 'application/json',
                'x-api-key': '${dotenv.env['X_API_KEY']}',
                'Authorization': 'Bearer $accessToken',
              },
            )
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                throw TimeoutException(
                  "Request taking too long. Please try again later.",
                );
              },
            );

        return allLogsResponse;
      });
      if (response.statusCode == 200) {
        final List<dynamic> allLogs = jsonDecode(response.body);
        _foodLogs.clear();
        _foodLogs.addAll(allLogs.map((log) => FoodLog.fromJson(log)).toList());
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteFoodLog(FoodLog foodLog) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await authProvider.authenticatedRequest((
        accessToken,
      ) async {
        final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/log/del/${foodLog.id}',
        );

        final deleteResponse = await http
            .delete(
              url,
              headers: {
                'Content-Type': 'application/json',
                'x-api-key': '${dotenv.env['X_API_KEY']}',
                'Authorization': 'Bearer $accessToken',
              },
            )
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                throw TimeoutException(
                  "Request taking too long. Please try again later.",
                );
              },
            );

        return deleteResponse;
      });

      if (response.statusCode == 200) {
        _foodLogs.remove(foodLog);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, List<FoodLog>> groupLogsByDate(List<FoodLog> foodLogs) {
    final Map<String, List<FoodLog>> groupedLogs = {};

    for (var foodLog in foodLogs) {
      String dateKey = DateFormat(
        'MMMM dd, yyyy',
      ).format(foodLog.timeStamp.toLocal());

      if (!groupedLogs.containsKey(dateKey)) {
        groupedLogs[dateKey] = [];
      }

      groupedLogs[dateKey]!.add(foodLog);
    }
    return groupedLogs;
  }

  Map<String, Map<String, double>> calculateDailyTotals(
    Map<String, List<FoodLog>> groupedLogs,
  ) {
    final Map<String, Map<String, double>> totals = {};

    groupedLogs.forEach((date, logs) {
      double totalProtein = 0;
      double totalCarbs = 0;
      double totalSugar = 0;
      double totalFat = 0;
      double totalEnergy = 0;

      for (var log in logs) {
        totalProtein += log.protein!;
        totalCarbs += log.carbohydrates!;
        totalSugar += log.sugar!;
        totalFat += log.fat!;
        totalEnergy += log.energy!;
      }
      totals[date] = {
        'protein': totalProtein,
        'carbs': totalCarbs,
        'sugar': totalSugar,
        'fat': totalFat,
        'energy': totalEnergy,
      };
    });
    return totals;
  }
}
