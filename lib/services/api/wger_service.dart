import 'package:fitpath/config/env_config.dart';
import 'package:fitpath/models/models.dart';
import 'api_client.dart';

class WgerService {
  final ApiClient _apiClient;

  WgerService(this._apiClient);

  /// Busca ejercicios en la API de WGER
  Future<List<Exercise>> searchExercises(String term, {int? limit}) async {
    String url = EnvConfig.wgerSearchEndpoint;
    final queryParams = {'term': term};
    if (limit != null) {
      queryParams['limit'] = limit.toString();
    }

    final response = await _apiClient.get(
      url,
      queryParameters: queryParams,
    );

    final List<dynamic> exercisesJson = response.data['data'] as List<dynamic>;
    return exercisesJson.map((json) => Exercise.fromJson(json)).toList();
  }

  /// Obtiene los detalles de un ejercicio específico de WGER
  Future<Exercise> getExerciseDetails(int wgerId) async {
    final response = await _apiClient.get(
      EnvConfig.wgerExerciseByIdEndpoint(wgerId),
    );

    return Exercise.fromJson(response.data);
  }

  /// Importa un ejercicio de WGER a la base de datos local
  Future<Exercise> importExercise(int wgerId) async {
    final response = await _apiClient.post(
      '${EnvConfig.exercisesEndpoint}/import',
      data: {'wger_id': wgerId},
    );

    return Exercise.fromJson(response.data['data']);
  }
}
