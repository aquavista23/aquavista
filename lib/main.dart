import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:aquavista/src/screens/splash_screen.dart';
import 'package:aquavista/src/screens/home/home_screen.dart';
import 'package:aquavista/src/bloc/simple_bloc_delegate.dart';
import 'package:aquavista/src/repository/user_repository.dart';
import 'package:aquavista/src/screens/login/login_screen.dart';
import 'package:aquavista/src/bloc/authentication_bloc/bloc.dart';
import 'package:aquavista/src/repository/messaging_repository.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MessagingRepository().initNotifications();
  Bloc.observer = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();

  runApp(BlocProvider(
    create: (context) =>
        AuthenticationBloc(userRepository: userRepository)..add(AppStarted()),
    child: App(userRepository: userRepository),
  ));
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  const App({Key? key, required UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.white),
      navigatorKey: navigatorKey,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return const SplashScreen();
          }
          if (state is Authenticated) {
            return const HomeScreen();
          }
          if (state is Unauthenticated) {
            return LoginScreen(
              userRepository: _userRepository,
            );
          }
          return Container();
        },
      ),
    );
  }
}
