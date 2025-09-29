import 'package:flutter/material.dart';

class MainScreens extends StatefulWidget {
  const MainScreens({super.key});

  @override
  State<MainScreens> createState() => _MainScreensState();
}

class _MainScreensState extends State<MainScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          
          children: [
            Text('Pregunta del dia ' + DateTime.now().toString().substring(0,10)),

            Text('Pregunta, tienes 2 segundos para elegir: ¿Cuanto es 2 + 2?'),
            ElevatedButton(
              onPressed: () {
                print('Respuesta incorrecta');
              },
              child: const Text('3'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Respuesta incorrecta');
              },
              child: const Text('5'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Respuesta incorrecta');
              },
              child: const Text('6'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Respuesta correcta');
              },
              child: const Text('4'),
            ),
          ],
        ),
      ),
    );
  }
}
//-------------------------------------------------------------
class Contenedor extends StatelessWidget {
  const Contenedor({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}