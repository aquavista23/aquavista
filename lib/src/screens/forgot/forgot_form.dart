import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:aquavista/src/util/snackbar.dart';
import 'package:aquavista/src/util/initial_button.dart';
import 'package:aquavista/src/bloc/forgot_bloc/bloc.dart';

class ForgotForm extends StatefulWidget {
  const ForgotForm({Key? key}) : super(key: key);

  @override
  State<ForgotForm> createState() => _ForgotFormState();
}

class _ForgotFormState extends State<ForgotForm> {
  // Dos variables
  final TextEditingController _emailController = TextEditingController();
  late ForgotBloc _forgotBloc;
  bool validateName = false;
  bool validateFName = false;
  bool get isPopulated => _emailController.text.isNotEmpty;

  bool isForgotButtonEnabled(ForgotState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _forgotBloc = BlocProvider.of<ForgotBloc>(context);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotBloc, ForgotState>(listener: (context, state) {
      // Si estado es submitting
      if (state.isSubmitting) {
        snackBar(context: context, text: 'Por favor Espere...');
      }
      // Si estado es success
      if (state.isSuccess) {
        // BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        snackBarAlert(
            context: context,
            text: 'Se envio un e-mail a su direccion de correo',
            color: Colors.white);
        Navigator.of(context).pop();
      }
      // Si estado es failure
      if (state.isFailure) {
        snackBarWithIcon(
            context: context,
            text: 'Fallo en la Solicitud',
            color: Colors.red,
            icon: Icons.error);
      }
    }, child: BlocBuilder<ForgotBloc, ForgotState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            child: Center(
              child: ListView(
                children: <Widget>[
                  const SizedBox(
                    height: 50.0,
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

                  const SizedBox(
                    height: 20.0,
                  ),
                  // Boton Registrar
                  InitialButton(
                      text: 'Aceptar',
                      onPressed: () {
                        if (isForgotButtonEnabled(state)) {
                          _onFormSubmitted();
                        }
                      })
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  void _onEmailChanged() {
    _forgotBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onFormSubmitted() {
    _forgotBloc.add(Submitted(
      email: _emailController.text,
    ));
  }
}
