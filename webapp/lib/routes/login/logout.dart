import 'package:flutter/material.dart';
import 'package:foody_app/data/api/user.dart';
import 'package:foody_app/di.dart';
import 'package:foody_app/globals.dart';
import 'package:foody_app/utils.dart';
import 'package:foody_app/widgets/loading_button.dart';

class LogoutBottomSheet extends StatelessWidget {
  const LogoutBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Globals.minBottomSheetHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Sei sicuro?',
            style: Theme.of(context).textTheme.headline6,
          ),
          const Text('Stai effettuando il logout'),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ANNULLA'),
              ),
              LoadingButton(
                onTap: () async {
                  await getIt.get<UserApi>().logout();
                  Navigator.pop(context);
                },
                text: const Text('ESCI'),
              ),
            ].withMargin(),
          ),
        ].withMargin(),
      ),
    );
  }
}
