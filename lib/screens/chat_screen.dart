import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../api/enviar_data.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IO.Socket socket;

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();

  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    socket = IO.io(
      "http://127.0.0.1:3007", // cambiarlo a localhost 👈 Cambia por tu IP local si usas dispositivo real
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print("✅ Conectado al servidor");
    });

    socket.on("mensaje", (data) {
      setState(() {
        _messages.add({
          "id": data["id"],
          "texto": data["texto"],
        });
      });
    });
  }

  void sendMessage() async  {
    print("${_controllerName.text} ${_controller.text}");
    //await enviarDatos(_controllerName.text,_controller.text);
    if (_controller.text.trim().isEmpty) return;
    socket.emit("mensaje", _controller.text.trim());
    _controller.clear();
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat en Tiempo Real")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return ListTile(
                  leading: const Icon(Icons.message),
                  title: Text(msg["texto"]),
                  subtitle: Text("Usuario: ${msg["id"]}"),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                //  SizedBox(
                //   width: double.infinity,
                //   height: 60,
                //       child: TextField(
                //         controller: _controllerName,
                //         decoration: const InputDecoration(
                //           hintText: "Escribe tu nombre",
                //           border: OutlineInputBorder(),
                //         ),
                //       ),
                //  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Escribe un mensaje...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: sendMessage,
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
