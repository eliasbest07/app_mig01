import 'package:app_mig01/logs/entiti/log.dart';
import 'package:app_mig01/logs/interfas_logs.dart';
import 'package:app_mig01/logs/repositories/local_logs.dart';
import 'package:app_mig01/nuestra_pantalla.dart';
import 'package:flutter/material.dart';



void main() {

int number = 10; // tipado

//Node.js servidor BACKEND 

int? nullableNumber; // null safety

String texto = "Hola mundo"; 

final dinamica; // se asigna una sola vez

print(nullableNumber);

final List<String> nombres = ["Juan", "Pedro", "Maria"];
  
  dinamica = number + 5;
  nullableNumber = dinamica;

  print(nullableNumber);
  
//llamados a la API Develop Prod
// que variables usar 
//tomar datos de internet
// inicilizar
// antes de que corra la app 
// validar si hay internet 

// ve cual idiomar del dispositivo
//log("antes de correr la app");
// deterctar tamano de la pantalla
// detectar idioma del dispositivo
// log("despues de correr la app"); BACKEND 
// ficheros para el idioma
// consumir espacio de memoria logs \

  WidgetsFlutterBinding.ensureInitialized();

  Log log1 = Log(message: "antes de correr la app",);

  InterfasLogs logRepository = LocalLogs(); // usar cualquier implementacion de InterfasLogs

  logRepository.puchLog(log1);

  runApp(const MyApp()); // ejecutar la app

}

//ESTADO 
//SIN ESTADO -> StatelessWidget

// release 20mb listo para producion
// debug 100mb en desarollo 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // MediaQuery -> informacion del dispositivo
    final Size size = MediaQuery.of(context).size;

    print(size);
    // 3 tipos de tama;os
    // small < 600 pequeño
    // medium 600 - 1200 mediano  
    // large > 1200 grande

    // Stream -> flujo de datos
    
    return MaterialApp(
      title: 'No lo ve el usuario',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 183, 112, 58)),
        useMaterial3: true,
      ),
      home: NuestraPantalla(inSize:size),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
