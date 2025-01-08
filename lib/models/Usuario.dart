class Usuario {
  // Atributos privados
  late int _folioUsuario;
  late String _nombre;
  late String _primerApellido;
  late String _segundoApellido;
  late String _correoElectronico;

  // Constructor
  Usuario({
    required int folioUsuario,
    required String nombre,
    required String primerApellido,
    required String segundoApellido,
    required String correoElectronico,
  })  : _folioUsuario = folioUsuario,
        _nombre = nombre,
        _primerApellido = primerApellido,
        _segundoApellido = segundoApellido,
        _correoElectronico = correoElectronico;

  // Getters para acceder a los atributos
  int get folioUsuario => _folioUsuario;
  String get nombre => _nombre;
  String get primerApellido => _primerApellido;
  String get segundoApellido => _segundoApellido;
  String get correoElectronico => _correoElectronico;

  set nombre(String value) {
    _nombre = value; // Asignación correcta
  }

  set primerApellido(String value) {
    _primerApellido = value; // Asignación correcta
  }

  set segundoApellido(String value) {
    _segundoApellido = value; // Asignación correcta
  }
  @override
  String toString() {
    return 'Usuario(folioUsuario: $_folioUsuario, nombre: $_nombre, primerApellido: $_primerApellido, segundoApellido: $_segundoApellido, correoElectronico: $_correoElectronico)';
  }
}
