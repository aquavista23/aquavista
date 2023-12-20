import 'package:aquavista/src/screens/setting.dart';
import 'package:aquavista/src/util/constantes.dart';
import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final IconData icon;
  final String heading;
  final Color color;
  final Color backColor;
  final String route;
  final dynamic params;

  const Tile({
    Key? key,
    required this.icon,
    required this.heading,
    required this.color,
    required this.backColor,
    required this.route,
    required this.params,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backColor.withOpacity(0.6),
      elevation: 6.0,
      shadowColor: const Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: () {
          switch (route) {
            case AJUSTES:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Setting()),
              );
              break;
            default:
          }

          // Navigator.pushNamed(context, route, arguments: params);
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      heading,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: color,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Material(
                      color: color,
                      borderRadius: BorderRadius.circular(24.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
