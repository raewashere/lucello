class Usuario {
  // Atributos privados
  final int _folioUsuario;
  final String _nombre;
  final String _primerApellido;
  final String _segundoApellido;
  final String _correoElectronico;

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

  @override
  String toString() {
    return 'Usuario(folioUsuario: $_folioUsuario, nombre: $_nombre, primerApellido: $_primerApellido, segundoApellido: $_segundoApellido, correoElectronico: $_correoElectronico)';
  }
}