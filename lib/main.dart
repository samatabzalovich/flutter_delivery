import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_delivery/config/routes/routes.dart';
import 'package:flutter_delivery/core/local/shared_preference.dart';
import 'package:flutter_delivery/core/service/dependencies_injector.dart';
import 'package:flutter_delivery/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_delivery/features/auth/presentation/bloc/auth_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await PreferenceHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => sl<AuthBloc>()..add(const AuthCheckTokenEvent()),
      child: const  MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: onGenerateRoutes,
      ),
    );
    // return const MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: MapSample(),
    // );
  }
}
