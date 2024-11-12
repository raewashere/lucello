import 'package:mysql_client/mysql_client.dart';

class Obra {
  // Atributos privados
  final int _folioObra;
  final String _nombreObra;
  final String _compositor;
  final String _estilo;
  final String _dificultad;
  final String? _perfilComportamiento; // Puede ser nulo

  // Constructor
  Obra({
    required int folioObra,
    required String nombreObra,
    required String compositor,
    required String estilo,
    required String dificultad,
    String? perfilComportamiento,
  })  : _folioObra = folioObra,
        _nombreObra = nombreObra,
        _compositor = compositor,
        _estilo = estilo,
        _dificultad = dificultad,
        _perfilComportamiento = perfilComportamiento;

  // Getters para acceder a los atributos
  int get folioObra => _folioObra;
  String get nombreObra => _nombreObra;
  String get compositor => _compositor;
  String get estilo => _estilo;
  String get dificultad => _dificultad;
  String? get perfilComportamiento => _perfilComportamiento;

  @override
  String toString() {
    return 'Obra(folioObra: $_folioObra, nombreObra: $_nombreObra, compositor: $_compositor, estilo: $_estilo, dificultad: $_dificultad, perfilComportamiento: $_perfilComportamiento)';
  }
}


// Ejemplo de uso
Future<void> main() async {
// Intenta crear y conectar a la base de datos MySQL
  MySQLConnection? conn;
  try {
    conn = await MySQLConnection.createConnection(
      host: "tt1-b050.mysql.database.azure.com",
      port: 3306,
      userName: "raymundo",
      password: "mysqlRTD98*21",
      databaseName: "cello",
    );

    await conn.connect();
    print("Conexión exitosa a la base de datos");

    // Realiza la consulta y llena la lista de objetos Obra
    List<Obra> listaObras = [];
    var result = await conn.execute(
        "SELECT folio_obra, nombre_obra, compositor, estilo, dificultad, perfil_comportamiento FROM catalogo");

    // Itera sobre los resultados y crea una lista de objetos Obra
    for (final row in result.rows) {
      Obra obra = Obra(
        folioObra: int.parse(row.colAt(0)!),
        nombreObra: row.colAt(1)!,
        compositor: row.colAt(2)!,
        estilo: row.colAt(3)!,
        dificultad: row.colAt(4)!,
        perfilComportamiento: row.colAt(5)!,
      );
      listaObras.add(obra);
    }

    // Muestra la lista de obras
    for (var obra in listaObras) {
      print(obra);
    }
  } catch (e) {
    print("Error al conectar o consultar la base de datos: $e");
  } finally {
    // Cierra la conexión si se estableció
    if (conn != null) {
      await conn.close();
      print("Conexión cerrada");
    }
  }
}
