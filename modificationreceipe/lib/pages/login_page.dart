// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logins/blocs/authentication/bloc.dart';
// import 'package:logins/blocs/login/bloc.dart';
// import 'package:logins/services/repository.dart';
//
// import 'Registration_form.dart';
//
// class LoginPage extends StatelessWidget {
//   final Repository repository;
//   LoginPage({required this.repository});
//
//   @override
//   Widget build(BuildContext context) {
//     LoginBloc loginBloc = LoginBloc(
//         repository: repository,
//         authenticationBloc: BlocProvider.of<AuthenticationBloc>(context));
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Login Page"),
//       ),
//       body: BlocProvider(
//         create: (context) => loginBloc,
//         child: LoginForm(),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logins/blocs/authentication/bloc.dart';
import 'package:logins/blocs/login/bloc.dart';
import 'package:logins/pages/Homepage/home_page.dart';
import 'package:logins/services/repository.dart';

import 'Registration_form.dart';

class LoginPage extends StatelessWidget {
  final Repository repository;

  LoginPage({required this.repository});

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = LoginBloc(
      repository: repository,
      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2704FA),
              Color(0xFF2A7C66),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: BlocProvider(
                create: (context) => loginBloc,
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Welcome back!',
                            style: TextStyle(

                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        LoginForm(),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to another page
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RegisterApp(repository: repository), // Replace 'SecondPage()' with the page you want to navigate to
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            padding: EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                            textStyle: TextStyle(fontSize: 16),
                            side: BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                            minimumSize: Size(double.infinity, 0),
                            alignment: Alignment.center,
                          ),
                          child: Text("Create a new account"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);

    void _onLoginButtonPressed() {
      final String username = _usernameController.text;
      final String password = _passwordController.text;

      if (username.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Username and password cannot be empty."),
          backgroundColor: Colors.red,
        ));
        return;
      }

      loginBloc.add(LoginButtonPressedEvent(
        username: username,
        password: password,
      ));
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${state.error}"),
            backgroundColor: Colors.red,
          ));
        }
        if (state is LoginSucess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
          );
        }

      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(

                      prefixIcon: Icon(Icons.person),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(

                      prefixIcon: Icon(Icons.lock),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  FractionallySizedBox(
                    widthFactor: 1.0,
                    child: ElevatedButton(
                      onPressed: _onLoginButtonPressed,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        primary: Colors.red,
                      ),
                      child: Text("Login"),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  if (state is LoginLoading) CircularProgressIndicator(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

