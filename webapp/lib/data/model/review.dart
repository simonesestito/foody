import 'package:json_annotation/json_annotation.dart';

part 'review.g.dart';

@JsonSerializable()
class Review {
  final int? userId;
  final int restaurantId;
  final DateTime creationDate;
  final int mark;
  final String? title;
  final String? description;

  const Review({
    this.userId,
    required this.restaurantId,
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
