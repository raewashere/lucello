class Desafinada {
  String _nota;
  double _cents;
  int? _compas;

  // Constructor
  Desafinada({
    required String nota,
    required double cents,
    int? compas,
  })  : _nota = nota,
        _cents = cents,
        _compas = compas;

  factory Desafinada.fromJson(Map<String, dynamic> json) {
    return Desafinada(
      nota: json['nota'],
      cents: json['cents']
    );
  }

  // Getter y Setter para nota
  String get nota => _nota;
  set nota(String value) {
    _nota = value;
  }

  // Getter y Setter para cents
  double get cents => _cents;
  set cents(double value) {
    _cents = value;
  }

  // Getter y Setter para compas
  int? get compas => _compas;
  set compas(int? value) {
    _compas = value;
  }

  @override
  String toString() {
    return 'Desafinada(nota: $_nota, cents: $_cents, compas: $_compas)';
  }
}
