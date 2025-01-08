class Retroalimentacion {
  int folioRetroalimentacion;
  int folioInterpretacionRetroalimentacion;
  String perfilRetroalimentacion;
  int afinadas;
  int desafinadas;
  int numAnomalias;

  // Constructor
  Retroalimentacion({
    required this.folioRetroalimentacion,
    required this.folioInterpretacionRetroalimentacion,
    required this.perfilRetroalimentacion,
    required this.afinadas,
    required this.desafinadas,
    required this.numAnomalias,
  });

  // Getters y Setters
  int get getFolioRetroalimentacion => folioRetroalimentacion;
  set setFolioRetroalimentacion(int value) {
    folioRetroalimentacion = value;
  }

  int get getFolioInterpretacionRetroalimentacion => folioInterpretacionRetroalimentacion;
  set setFolioInterpretacionRetroalimentacion(int value) {
    folioInterpretacionRetroalimentacion = value;
  }

  String get getPerfilRetroalimentacion => perfilRetroalimentacion;
  set setPerfilRetroalimentacion(String value) {
    perfilRetroalimentacion = value;
  }

  int get getAfinadas => afinadas;
  set setAfinadas(int value) {
    afinadas = value;
  }

  int get getDesafinadas => desafinadas;
  set setDesafinadas(int value) {
    desafinadas = value;
  }

  int get getNumAnomalias => numAnomalias;
  set setNumAnomalias(int value) {
    numAnomalias = value;
  }

  // Método para convertir la clase a un Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'folio_retroalimentacion': folioRetroalimentacion,
      'folio_interpretacion_retroalimentacion': folioInterpretacionRetroalimentacion,
      'perfil_retroalimentacion': perfilRetroalimentacion,
      'afinadas': afinadas,
      'desafinadas': desafinadas,
      'num_anomalias': numAnomalias,
    };
  }

  // Método para crear una instancia desde un Map (JSON)
  factory Retroalimentacion.fromJson(Map<String, dynamic> json) {
    return Retroalimentacion(
      folioRetroalimentacion: json['folio_retroalimentacion'],
      folioInterpretacionRetroalimentacion: json['folio_interpretacion_retroalimentacion'],
      perfilRetroalimentacion: json['perfil_retroalimentacion'],
      afinadas: json['afinadas'],
      desafinadas: json['desafinadas'],
      numAnomalias: json['num_anomalias'],
    );
  }
}
