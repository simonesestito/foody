import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'opening_hours.g.dart';

@JsonSerializable()
@_TimeOfDayJsonConverter()
class OpeningHours {
  final int weekday;
  final TimeOfDay openingTime;
  final TimeOfDay closingTime;

  const OpeningHours({
    required this.weekday,
    required this.openingTime,
    required this.closingTime,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursFromJson(json);

  Map<String, dynamic> toJson() => _$OpeningHoursToJson(this);

  @override
  String toString() {
    final stringWeekday = [
      'Lunedi',
      'Martedi',
      'Mercoledi',
      'Giovedi',
      'Venerdi',
      'Sabato',
      'Domenica'
    ][weekday];
    const converter = _TimeOfDayJsonConverter();
    final displayOpening = converter.toJson(openingTime);
    final displayClosing = converter.toJson(closingTime);
    return '$stringWeekday, $displayOpening - $displayClosing';
  }
}

class _TimeOfDayJsonConverter implements JsonConverter<TimeOfDay, String> {
  const _TimeOfDayJsonConverter();

  @override
  TimeOfDay fromJson(String json) {
    final timeParts = json.split(':');
    return TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
  }

  @override
  String toJson(TimeOfDay object) {
    final hoursString = object.hour.toString().padLeft(2, '0');
    final minutesString = object.minute.toString().padLeft(2, '0');
    return '$hoursString:$minutesString';
  }
}
