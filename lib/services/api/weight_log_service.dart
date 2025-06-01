import 'package:flutter/foundation.dart';
import 'api_client.dart';
import '../../config/env_config.dart';

class WeightLogService {
  final ApiClient _apiClient;
  
  WeightLogService(this._apiClient);
  
  Future<List<dynamic>> getWeightLogs() async {
    final response = await _apiClient.get(EnvConfig.weightLogsEndpoint);
    return (response.data as List).toList();
  }
  
  Future<Map<String, dynamic>> getWeightLog(String id) async {
    final response = await _apiClient.get('${EnvConfig.weightLogsEndpoint}/$id');
    return response.data as Map<String, dynamic>;
  }
  
  Future<bool> addWeightLog(Map<String, dynamic> weightLogData) async {
    try {
      await _apiClient.post(
        EnvConfig.weightLogsEndpoint, 
        data: weightLogData
      );
      return true;
    } catch (e) {
      debugPrint('Error adding weight log: $e');
      return false;
    }
  }
  
  Future<bool> updateWeightLog(String id, Map<String, dynamic> weightLogData) async {
    try {
      await _apiClient.put(
        '${EnvConfig.weightLogsEndpoint}/$id', 
        data: weightLogData
      );
      return true;
    } catch (e) {
      debugPrint('Error updating weight log: $e');
      return false;
    }
  }
  
  Future<bool> deleteWeightLog(String id) async {
    try {
      await _apiClient.delete('${EnvConfig.weightLogsEndpoint}/$id');
      return true;
    } catch (e) {
      debugPrint('Error deleting weight log: $e');
      return false;
    }
  }
}
