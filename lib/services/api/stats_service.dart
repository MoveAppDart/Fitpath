import 'api_client.dart';
import '../../config/env_config.dart';

class StatsService {
  final ApiClient _apiClient;
  
  StatsService(this._apiClient);
  
  Future<Map<String, dynamic>> getWeightEvolution({String period = '3months'}) async {
    final response = await _apiClient.get(
      '${EnvConfig.statsEndpoint}/weight-evolution', 
      queryParameters: {'period': period}
    );
    return response.data as Map<String, dynamic>;
  }
  
  Future<Map<String, dynamic>> getPersonalBests(String exerciseId) async {
    final response = await _apiClient.get(
      '${EnvConfig.statsEndpoint}/exercises/$exerciseId/personal-best'
    );
    return response.data as Map<String, dynamic>;
  }
  
  Future<Map<String, dynamic>> getWorkoutFrequency({
    String period = 'monthly', 
    int limit = 12
  }) async {
    final response = await _apiClient.get(
      '${EnvConfig.statsEndpoint}/workout-frequency', 
      queryParameters: {
        'period': period, 
        'limit': limit.toString()
      }
    );
    return response.data as Map<String, dynamic>;
  }
}
