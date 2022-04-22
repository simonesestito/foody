import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/opening_hours.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/data/model/review.dart';

abstract class RestaurantsApi {
  Future<List<RestaurantWithMenu>> getNearRestaurants(
    GpsLocation location,
    String? query,
  );

  Future<RestaurantWithMenu> getRestaurant(int id);

  Future<List<RestaurantWithMenu>> getMyRestaurants();

  Future<void> sendReview(NewReview review, int restaurantId, int userId);

  Future<List<Review>> getReviews(int restaurantId);

  Future<void> removeReview(Review review);

  Future<void> updateTimetable(int restaurantId, List<OpeningHours> timetable);
}
