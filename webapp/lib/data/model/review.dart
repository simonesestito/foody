import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  final User user;
  final Restaurant restaurant;
  final DateTime creationDate;
  final int mark;
  final String? title;
  final String? description;

  const Review({
    required this.user,
    required this.restaurant,
    required this.creationDate,
    required this.mark,
    this.title,
    this.description,
  });

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewToJson(this);
}

@JsonSerializable()
class NewReview {
  final int mark;
  final String? title;
  final String? description;

  const NewReview({
    required this.mark,
    this.title,
    this.description,
  });

  factory NewReview.fromJson(Map<String, dynamic> json) =>
      _$NewReviewFromJson(json);

  Map<String, dynamic> toJson() => _$NewReviewToJson(this);
}
