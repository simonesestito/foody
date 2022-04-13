import 'package:flutter/material.dart';
import 'package:foody_app/data/model/user.dart';
import 'package:foody_app/routes/base_route.dart';

class LeaveReviewRoute extends BaseRoute {
  static final String routeName = UserRole.cliente.routePrefix + '/review';

  const LeaveReviewRoute({Key? key}) : super(key: key);

  @override
  List<Widget> buildChildren(BuildContext context) => [];
}
