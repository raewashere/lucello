class Reporte {
  DateTime fechaInterpretacion;
  String rutaInterpretacion;
  String perfilRetroalimentacion;
  double afinadas;
  double desafinadas;
  int numAnomalias;
  String nombreObra;
  String compositor;

  // Constructor
  Reporte({
    required this.fechaInterpretacion,
    required this.rutaInterpretacion,
    required this.perfilRetroalimentacion,
    required this.afinadas,
    required this.desafinadas,
    required this.numAnomalias,
    required this.nombreObra,
    required this.compositor,
  });

  // Getters y Setters
  DateTime get getFechaInterpretacion => fechaInterpretacion;
  set setFechaInterpretacion(DateTime value) {
    fechaInterpretacion = value;
  }

  String get getRutaInterpretacion => rutaInterpretacion;
  set setRutaInterpretacion(String value) {
    rutaInterpretacion = value;
  }

  String get getPerfilRetroalimentacion => perfilRetroalimentacion;
  set setPerfilRetroalimentacion(String value) {
    perfilRetroalimentacion = value;
  }

  double get getAfinadas => afinadas;
  set setAfinadas(double value) {
    afinadas = value;
  }

  double get getDesafinadas => desafinadas;
  set setDesafinadas(double value) {
    desafinadas = value;
  }

  int get getNumAnomalias => numAnomalias;
  set setNumAnomalias(int value) {
    numAnomalias = value;
  }

  String get getNombreObra => nombreObra;
  set setNombreObra(String value) {
    nombreObra = value;
  }

  String get getCompositor => compositor;
  set setCompositor(String value) {
    compositor = value;
  }

  // Método para convertir la clase a un Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'fecha_interpretacion': fechaInterpretacion.toIso8601String(),
      'ruta_interpretacion': rutaInterpretacion,
      'perfil_retroalimentacion': perfilRetroalimentacion,
      'afinadas': afinadas,
      'desafinadas': desafinadas,
      'num_anomalias': numAnomalias,
      'nombre_obra': nombreObra,
      'compositor': compositor,
    };
  }

  // Método para crear una instancia desde un Map (JSON)
  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte(
      fechaInterpretacion: DateTime.parse(json['fecha_interpretacion']),
      rutaInterpretacion: json['ruta_interpretacion'],
      perfilRetroalimentacion: json['perfil_retroalimentacion'],
      afinadas: json['afinadas'].toDouble(),
      desafinadas: json['desafinadas'].toDouble(),
      numAnomalias: json['num_anomalias'],
      nombreObra: json['nombre_obra'],
      compositor: json['compositor'],
    );
  }
}
