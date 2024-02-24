import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';

abstract class ForgotEvent extends Equatable {
  const ForgotEvent();

  @override
  List<Object> get props => [];
}

// Eventos:
// EmailChanged
class EmailChanged extends ForgotEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged {email: $email}';
}

// Submitted
class Submitted extends ForgotEvent {
  final String email;

  const Submitted({
    required this.email,
  });

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'Submitted {email: $email}';
}
