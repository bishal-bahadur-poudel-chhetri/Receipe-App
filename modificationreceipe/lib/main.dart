import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logins/blocs/authentication/authentication_bloc.dart';
import 'package:logins/pages/Homepage/home_page.dart';
import 'package:logins/pages/login_page.dart';
import 'package:logins/pages/splash_page.dart';
import 'package:logins/services/repository.dart';

import 'blocs/authentication/authentication_event.dart';
import 'blocs/authentication/authentication_state.dart';
import 'blocs/floatingbtn/homepage_bloc.dart';
import 'blocs/homepage/homepage_bloc.dart';

void main() {
  final Repository repository = Repository();
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final Repository repository;

  const MyApp({required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) =>
          AuthenticationBloc(repository: repository)..add(AppStarted()),
        ),
      ],
      child: _MyAppContent(repository: repository),
    );
  }
}

class _MyAppContent extends StatelessWidget {
  final Repository repository;

  const _MyAppContent({required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Connect Flavor',
      theme: ThemeData(primaryColor: Colors.deepPurple),
      home: MultiBlocProvider(
        providers: [
          // Add other BlocProviders as needed
          BlocProvider<HomepageBloc>(
            create: (context) => HomepageBloc(repository: repository),
          ),
        ],
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationAuthenticated) {
              return HomePage();
            }
            if (state is AuthenticationUnauthenticated) {
              return LoginPage(repository: repository);
            }
            if (state is AuthenticationLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is AuthenticationUninitialized) {
              // Show splash screen while initializing
              return SplashPage();
            }
            return SplashPage();
          },
        ),
      ),
    );
  }
}
