import 'package:mysql_client/mysql_client.dart';

class Sugerencia {
  // Atributos privados
  final String _nombreObra;
  final String _compositor;
  final String? _comentario; // Puede ser nulo
  final String? _usuario; // Puede ser nulo

  // Constructor
  Sugerencia({
    required String nombreObra,
    required String compositor,
    String? comentario,
    String? usuario,
  })  : _nombreObra = nombreObra,
        _compositor = compositor,
        _comentario = comentario,
        _usuario = usuario;

  // Getters para acceder a los atributos
  String get nombreObra => _nombreObra;
  String get compositor => _compositor;
  String? get comentario => _comentario;
  String? get usuario => _usuario;
}
