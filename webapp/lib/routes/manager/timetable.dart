import 'package:flutter/material.dart';
import 'package:foody_app/data/api/restaurants.dart';
import 'package:foody_app/data/model/opening_hours.dart';
import 'package:foody_app/data/model/restaurant.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/widgets/loading_button.dart';

class RestaurantTimetable extends SingleChildBaseRoute {
  const RestaurantTimetable({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    final restaurant =
        ModalRoute.of(context)!.settings.arguments as RestaurantWithMenu;
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cambia orari', style: Theme.of(context).textTheme.headline4),
          Text('Orari attuali', style: Theme.of(context).textTheme.headline6),
          for (final open in restaurant.sortedOpeningHours)
            Text(open.toString()),
          const Divider(),
          Text('Nuovi orari', style: Theme.of(context).textTheme.headline6),
          TimetableEditor(
            restaurant.sortedOpeningHours,
            restaurantId: restaurant.id,
          ),
        ],
      ),
    );
  }
}

class TimetableEditor extends StatefulWidget {
  final List<OpeningHours> initialTimetable;
  final int restaurantId;

  const TimetableEditor(
    this.initialTimetable, {
    required this.restaurantId,
    Key? key,
  }) : super(key: key);

  @override
  State<TimetableEditor> createState() => _TimetableEditorState();
}

class _TimetableEditorState extends State<TimetableEditor> {
  static const _weekDays = [
    'Lunedi',
    'Martedi',
    'Mercoledi',
    'Giovedi',
    'Venerdi',
    'Sabato',
    'Domenica'
  ];
  final _timetable = List<OpeningHours>.empty(growable: true);
  TimeOfDay? _inputStartTime;
  TimeOfDay? _inputEndTime;
  int? _inputWeekday;

  @override
  void initState() {
    super.initState();
    _timetable.addAll(widget.initialTimetable);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final time in _timetable)
          ListTile(
            title: Text(time.toString()),
            leading: IconButton(
              onPressed: () => setState(() {
                _timetable.remove(time);
              }),
              icon: const Icon(Icons.delete),
            ),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton<int>(
              value: _inputWeekday,
              items: [
                for (int i = 0; i < _weekDays.length; i++)
                  DropdownMenuItem(
                    child: Text(_weekDays[i]),
                    value: i,
                  ),
              ],
              onChanged: (weekDay) => setState(() {
                _inputWeekday = weekDay;
              }),
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child:
                    Text(_inputStartTime?.format(context) ?? 'Ora di apertura'),
              ),
              onTap: () async {
                final startTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                setState(() {
                  _inputStartTime = startTime;
                });
              },
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_inputEndTime?.format(context) ?? 'Ora di chisura'),
              ),
              onTap: () async {
                final endTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                setState(() {
                  _inputEndTime = endTime;
                });
              },
            ),
            IconButton(
              onPressed: () => setState(() {
                if (_inputWeekday != null &&
                    _inputStartTime != null &&
                    _inputEndTime != null) {
                  _timetable.add(OpeningHours(
                    weekday: _inputWeekday!,
                    openingTime: _inputStartTime!,
                    closingTime: _inputEndTime!,
                  ));

                  _inputWeekday = null;
                  _inputStartTime = null;
                  _inputEndTime = null;
                }
              }),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        LoadingButton(
          label: const Text('SALVA'),
          icon: const Icon(Icons.save),
          onPressed: () async {
            await getIt.get<RestaurantsApi>().updateTimetable(
                  widget.restaurantId,
                  _timetable,
                );
          },
        ),
      ],
    );
  }
}
