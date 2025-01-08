import 'dart:convert'; // Para trabajar con JSON
import 'dart:io';
import 'package:celloapp/models/Afinador.dart';
import 'package:celloapp/models/Analisis.dart';
import 'package:celloapp/models/Anomalia.dart';
import 'package:celloapp/models/Desafinada.dart';
import 'package:celloapp/models/Retroalimentacion.dart';
import 'package:celloapp/services/Retroalimentacion_controlador.dart';
import 'package:http/http.dart' as http;

import '../models/Interpretacion.dart';
import '../models/Obra.dart';
import '../models/Usuario.dart';
import 'Interpretacion_controlador.dart';

class ApiService {
  //final String baseUrl = "http://20.102.104.104:8080/api";

  //vm
  final String baseUrl = "http://52.175.208.212:5000";

  //final String baseUrl = "http://192.168.0.131:5000";

  //final String baseUrl = "http://192.168.126.97:5000";

  Future<String> hola() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/hola'));

      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        return decodedJson['nombre']; // Accede al arreglo dentro del mapa
      } else {
        throw Exception('Error al obtener datos: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Ocurrió un error: $e');
    }
  }

  Future<Afinador> afinador(File audioData) async {
    try {
      // Crea la solicitud Multipart
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/afinador'));

      // Añade el archivo al cuerpo de la solicitud
      request.files.add(await http.MultipartFile.fromPath(
        'audio', // Nombre del campo esperado por el servidor
        audioData.path,
      ));

      // Envía la solicitud
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Procesa la respuesta JSON
        final String responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> decodedJson = json.decode(responseBody);

        // Crea el objeto Afinador a partir de la respuesta
        final Afinador afinador = Afinador(
          cents: decodedJson['cents'],
          nota: decodedJson['nota'],
        );

        return afinador;
      } else {
        throw Exception('Error al subir el archivo: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Ocurrió un error: $e');
    }
  }

  Future<Analisis> analizar(File audioData, Obra obra, Usuario usuario) async {
    try {
      Interpretacion_controlador interpretacion_controlador =
          new Interpretacion_controlador();
      Retroalimentacion_controlador retroalimentacion_controlador =
      new Retroalimentacion_controlador();

      Interpretacion? interpretacion = await interpretacion_controlador
          .registra_interpretacion(audioData.path, usuario, obra);

      Retroalimentacion retro;

      // Crea la solicitud Multipart
      List<double> tiempos;
      var request = http.MultipartRequest(
          'POST', Uri.parse('$baseUrl/analizar_compases'));

      request.fields.addAll({
        'pieza': obra.perfilComportamiento ??
            "", // Si es null, se envía una cadena vacía
        'numerador':
            obra.numerador?.toString() ?? "", // Usa operador null-aware
        'denominador': obra.denominador?.toString() ?? "",
        'compases_esperados': obra.num_compases?.toString() ?? "",
        'usuario': usuario.folioUsuario.toString() ?? ""
      });

      // Añade el archivo al cuerpo de la solicitud
      request.files.add(await http.MultipartFile.fromPath(
        'audio', // Nombre del campo esperado por el servidor
        audioData.path,
      ));

      // Envía la solicitud
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Procesa la respuesta JSON
        final String responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> decodedJson = json.decode(responseBody);

        final List<Desafinada> desafinadas =
            (decodedJson['desafinadas'] as List)
                .map((desafinadaJson) => Desafinada.fromJson(desafinadaJson))
                .toList();

        final List<Anomalia> anomalias = (decodedJson['anomalias'] as List)
            .map((anomaliaJson) => Anomalia.fromJson(anomaliaJson))
            .toList();

        if (decodedJson['tiempos'] is List) {
          tiempos = List<double>.from(
            (decodedJson['tiempos'] as List).map((e) => e.toDouble()),
          );
        } else {
          tiempos = []; // Valor predeterminado en caso de error.
        }

        final Analisis analisis = Analisis(
          total_notas: decodedJson['total_notas'],
          bpm: decodedJson['bpm'],
          bpm_ajustado: decodedJson['bpm_ajustado'],
          porcentaje_afinadas: decodedJson['porcentaje_acertadas'],
          porcentaje_desafinadas: decodedJson['porcentaje_desafinadas'],
          anomalias: anomalias,
          tiempos: tiempos,
          desafinadas: desafinadas,
          ruta_retro: decodedJson['ruta_retro'],
          afinadas: decodedJson['afinadas']
        );

        retro = new Retroalimentacion(folioRetroalimentacion: 0, folioInterpretacionRetroalimentacion: interpretacion!.folioInterpretacion, perfilRetroalimentacion: analisis.ruta_retro, afinadas: analisis.afinadas, desafinadas: analisis.desafinada.length, numAnomalias: analisis.anomalias.length);

        retroalimentacion_controlador.registra_retroalimentacion(interpretacion,retro);

        return analisis;
      } else {
        if (response.statusCode == 400) {
          print('Faltaron parametros: ${request.fields}');
          throw Exception('Faltaron parametros:  ${request.fields}');
        } else {
          throw Exception('Error al subir el archivo: ${response.statusCode}');
        }
      }
    } catch (e) {
      print(e);
      throw Exception('Ocurrió un error: $e');
    }
  }
}
