import 'package:aquavista/src/util/style.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketTest extends StatefulWidget {
  const WebSocketTest({Key? key}) : super(key: key);

  @override
  State<WebSocketTest> createState() => _WebSocketTestState();
}

class _WebSocketTestState extends State<WebSocketTest> {
  final channel = WebSocketChannel.connect(
    Uri.parse('192.168.4.1'),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text('prueba'),
      ),
      body: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            return Text(snapshot.hasData ? '${snapshot.data}' : '');
          }),
    );
  }
}
