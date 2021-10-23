import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'core/blocs/supervisor_bloc.dart';
import 'features/app.dart';
import 'injection_container.dart' as inject1;

Future<void> main() async {
  Bloc.observer = SupervisorBloc();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await inject1.init();
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    FacebookAuth.i.webInitialize(
      appId: "1119721285228432", //<-- YOUR APP_ID
      cookie: true,
      xfbml: true,
      version: "v9.0",
    );
  }
  runApp(App());
}
