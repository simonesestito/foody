import 'package:foody_app/data/api/api_client.dart';
import 'package:foody_app/data/api/query_stats.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: QueryStatsApi)
class QueryStatsApiImpl implements QueryStatsApi {
  final ApiClient apiClient;

  const QueryStatsApiImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> getAll() async {
    final result = await apiClient.get('/queries/');
    return result as Map<String, dynamic>;
  }
}
