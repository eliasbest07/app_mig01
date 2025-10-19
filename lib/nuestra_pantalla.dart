import 'package:app_mig01/logs/repositories/local_logs.dart';
import 'package:app_mig01/screens/chat_screen.dart';
import 'package:app_mig01/screens/main_screens.dart';
import 'package:app_mig01/widgets/cronometro.dart';
import 'package:flutter/material.dart';

class NuestraPantalla extends StatelessWidget {
  const NuestraPantalla({super.key, required this.inSize});
  final Size inSize;

void functionOnPressed() async {

 LocalLogs logRepository = LocalLogs(); 

 String datosLogs =  await logRepository.readAllLogs();

  print("Estos son los datos guardados en Logs: \n $datosLogs");

}

  @override
  Widget build(BuildContext context) {

    return Scaffold( //Pantalla

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Nuestra pantalla"),
      ),

// Column Row Stack Wrap 

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        
        GestureDetector(

          onLongPress: (){

            print('se preciono por mucho tiempo' );

          },

          onDoubleTap: (){

            print('se preciono dos veces' );

          },
          child: const Text('Todo en Flutter son Widgets')
          
        ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            
              MaterialButton(
                onPressed: (){
                  print("Hola mundo estas precionando el boton 2");
                  Navigator.push(context, 
                  MaterialPageRoute(
                    builder: (context) { return  CountdownExample();  }
                  ));
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.blue,
                  size: 80,
                  ),
              ),

                MaterialButton(
                onPressed: functionOnPressed,
                child: const Text("Presioname "),
              ),
            ],
          ),
          Stack(
            children: [ 
              Container( 
            height: 180,
            width: 180,
            color: Colors.black,
          ),
          Positioned(
            top: 50,
            left: 50,
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage(),));
              },
              child: Container(
               // margin: const EdgeInsets.all(20),
               // padding: const EdgeInsets.only(left: 20),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: const Center(child: Text('Chat', style: TextStyle(color: Colors.white),)),
              ),
            ),
          )
            ],
          ),

          
        ],
      ),

      bottomNavigationBar: Container(
        height: 60,
        color: Colors.red,
      ),
    );
  }
}