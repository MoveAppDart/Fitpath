import 'api_client.dart';
import '../../config/env_config.dart';

class WeightLogService {
  final ApiClient _apiClient;
  
  WeightLogService(this._apiClient);
  
  Future<List<dynamic>> getWeightLogs() async {
    return await _apiClient.get(EnvConfig.weightLogsEndpoint);
  }
  
  Future<Map<String, dynamic>> getWeightLog(String id) async {
    return await _apiClient.get('${EnvConfig.weightLogsEndpoint}/$id');
  }
  
  Future<bool> addWeightLog(Map<String, dynamic> weightLogData) async {
    try {
      await _apiClient.post(EnvConfig.weightLogsEndpoint, data: weightLogData);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> updateWeightLog(String id, Map<String, dynamic> weightLogData) async {
    try {
      await _apiClient.put('${EnvConfig.weightLogsEndpoint}/$id', data: weightLogData);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> deleteWeightLog(String id) async {
    try {
      await _apiClient.delete('${EnvConfig.weightLogsEndpoint}/$id');
      return true;
    } catch (e) {
      return false;
    }
  }
}
