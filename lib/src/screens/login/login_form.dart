// ignore_for_file: unnecessary_null_comparison
import 'package:aquavista/src/screens/login/forgot_password.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aquavista/src/util/snackbar.dart';
import 'package:aquavista/src/util/initial_button.dart';
import 'package:aquavista/src/bloc/login_bloc/bloc.dart';
import 'package:aquavista/src/repository/user_repository.dart';
import 'package:aquavista/src/screens/login/google_login_button.dart';
import 'package:aquavista/src/bloc/authentication_bloc/bloc.dart';
import 'package:aquavista/src/screens/login/create_account_button.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  const LoginForm({Key? key, required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late LoginBloc _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      // tres casos, tres if:
      if (state.isFailure) {
        snackBarWithIcon(
            context: context,
            text: 'Login Failure',
            color: Colors.red,
            icon: Icons.error);
      }
      if (state.isSubmitting) {
        snackBar(context: context, text: 'Logging in... ');
      }
      if (state.isSuccess) {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Image(image: AssetImage("assets/LOGO_text.png"))),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.email), labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.always,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isEmailValid ? 'Email Invalido' : null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        labelText: 'Contraseña',
                        suffixIcon: SizedBox(
                          height: 20,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon((_obscureText)
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined)),
                        )),
                    obscureText: _obscureText,
                    autovalidateMode: AutovalidateMode.always,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid
                          ? 'Contraseña Invalida'
                          : null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Tres botones:
                        // LoginButton
                        InitialButton(
                            text: 'Login',
                            onPressed: () {
                              if (isLoginButtonEnabled(state)) {
                                _onFormSubmitted();
                              }
                            }),
                        const SizedBox(
                          height: 20.0,
                        ),
                        // GoogleLoginButton
                        const GoogleLoginButton(),

                        const SizedBox(
                          height: 20.0,
                        ),
                        // CreateAccountButton
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CreateAccountButton(
                              userRepository: _userRepository,
                            ),
                            ForgotPasswordButton(
                              userRepository: _userRepository,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _loginBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onFormSubmitted() {
    _loginBloc.add(LoginWithCredentialsPressed(
        email: _emailController.text, password: _passwordController.text));
  }
}
