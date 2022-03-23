import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

/// Dependency Injection
final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => $initGetIt(getIt);
