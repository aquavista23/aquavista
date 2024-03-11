import 'dart:convert';

import 'package:aquavista/src/util/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WebSocketTest extends StatefulWidget {
  const WebSocketTest({Key? key}) : super(key: key);

  @override
  State<WebSocketTest> createState() => _WebSocketTestState();
}

class _WebSocketTestState extends State<WebSocketTest> {
  // final channel = WebSocketChannel.connect(
  //   Uri.parse('wss://192.168.4.1:80/'),
  // );

  Future<void> testESP() async {
    var response = await http
        .post(Uri.parse('http://192.168.4.1:80/login'),
            headers: {
              "Content-Type": "application/json;charSet=UTF-8",
            },
            body: jsonEncode({
              'username': 'admin',
              'password': 'admin',
            }))
        .then((onResponse) {
      debugPrint('>>>>>>>>> ${onResponse.body}');
    }).catchError((onerror) {
      debugPrint('?????????? $onerror');
    });
    debugPrint('<<<<<<<<<<<<<<<<<<<<<<<< ${response.statusCode}');
    if (response.statusCode == 200) {
      debugPrint("account created succesfully");
    } else {
      debugPrint('failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          title: const Text('prueba'),
        ),
        body: FutureBuilder<void>(
            future: testESP(),
            builder: (context, snapshot) {
              return Container();
            }));
  }
}

/*/ import 'package:aquavista/src/util/style.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketTest extends StatefulWidget {
  const WebSocketTest({Key? key}) : super(key: key);

  @override
  State<WebSocketTest> createState() => _WebSocketTestState();
}

class _WebSocketTestState extends State<WebSocketTest> {
  final TextEditingController _controller = TextEditingController();
  final _channel = IOWebSocketChannel.connect(
    Uri.parse('wss://192.168.4.1'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('prueba'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}



*/