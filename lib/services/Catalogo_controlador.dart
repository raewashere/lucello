import 'package:mysql_client/mysql_client.dart';
import '../models/Obra.dart';

class Catalogo_controlador {
  // Elimina el getter innecesario

  Future<List<Obra>> obtener_catalogo(int offset, int limit) async {
    MySQLConnection? conn;
    List<Obra> obras = []; // Mueve la declaración de `obras` fuera del bloque `try`

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

      var result = await conn.execute(
        "SELECT folio_obra, nombre_obra, compositor, estilo, dificultad, perfil_comportamiento "
            "FROM catalogo LIMIT $limit OFFSET $offset",
      );

      for (final row in result.rows) {
        final Map<String, String?> rowMap = row.assoc();

        obras.add(Obra(
          folioObra: int.parse(rowMap['folio_obra']!),
          nombreObra: rowMap['nombre_obra']!,
          compositor: rowMap['compositor']!,
          estilo: rowMap['estilo']!,
          dificultad: rowMap['dificultad']!,
          perfilComportamiento: rowMap['perfil_comportamiento'],
        ));
      }

      // Imprime las obras para verificar que se agregaron correctamente
      for (var obra in obras) {
        print(obra);
      }

    } catch (e) {
      print("Error al conectar o consultar la base de datos: $e");
    } finally {
      if (conn != null) {
        await conn.close();
        print("Conexión cerrada");
      }
    }

    return obras; // Devuelve la lista de obras
  }
}
