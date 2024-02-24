// ignore_for_file: override_on_non_overriding_member, unnecessary_null_comparison, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:aquavista/src/util/validators.dart';
import 'package:aquavista/src/bloc/login_bloc/bloc.dart';
import 'package:aquavista/src/repository/user_repository.dart';
import 'package:aquavista/src/functions/db_script_function.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  //Constructor
  LoginBloc({required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(LoginState.empty()) {
    on<LoginEvent>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
    Stream<LoginEvent> events,
    transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(const Duration(milliseconds: 300));
    return transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  mapEventToState(LoginEvent event, Emitter<LoginState> emit) async {
    if (event is EmailChanged) {
      emit(await _mapEmailChangedToState(event.email));
    }
    if (event is PasswordChanged) {
      emit(await _mapPasswordChangedToState(event.password));
    }
    if (event is LoginWithGooglePressed) {
      emit(await _mapLoginWithGooglePressedToState());
    }
    if (event is LoginWithCredentialsPressed) {
      emit(await _mapLoginWithCredentialsPressedToState(
          email: event.email, password: event.password));
    }
  }

  Future<LoginState> _mapEmailChangedToState(String email) async {
    return state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Future<LoginState> _mapPasswordChangedToState(String password) async {
    return state.update(isPasswordValid: Validators.isValidPassword(password));
  }

  Future<LoginState> _mapLoginWithGooglePressedToState() async {
    try {
      await _userRepository.signInWithGoogle();
      return LoginState.success();
    } catch (_) {
      return LoginState.failure();
    }
  }

  Future<LoginState> _mapLoginWithCredentialsPressedToState(
      {required String email, required String password}) async {
    emit(LoginState.loading());
    try {
      await _userRepository.signInWithCredentials(email, password);
      User? currentUser = FirebaseAuth.instance.currentUser;
      CollectionReference userColection =
          FirebaseFirestore.instance.collection('usuarios');
      await userColection
          .doc(currentUser!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        String? token = await FirebaseMessaging.instance.getToken();
        if (documentSnapshot.exists) {
          await updateUser(userColection, documentSnapshot, currentUser, token);
          await updateShare(documentSnapshot, userColection, currentUser);
        } else {
          await createUser(currentUser.uid, email, token, null, null);
        }
      });

      return LoginState.success();
    } catch (_) {
      return LoginState.failure();
    }
  }
}
