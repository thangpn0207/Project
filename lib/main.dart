import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/blocs/supervisor_bloc.dart';
import 'features/app.dart';
import 'injection_container.dart' as inject1;

Future<void> main() async {
  Bloc.observer = SupervisorBloc();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await inject1.init();
  runApp(App());
}
