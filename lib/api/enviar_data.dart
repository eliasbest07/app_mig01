import 'package:http/http.dart' as http;
import 'dart:convert';

import '../logs/entiti/log.dart';
import '../logs/interfas_logs.dart';
import '../logs/repositories/local_logs.dart';

  final url = Uri.parse('http://192.168.1.45:3007/data'); // 👈 Cambia localhost si pruebas en un dispositivo físico

  InterfasLogs logRepository = LocalLogs(); // usar cualquier implementacion de InterfasLogs
  
  // POST API 
Future<void> enviarDatos(String nombre, String mensaje) async {

  final body = {
    'nombre': nombre,
    'mensaje': mensaje,
  };

  print("$nombre $mensaje");
  try {
    // Comienza
      Log log1 = Log(message: "se llamo al API endpoint /data",);
      // logRepository.puchLog(log1);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );

      Log log2 = Log(message: "estatus ${response.statusCode} API endpoint /data ",);
      // logRepository.puchLog(log2);
    if (response.statusCode == 200) {
      print('✅ Datos enviados correctamente');
      print('Respuesta: ${response.body}');
    } else {
      print('❌ Error: ${response.statusCode}');
      print('Cuerpo: ${response.body}');
    }

  } catch (e) {
    // Error log
      Log log1 = Log(message: "fallo el llamo al API endpoint /data con datos $nombre | $mensaje con el error $e",);
      // logRepository.puchLog(log1);

    print('⚠️ Error de conexión: $e');
  }
}
