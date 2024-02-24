// ignore_for_file: unnecessary_null_comparison, override_on_non_overriding_member, invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:aquavista/src/util/validators.dart';
import 'package:aquavista/src/bloc/forgot_bloc/bloc.dart';
import 'package:aquavista/src/repository/user_repository.dart';

class ForgotBloc extends Bloc<ForgotEvent, ForgotState> {
  // final UserRepository _userRepository;

  ForgotBloc({required UserRepository userRepository})
      : assert(userRepository != null),
        super(ForgotState.empty()) {
    on<ForgotEvent>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }

  @override
  ForgotState get initialState => ForgotState.empty();

  @override
  Stream<Transition<ForgotEvent, ForgotState>> transformEvents(
    Stream<ForgotEvent> events,
    transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged);
    }).debounceTime(const Duration(milliseconds: 300));
    return transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  mapEventToState(
    ForgotEvent event,
    Emitter<ForgotState> emit,
  ) async {
    // Si el evento es EmailChanged
    if (event is EmailChanged) {
      emit(await _mapEmailChangedToState(event.email));
    }

    // Si el evento es Submitted
    if (event is Submitted) {
      emit(await _mapFormSubmittedToState(event.email));
    }
  }

  Future<ForgotState> _mapEmailChangedToState(String email) async {
    return state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Future<ForgotState> _mapFormSubmittedToState(String email) async {
    emit(ForgotState.loading());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return ForgotState.success();
    } catch (_) {
      return ForgotState.failure();
    }
  }
}
