import 'dart:async';
import 'package:flutter/material.dart';

import 'package:aquavista/src/util/style.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';

class CheckConecction extends StatefulWidget {
  final String validator;
  const CheckConecction({Key? key, required this.validator}) : super(key: key);

  @override
  State<CheckConecction> createState() => _CheckConecctionState();
}

class _CheckConecctionState extends State<CheckConecction> {
  final TextEditingController _validatorController = TextEditingController();
  bool validateChance = false;
  bool activeButton = false;
  int countDown = 60;
  late Timer _timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (countDown == 0) {
          setState(() {
            timer.cancel();
            Navigator.of(context).pop();
          });
        } else {
          setState(() {
            countDown--;
          });
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    startTimer();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: const Text('Agregar Dispositivo'),
        backgroundColor: mainColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 250,
              child: TextFormField(
                controller: _validatorController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.5),
                  labelText: 'Insetar código',
                ),
                keyboardType: TextInputType.number,
                autocorrect: false,
                autovalidateMode: AutovalidateMode.always,
                validator: (_) {
                  return validateChance ? 'código Incorrecto' : null;
                },
                onChanged: (value) {
                  bool aux = false;
                  bool auxActiveButton = false;
                  if (value.isNotEmpty) {
                    aux = false;
                    if (value.length >= 5) {
                      auxActiveButton = true;
                    }
                  } else {
                    aux = true;
                  }

                  setState(() {
                    validateChance = aux;
                    activeButton = auxActiveButton;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Inserte código de verificación',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Caduca en: $countDown',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: (activeButton) ? Colors.green : Colors.grey,
              ),
              onPressed: () async {
                if (activeButton) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (Route<dynamic> route) => false);
                }
              },
              child: const Text('Validar'),
            )
          ],
        ),
      ),
    );
  }
}
