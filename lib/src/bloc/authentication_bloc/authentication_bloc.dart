// ignore_for_file: override_on_non_overriding_member, unnecessary_null_comparison

import 'dart:async';
import 'package:bloc/bloc.dart';

import 'package:aquavista/src/repository/user_repository.dart';
import 'package:aquavista/src/bloc/authentication_bloc/bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(Uninitialized()) {
    on<AuthenticationEvent>((event, emit) async {
      await mapEventToState(emit, event);
    });
  }

  @override
  mapEventToState(
    Emitter<AuthenticationState> emit,
    AuthenticationEvent event,
  ) async {
    if (event is AppStarted) {
      emit(await _mapAppStartedToState());
    }
    if (event is LoggedIn) {
      emit(await _mapLoggedInToState());
    }
    if (event is LoggedOut) {
      emit(await _mapLoggedOutToState());
    }
  }

  Future<AuthenticationState> _mapAppStartedToState() async {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await _userRepository.getUser();
        return await Future.delayed(const Duration(seconds: 5), () {
          return Authenticated(user!);
        });
      } else {
        return await Future.delayed(const Duration(seconds: 5), () {
          return Unauthenticated();
        });
      }
    } catch (_) {
      return Unauthenticated();
    }
  }

  Future<AuthenticationState> _mapLoggedInToState() async {
    final user = await _userRepository.getUser();
    return Authenticated(user!);
  }

  Future<AuthenticationState> _mapLoggedOutToState() async {
    _userRepository.signOut();
    return Unauthenticated();
  }
}
