import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foody_app/globals.dart';
import 'package:foody_app/routes/base_route.dart';
import 'package:foody_app/routes/login/route.dart';
import 'package:foody_app/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends SingleChildBaseRoute {
  static const routeName = '/';

  const Home({Key? key}) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    final presentationColumn = Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Food Delivery Project',
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          Text(
            'Realizzato per il corso di Basi di Dati, Sapienza Università di Roma',
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, LoginRoute.routeName);
            },
            child: const Text('ENTRA NEL SERVIZIO'),
          ),
          const Divider(),
          OutlinedButton.icon(
            onPressed: () => launch('https://github.com/simonesestito/foody'),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Vedi i sorgenti su GitHub'),
          ),
          OutlinedButton.icon(
            onPressed: () => launch(
                'https://docs.google.com/document/d/1ZwEkWuvf-ahT-VYcy9PswgyFIt3eK8YtoOjwECuWCTM/edit?usp=sharing'),
            icon: const Icon(Icons.description),
            label: const Text('Sfoglia la documentazione del database'),
          ),
        ].withMargin());

    final illustration = SvgPicture.asset('assets/svg/rider.svg', width: 400);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(Globals.standardMargin),
        child: MediaQuery.of(context).size.width > 1200
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  illustration,
                  presentationColumn,
                ],
              )
            : Column(children: [
                presentationColumn,
                SizedBox.fromSize(size: const Size(0, Globals.largeMargin)),
                illustration,
              ]),
      ),
    );
  }
}
