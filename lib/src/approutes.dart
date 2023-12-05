import 'package:aquavista/src/screens/home/home_screen.dart';
import 'package:aquavista/src/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'T-POS',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: routes,
    );
  }

  Route<Widget> routes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) {
          //return Loginscreen();
          //return Principal();
          //return TransferenciaProductoscreen();
          return const SplashScreen();
        });
      // case AJUSTES:
      //   return MaterialPageRoute(builder: (context) {
      //     List<dynamic>? arguments = settings.arguments as List?;

      //   });
      default:
        return MaterialPageRoute(builder: (context) {
          //return Loginscreen();
          return const HomeScreen();
          //return TransferenciaProductoscreen();
          // return LoadingMainscreen();
        });
    }
  }
}
