import 'package:foody_app/data/api/api_client.dart';
import 'package:foody_app/data/api/restaurants.dart';
import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/data/model/review.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RestaurantsApi)
class RestaurantsApiImpl implements RestaurantsApi {
  final ApiClient apiClient;

  RestaurantsApiImpl(this.apiClient);

  @override
  Future<List<Restaurant>> getNearRestaurants(
    GpsLocation location,
    String? query,
  ) async {
    final result = await apiClient.get('/restaurant/', {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'query': query ?? '',
    }) as List<dynamic>;
    return result.map((json) => Restaurant.fromJson(json)).toList();
  }

  @override
  Future<Restaurant> getRestaurant(int id) async {
    final result = await apiClient.get('/restaurant/$id');
    return Restaurant.fromJson(result);
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
    final result = await apiClient.get('/restaurant/review') as List<dynamic>;
    return result.map((json) => Review.fromJson(json)).toList();
  }

  @override
  Future<void> removeReview(Review review) async {
    await apiClient
        .delete('/restaurant/${review.restaurantId}/review/${review.userId!}');
  }

  @override
  Future<void> deleteRestaurant(int restaurantId) async {
    throw Exception('TODO');
  }

  @override
  Future<Restaurant> addRestaurant(Restaurant restaurant) async {
    throw Exception('TODO');
  }

  @override
  Future<Restaurant> updateRestaurant(Restaurant restaurant) async {
    throw Exception('TODO');
  }

  @override
  Future<List<User>> getEmployees(int restaurantId) async {
    throw Exception('TODO');
  }

  @override
  Future<List<User>> removeEmployee(int restaurantId, User user) async {
    throw Exception('TODO');
  }

  @override
  Future<List<User>> addEmployee(int restaurantId, String userEmail) async {
    throw Exception('TODO');
  }
}
