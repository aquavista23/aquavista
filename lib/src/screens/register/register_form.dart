import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aquavista/src/util/snackbar.dart';
import 'package:aquavista/src/util/initial_button.dart';
import 'package:aquavista/src/bloc/register_bloc/bloc.dart';
import 'package:aquavista/src/bloc/authentication_bloc/bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  // Dos variables
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late RegisterBloc _registerBloc;
  bool validateName = false;
  bool validateFName = false;
  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _nameController.addListener(_onNameChanged);
    _fNameController.addListener(_onFNameChanged);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
      // Si estado es submitting
      if (state.isSubmitting) {
        snackBar(context: context, text: 'Registerando');
      }
      // Si estado es success
      if (state.isSuccess) {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        Navigator.of(context).pop();
      }
      // Si estado es failure
      if (state.isFailure) {
        snackBarWithIcon(
            context: context,
            text: 'Fallo en el Registro',
            color: Colors.red,
            icon: Icons.error);
      }
    }, child: BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            child: ListView(
              children: <Widget>[
                const SizedBox(
                  height: 50.0,
                ),
                // Un textForm para name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.contacts_rounded),
                    labelText: 'Nombre',
                  ),
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (_) {
                    return validateName ? 'Nombre Invalido' : null;
                  },
                  onChanged: (value) {
                    bool aux = false;
                    if (value.isNotEmpty) {
                      aux = false;
                    } else {
                      aux = true;
                    }

                    setState(() {
                      validateName = aux;
                    });
                  },
                ),

                // Un textForm para fName
                TextFormField(
                  controller: _fNameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.contacts_rounded),
                    labelText: 'Apellido',
                  ),
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (_) {
                    return validateFName ? 'Apellido Invalido' : null;
                  },
                  onChanged: (value) {
                    bool aux = false;
                    if (value.isNotEmpty) {
                      aux = false;
                    } else {
                      aux = true;
                    }

                    setState(() {
                      validateFName = aux;
                    });
                  },
                ),

                // Un textForm para email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (_) {
                    return !state.isEmailValid ? 'Email Invalido' : null;
                  },
                ),

                // Un textForm para Contraseña
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.lock), labelText: 'Contraseña'),
                  obscureText: true,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (_) {
                    return !state.isPasswordValid
                        ? 'Contraseña Invalida'
                        : null;
                  },
                ),

                // Un textForm para Confirmar Contraseña
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: 'Confirmar Contraseña'),
                  obscureText: true,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (_) {
                    return (_confirmPasswordController.text.length ==
                                _passwordController.text.length &&
                            _confirmPasswordController.text !=
                                _passwordController.text)
                        ? 'Contraseña No Coinciden'
                        : null;
                  },
                ),

                const SizedBox(
                  height: 20.0,
                ),
                // Boton Registrar
                InitialButton(
                    text: 'Registrar',
                    onPressed: () {
                      if (_nameController.text.isNotEmpty) {
                        if (_fNameController.text.isNotEmpty) {
                          if (_confirmPasswordController.text ==
                              _passwordController.text) {
                            if (isRegisterButtonEnabled(state)) {
                              _onFormSubmitted();
                            }
                          } else {
                            snackBarAlert(
                                context: context,
                                text: 'Contraseñas no coinsiden',
                                color: Colors.red);
                          }
                        } else {
                          snackBarAlert(
                              context: context,
                              text: 'Debe llenar campo Apellido',
                              color: Colors.red);
                          setState(() {
                            validateFName = true;
                          });
                        }
                      } else {
                        snackBarAlert(
                            context: context,
                            text: 'Debe llenar campo Nombre',
                            color: Colors.red);
                        setState(() {
                          validateName = true;
                        });
                      }
                    })
              ],
            ),
          ),
        );
      },
    ));
  }

  void _onNameChanged() {
    _registerBloc.add(NameChanged(name: _nameController.text));
  }

  void _onFNameChanged() {
    _registerBloc.add(FNameChanged(fName: _fNameController.text));
  }

  void _onEmailChanged() {
    _registerBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _registerBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _onConfirmPasswordChanged() {
    _registerBloc
        .add(PasswordChanged(password: _confirmPasswordController.text));
  }

  void _onFormSubmitted() {
    _registerBloc.add(Submitted(
      name: _nameController.text,
      fName: _fNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    ));
  }
}
