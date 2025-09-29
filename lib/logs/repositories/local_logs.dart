import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:app_mig01/logs/entiti/log.dart';
import 'package:app_mig01/logs/interfas_logs.dart';

class LocalLogs implements InterfasLogs {
  static const String fileName = 'local_logs.txt';

  // Obtiene la ruta del archivo local y lo crea si no existe
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');

    // Si no existe, lo crea vacío
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }
    return file;
  }

  @override
  void puchLog(Log inLog) async {
    final file = await _getFile();
    await file.writeAsString(
      "${inLog.toString()}\n",
      mode: FileMode.append,
    );
  }

  /// Lee todo el contenido del archivo como String
  Future<String> readAllLogs() async {
    final file = await _getFile();
    return await file.readAsString();
  }

  /// Devuelve los logs como lista de strings (línea por línea)
  Future<List<String>> readLogsAsList() async {
    final file = await _getFile();
    return await file.readAsLines();
  }
}