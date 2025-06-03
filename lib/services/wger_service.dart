import 'api/api_client.dart';
import '../models/exercise.dart';

class WgerService {
  final ApiClient _apiClient;

  WgerService(this._apiClient);

  Future<List<Exercise>> searchExercises(String query) async {
    try {
      final response = await _apiClient.get('/exercises/search', queryParameters: {'q': query});
      
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) => Exercise.fromJson(json)).toList();
      } else {
        throw Exception('Error searching exercises: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search exercises: $e');
    }
  }

  Future<Exercise> getExerciseDetails(String id) async {
    try {
      final response = await _apiClient.get('/exercises/$id');
      
      if (response.statusCode == 200) {
        return Exercise.fromJson(response.data);
      } else {
        throw Exception('Error getting exercise details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get exercise details: $e');
    }
  }
}
