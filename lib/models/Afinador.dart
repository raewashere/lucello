class Afinador {

  final double _cents;
  final String _nota;

  // Constructor
  Afinador({
    required double cents,
    required String nota,
  })  : _cents = cents,
        _nota = nota;

  // Getters para acceder a los atributos
  double get cents => _cents;
  String get nota => _nota;

}