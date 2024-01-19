// ignore_for_file: unnecessary_null_comparison, override_on_non_overriding_member, invalid_use_of_visible_for_testing_member

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:aquavista/src/util/validators.dart';
import 'package:aquavista/src/bloc/register_bloc/bloc.dart';
import 'package:aquavista/src/repository/user_repository.dart';
import 'package:aquavista/src/functions/db_script_function.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(RegisterState.empty()) {
    on<RegisterEvent>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<Transition<RegisterEvent, RegisterState>> transformEvents(
    Stream<RegisterEvent> events,
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
  mapEventToState(
    RegisterEvent event,
    Emitter<RegisterState> emit,
  ) async {
    // Tres casos
    // Si el evento es EmailChanged
    if (event is EmailChanged) {
      emit(await _mapEmailChangedToState(event.email));
    }
    // Si el evento es PasswordChanged
    if (event is PasswordChanged) {
      emit(await _mapPasswordChangedToState(event.password));
    }
    // Si el evento es Submitted
    if (event is Submitted) {
      emit(await _mapFormSubmittedToState(event.email, event.password));
    }
  }

  Future<RegisterState> _mapEmailChangedToState(String email) async {
    return state.update(isEmailValid: Validators.isValidEmail(email));
  }

  Future<RegisterState> _mapPasswordChangedToState(String password) async {
    return state.update(isPasswordValid: Validators.isValidPassword(password));
  }

  Future<RegisterState> _mapFormSubmittedToState(
      String email, String password) async {
    emit(RegisterState.loading());
    try {
      await _userRepository.signUp(email, password);
      User? currentUser = FirebaseAuth.instance.currentUser;
      final token = await FirebaseMessaging.instance.getToken();
      createUser(currentUser!.uid, email, token);
      return RegisterState.success();
    } catch (_) {
      return RegisterState.failure();
    }
  }
}
