import 'package:celloapp/models/Anomalia.dart';

import 'Desafinada.dart';

class Analisis{
  final int _total_notas;
  final double _bpm;
  final double _bpm_ajustado;
  final double _porcentaje_afinadas;
  final double _porcentaje_desafinadas;
  final List<Anomalia> _anomalias;
  final List<Desafinada> _desafinadas;
  final List<double> _tiempos;
  final String _ruta_retro;
  final int _afinadas;

  // Constructor
  Analisis({
    required int total_notas,
    required double bpm,
    required double bpm_ajustado,
    required double porcentaje_afinadas,
    required double porcentaje_desafinadas,
    required List<Anomalia> anomalias,
    required List<Desafinada> desafinadas,
    required List<double> tiempos,
    required String ruta_retro,
    required int afinadas
  })  :
        _total_notas = total_notas,
        _bpm = bpm,
        _bpm_ajustado = bpm_ajustado,
        _porcentaje_afinadas = porcentaje_afinadas,
        _porcentaje_desafinadas = porcentaje_desafinadas,
        _anomalias = anomalias,
        _desafinadas = desafinadas,
        _tiempos = tiempos,
        _ruta_retro = ruta_retro,
        _afinadas = afinadas
  ;

  // Getters para acceder a los atributos
  int get total_notas => _total_notas;
  double get bpm => _bpm;
  double get bpm_ajustado => _bpm_ajustado;
  double get porcentaje_afinadas => _porcentaje_afinadas;
  double get porcentaje_desfinadas => _porcentaje_desafinadas;
  List<Anomalia>  get anomalias => _anomalias;
  List<Desafinada>  get desafinada => _desafinadas;
  List<double>  get tiempos => _tiempos;
  String get ruta_retro => _ruta_retro;
  int get afinadas => _afinadas;
}