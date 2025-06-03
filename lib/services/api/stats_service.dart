import 'package:dio/dio.dart';
import '../../config/env_config.dart';
import '../../models/stats/weight_evolution.dart';
import '../../models/stats/personal_best.dart';
import '../../models/stats/workout_frequency.dart';
import '../../models/api_response.dart';
import 'auth_service.dart';

/// Service for handling statistics-related API calls
class StatsService {
  final Dio _dio;
  final AuthService _authService;
  
  StatsService({
    required Dio dio,
    required AuthService authService,
  })  : _dio = dio,
        _authService = authService {
    // Add interceptor for authentication
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _authService.accessToken;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }
  
  /// Fetches weight evolution data for the authenticated user
  /// 
  /// [period] - The time period to fetch data for (e.g., '1month', '3months', '6months', '1year')
  /// Returns a list of [WeightDataPoint] objects
  Future<ApiResponse<List<WeightDataPoint>>> getWeightEvolution({String period = '3months'}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${EnvConfig.statsEndpoint}/weight',
        queryParameters: {'period': period},
      );
      
      if (response.data?['success'] == true) {
        final List<dynamic> data = response.data?['data'] ?? [];
        final weightData = data
            .map((item) => WeightDataPoint.fromJson(item as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(weightData);
      } else {
        return ApiResponse.error(
          message: response.data?['message'] ?? 'Failed to load weight data',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: 'An unexpected error occurred');
    }
  }
  
  /// Fetches personal best records for a specific exercise
  /// 
  /// [exerciseId] - The ID of the exercise to get records for
  /// Returns a [PersonalBest] object with the user's personal records
  Future<ApiResponse<PersonalBest>> getPersonalBests(String exerciseId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${EnvConfig.exercisesEndpoint}/$exerciseId/personal-best',
      );
      
      if (response.data?['success'] == true) {
        final data = response.data?['data'] as Map<String, dynamic>?;
        if (data != null) {
          return ApiResponse.success(PersonalBest.fromJson(data));
        }
      }
      
      return ApiResponse.error(
        message: response.data?['message'] ?? 'Failed to load personal bests',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: 'An unexpected error occurred');
    }
  }
  
  /// Fetches workout frequency statistics
  /// 
  /// [period] - The time period to analyze (e.g., 'weekly', 'monthly')
  /// [limit] - Maximum number of periods to return
  /// Returns a list of [WorkoutFrequency] objects
  Future<ApiResponse<List<WorkoutFrequency>>> getWorkoutFrequency({
    String period = 'monthly',
    int limit = 12,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        EnvConfig.workoutFrequencyEndpoint,
        queryParameters: {
          'period': period,
          'limit': limit,
        },
      );
      
      if (response.data?['success'] == true) {
        final List<dynamic> data = response.data?['data'] ?? [];
        final frequencyData = data
            .map((item) => WorkoutFrequency.fromJson(item as Map<String, dynamic>))
            .toList();
        return ApiResponse.success(frequencyData);
      } else {
        return ApiResponse.error(
          message: response.data?['message'] ?? 'Failed to load workout frequency',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: 'An unexpected error occurred');
    }
  }

  /// Fetches user statistics summary
  Future<ApiResponse<Map<String, dynamic>>> getUserStatsSummary() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        EnvConfig.userStatsEndpoint,
      );
      
      if (response.data?['success'] == true) {
        return ApiResponse.success(response.data?['data'] ?? {});
      } else {
        return ApiResponse.error(
          message: response.data?['message'] ?? 'Failed to load user stats',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message'] ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(message: 'An unexpected error occurred');
    }
  }
}
