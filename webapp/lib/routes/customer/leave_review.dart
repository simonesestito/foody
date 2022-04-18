import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foody_app/data/api/errors/handler.dart';
import 'package:foody_app/data/api/restaurants.dart';
import 'package:foody_app/data/model/review.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/state/login_status.dart';
import 'package:foody_app/widgets/loading_button.dart';
import 'package:provider/provider.dart';

class LeaveReviewRoute extends BaseRoute {
  static final String routeName = UserRole.cliente.routePrefix + '/review';
  final _ratingController = _RatingController();
  final _titleController = TextEditingController();
  final _textController = TextEditingController();

  LeaveReviewRoute({Key? key}) : super(key: key);

  @override
  List<Widget> buildChildren(BuildContext context) {
    return [
      Text(
        'Lascia una recensione',
        style: Theme.of(context).textTheme.headline4,
      ),
      RatingBar.builder(
        initialRating: 3,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemCount: 5,
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) => _ratingController.updateRating(
          rating.toInt(),
        ),
      ),
      TextFormField(
        controller: _titleController,
        decoration: const InputDecoration(
          label: Text('Titolo'),
          prefixIcon: Icon(Icons.title),
          filled: true,
        ),
      ),
      TextFormField(
        controller: _textController,
        decoration: const InputDecoration(
          label: Text('Testo'),
          prefixIcon: Icon(Icons.notes),
          filled: true,
        ),
        maxLines: 10,
      ),
      LoadingButton(
        text: const Text('Invia'),
        onTap: () => _onSendReview(context),
      ),
    ].map((e) => SliverToBoxAdapter(child: e)).toList();
  }

  Future<void> _onSendReview(BuildContext context) async {
    final restaurantId = ModalRoute.of(context)?.settings.arguments as int;
    final mark = _ratingController._rating;
    String? title = _titleController.text;
    String? text = _textController.text;

    if (mark == null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Voto assente'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ));
      return;
    }

    title = title.isEmpty ? null : title;
    text = text.isEmpty ? null : text;

    try {
      await getIt.get<RestaurantsApi>().sendReview(
          NewReview(
            mark: mark,
            title: title,
            description: text,
          ),
          restaurantId,
          context.read<LoginStatus>().currentUser!.id);

      Navigator.pop(context);
    } catch (e) {
      handleApiError(e, context);
    }
  }
}

class _RatingController {
  int? _rating;

  void updateRating(int rating) {
    _rating = rating;
  }

  int? getRating() => _rating;
}
