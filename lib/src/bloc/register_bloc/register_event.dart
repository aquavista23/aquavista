import 'package:equatable/equatable.dart';
// import 'package:meta/meta.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

// Eventos:
// NameChanged
class NameChanged extends RegisterEvent {
  final String name;

  const NameChanged({required this.name});

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'NameChanged {name: $name}';
}

// Eventos:
// FNameChanged
class FNameChanged extends RegisterEvent {
  final String fName;

  const FNameChanged({required this.fName});

  @override
  List<Object> get props => [fName];

  @override
  String toString() => 'FNameChanged {fName: $fName}';
}

// Eventos:
// EmailChanged
class EmailChanged extends RegisterEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged {email: $email}';
}

// PasswordChanged
class PasswordChanged extends RegisterEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged {password: $password}';
}

// Submitted
class Submitted extends RegisterEvent {
  final String email;
  final String password;
  final String name;
  final String fName;

  const Submitted(
      {required this.email,
      required this.password,
      required this.name,
      required this.fName});

  @override
  List<Object> get props => [email, password, name, fName];

  @override
  String toString() => 'Submitted {email: $email, password: $password}';
}
