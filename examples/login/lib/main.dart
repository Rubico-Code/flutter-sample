import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/app.dart';
import 'package:login/authentication/authentication.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) {
        return AuthenticationRepository();
      },
      child: BlocProvider<AuthenticationBloc>(
        create: (context) {
          final authenticationRepository =
              RepositoryProvider.of<AuthenticationRepository>(context);
          return AuthenticationBloc(authenticationRepository)..add(AppLoaded());
        },
        child: App(),
      ),
    );
  }
}
