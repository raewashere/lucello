class Interpretacion {
  int _folioInterpretacion;
  int _folioUsuarioInterpretacion;
  int _folioObraInterpretacion;
  DateTime _fechaInterpretacion;
  String _rutaInterpretacion;

  // Constructor
  Interpretacion({
    required int folioInterpretacion,
    required int folioUsuarioInterpretacion,
    required int folioObraInterpretacion,
    required DateTime fechaInterpretacion,
    required String rutaInterpretacion,
  })  : _folioInterpretacion = folioInterpretacion,
        _folioUsuarioInterpretacion = folioUsuarioInterpretacion,
        _folioObraInterpretacion = folioObraInterpretacion,
        _fechaInterpretacion = fechaInterpretacion,
        _rutaInterpretacion = rutaInterpretacion;

  // Getters
  int get folioInterpretacion => _folioInterpretacion;
  int get folioUsuarioInterpretacion => _folioUsuarioInterpretacion;
  int get folioObraInterpretacion => _folioObraInterpretacion;
  DateTime get fechaInterpretacion => _fechaInterpretacion;
  String get rutaInterpretacion => _rutaInterpretacion;

  // Setters
  set folioInterpretacion(int value) {
    _folioInterpretacion = value;
  }

  set folioUsuarioInterpretacion(int value) {
    _folioUsuarioInterpretacion = value;
  }

  set folioObraInterpretacion(int value) {
    _folioObraInterpretacion = value;
  }

  set fechaInterpretacion(DateTime value) {
    _fechaInterpretacion = value;
  }

  set rutaInterpretacion(String value) {
    _rutaInterpretacion = value;
  }

  // Método para convertir la clase a un Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'folio_interpretacion': _folioInterpretacion,
      'folio_usuario_interpretacion': _folioUsuarioInterpretacion,
      'folio_obra_interpretacion': _folioObraInterpretacion,
      'fecha_interpretacion': _fechaInterpretacion.toIso8601String(),
      'ruta_interpretacion': _rutaInterpretacion,
    };
  }

  // Método para crear una instancia desde un Map (JSON)
  factory Interpretacion.fromJson(Map<String, dynamic> json) {
    return Interpretacion(
      folioInterpretacion: json['folio_interpretacion'],
      folioUsuarioInterpretacion: json['folio_usuario_interpretacion'],
      folioObraInterpretacion: json['folio_obra_interpretacion'],
      fechaInterpretacion: DateTime.parse(json['fecha_interpretacion']),
      rutaInterpretacion: json['ruta_interpretacion'],
    );
  }
}
