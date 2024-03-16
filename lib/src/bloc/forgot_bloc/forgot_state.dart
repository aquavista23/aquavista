// import 'package:meta/meta.dart';

class ForgotState {
  final bool isEmailValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  bool get isFormValid => isEmailValid;

  ForgotState(
      {required this.isEmailValid,
      required this.isSubmitting,
      required this.isSuccess,
      required this.isFailure});

  // Estados:
  // Empty - vacio
  factory ForgotState.empty() {
    return ForgotState(
        isEmailValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }

  // Loading - cargando
  factory ForgotState.loading() {
    return ForgotState(
        isEmailValid: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false);
  }

  // Failure - falla
  factory ForgotState.failure() {
    return ForgotState(
        isEmailValid: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true);
  }

  // Sucess - exito
  factory ForgotState.success() {
    return ForgotState(
        isEmailValid: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false);
  }

  // Update y copywith
  ForgotState copyWith(
      {bool? isEmailValid,
      bool? isPasswordValid,
      bool? isSubmitting,
      bool? isSuccess,
      bool? isFailure}) {
    return ForgotState(
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure);
  }

  ForgotState update({bool? isEmailValid}) {
    return copyWith(
        isEmailValid: isEmailValid,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }

  @override
  String toString() {
    return ''' ForgotState{
      isEmailValid: $isEmailValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure
    }
    ''';
  }
}
