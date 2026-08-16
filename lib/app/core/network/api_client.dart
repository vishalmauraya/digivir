import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../security/metadata_header_generator.dart';
import '../utils/app_logger.dart';
import 'api_exception.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();


  Future<Map<String, dynamic>> post({
    required String path,
    required Map<String, dynamic> payload,
  }) async {
    final RequestMetadata metadata = MetadataHeaderGenerator.generate(payload);
    final Uri uri = Uri.parse('${ApiConstants.baseUrl}$path');

    final Map<String, String> headers = <String, String>{
      ApiConstants.headerContentType: ApiConstants.contentTypeJson,
      ...metadata.toHeaders(),
    };

    AppLogger.info(
      'POST $uri | trace_id=${metadata.traceId} | logic_hash='
      '${metadata.logicHash.substring(0, 12)}…',
    );

    try {
      final http.Response response = await _client
          .post(uri, headers: headers, body: jsonEncode(payload))
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body.isEmpty
            ? <String, dynamic>{}
            : jsonDecode(response.body) as Map<String, dynamic>;
      }

      throw ServerException(
        response.statusCode,
        'Server responded with ${response.statusCode}: ${response.body}',
      );
    } on ServerException {
      rethrow;
    } catch (error, stackTrace) {
      AppLogger.error(
        'Network call failed',
        error: error,
        stackTrace: stackTrace,
      );
      throw NetworkUnavailableException('Unable to reach HabotConnect API.');
    }
  }

  void dispose() => _client.close();
}
