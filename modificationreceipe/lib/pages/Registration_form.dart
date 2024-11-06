import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logins/blocs/Registration/bloc.dart';
import 'package:logins/blocs/Registration/register_bloc.dart';
import 'package:logins/blocs/Registration/register_event.dart';
import 'package:logins/blocs/Registration/register_state.dart';
import 'package:logins/blocs/authentication/bloc.dart';
import 'package:logins/services/repository.dart';
import 'package:logins/pages/login_page.dart';

class RegisterApp extends StatelessWidget {
  final Repository repository;

  RegisterApp({required this.repository});

  @override
  Widget build(BuildContext context) {
    RegisterBloc registerBloc = RegisterBloc(
      repository: repository,


    );

    return BlocProvider(
      create: (context) => AuthenticationBloc(repository: repository)..add(AppStarted()),
      child: Scaffold(
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
                  create: (context) => registerBloc,
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Lets Create!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          RegisterForm(),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to another page
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LoginPage(repository: repository),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                              padding: EdgeInsets.all(9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                              textStyle: TextStyle(fontSize: 16),
                              side: BorderSide(
                                width: 1,
                              ),
                              minimumSize: Size(double.infinity, 0),
                              alignment: Alignment.center,
                            ),
                            child: Text("Login"),
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
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();
  final _emailController = TextEditingController();
  final RegExp passwordPattern = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$',
  );

  // Email format regex pattern
  final RegExp emailPattern = RegExp(
    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
  );

  @override
  Widget build(BuildContext context) {
    final registerBloc = BlocProvider.of<RegisterBloc>(context);

    void _onLoginButtonPressed() {
      final String username = _usernameController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String password2 = _password2Controller.text;
      if (username.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          password2.isEmpty) {
        // Handle empty fields
        // ...
        return;
      } else if (!emailPattern.hasMatch(email)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invalid email format"),
          backgroundColor: Colors.red,
        ));
        return;
      } else if (!passwordPattern.hasMatch(password)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Password must contain at least one uppercase letter, one lowercase letter, one digit, and be at least 8 characters long",
          ),
          backgroundColor: Colors.red,
        ));
        return;
      } else if (password != password2) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: Colors.red,
        ));
        return;
      }

      registerBloc.add(RegisterButtonPressedEvent(
        username: username,
        password: password,
        password2: password2,
        email: email,
      ));
    }

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${state.error}"),
            backgroundColor: Colors.red,
          ));
        } else if (state is RegisterSuccessfull) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Register Succesfull!"),
            backgroundColor: Colors.green,
          ));
          _usernameController.clear();
          _emailController.clear();
          _passwordController.clear();
          _password2Controller.clear();
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
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
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
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
                  TextFormField(
                    controller: _password2Controller,
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
                      child: Text("Create Account"),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  if (state is RegisterLoading) CircularProgressIndicator(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
