class Anomalia{
  final double _duracion;
  final double _frecuencia;
  final double _inicio;

  // Constructor
  Anomalia({
    required double duracion,
    required double frecuencia,
    required double inicio,
  })  : _duracion = duracion,
        _frecuencia = frecuencia,
        _inicio = inicio
        ;

  factory Anomalia.fromJson(Map<String, dynamic> json) {
    return Anomalia(
      inicio: json['Inicio'],
      duracion: json['Duración'],
      frecuencia: json['Frecuencia'],
    );
  }

  // Getters para acceder a los atributos
  double get duracion => _duracion;
  double get frecuencia => _frecuencia;
  double get inicio => _inicio;
}