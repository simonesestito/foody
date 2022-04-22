import 'package:foody_app/data/api/api_client.dart';
import 'package:foody_app/data/api/restaurants.dart';
import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/opening_hours.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/data/model/review.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RestaurantsApi)
class RestaurantsApiImpl implements RestaurantsApi {
  final ApiClient apiClient;

  RestaurantsApiImpl(this.apiClient);

  @override
  Future<List<RestaurantWithMenu>> getNearRestaurants(
    GpsLocation location,
    String? query,
  ) async {
    final result = await apiClient.get('/restaurant/', {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'query': query ?? '',
    }) as List<dynamic>;
    return result.map((json) => RestaurantWithMenu.fromJson(json)).toList();
  }

  @override
  Future<RestaurantWithMenu> getRestaurant(int id) async {
    final result = await apiClient.get('/restaurant/$id');
    return RestaurantWithMenu.fromJson(result);
  }

  @override
  Future<void> sendReview(
      NewReview review, int restaurantId, int userId) async {
    await apiClient.post(
      '/restaurant/$restaurantId/review/$userId',
      review.toJson(),
    );
  }

  @override
  Future<List<Review>> getReviews(int restaurantId) async {
    final result = await apiClient.get('/restaurant/$restaurantId/review')
        as List<dynamic>;
    return result.map((json) => Review.fromJson(json)).toList();
  }

  @override
  Future<void> removeReview(Review review) async {
    await apiClient
        .delete('/restaurant/${review.restaurant.id}/review/${review.user.id}');
  }

  @override
  Future<List<RestaurantWithMenu>> getMyRestaurants() async {
    final result = await apiClient.get('/restaurant/my') as List<dynamic>;
    return result.map((json) => RestaurantWithMenu.fromJson(json)).toList();
  }

  @override
  Future<void> updateTimetable(
      int restaurantId, List<OpeningHours> timetable) async {
    await apiClient.post(
      '/restaurant/$restaurantId/timetable',
      timetable.map((e) => e.toJson()).toList(),
    );
  }
}
