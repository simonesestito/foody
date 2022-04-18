import 'package:foody_app/data/model/address.dart';
import 'package:foody_app/data/model/opening_hours.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/data/model/review.dart';
import 'package:foody_app/data/model/user.dart';

abstract class RestaurantsApi {
  Future<List<Restaurant>> getNearRestaurants(
    GpsLocation location,
    String? query,
  );

  Future<Restaurant> getRestaurant(int id);

  Future<List<Restaurant>> getMyRestaurants();

  Future<void> sendReview(NewReview review, int restaurantId, int userId);

  Future<List<Review>> getReviews(int restaurantId);

  Future<void> removeReview(Review review);

  Future<void> deleteRestaurant(int restaurantId);

  Future<Restaurant> addRestaurant(Restaurant restaurant);

  Future<Restaurant> updateRestaurant(Restaurant restaurant);

  Future<List<User>> getEmployees(int restaurantId);

  Future<List<User>> removeEmployee(int restaurantId, User user);

  Future<List<User>> addEmployee(int restaurantId, String userEmail);

  Future<void> updateTimetable(int restaurantId, List<OpeningHours> timetable);
}
