import 'package:celloapp/models/Interpretacion.dart';
import 'package:celloapp/models/Usuario.dart';
import 'package:mysql_client/mysql_client.dart';

import '../models/Obra.dart';

class Interpretacion_controlador {

  Future<Interpretacion?> registra_interpretacion(
      String ruta_interpretacion, Usuario usuario, Obra obra) async {
    MySQLConnection? conn;
    bool registroCorrecto = false;
    Interpretacion? interpretacion;

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
        'INSERT INTO interpretacion ('
            'folio_usuario_interpretacion, '
            'folio_obra_interpretacion, '
            'fecha_interpretacion,'
            'ruta_interpretacion ) '
            'VALUES ( '
            ':folio_usuario_interpretacion, '
            ':folio_obra_interpretacion, '
            'DATE_SUB(NOW(), INTERVAL 6 HOUR) , '
            ':ruta_interpretacion)',
        {
          'folio_usuario_interpretacion': usuario.folioUsuario,
          'folio_obra_interpretacion': obra.folioObra,
          'ruta_interpretacion': ruta_interpretacion,
        },

      );
       registroCorrecto = true;
    } catch (e) {
      print("Error al conectar o consultar la base de datos: $e");
    } finally {
      if (conn != null) {
        await conn.close();
        print("Conexión cerrada");
      }
    }

    interpretacion = await obtener_interpretacion(usuario.folioUsuario, obra.folioObra, ruta_interpretacion);


    return registroCorrecto ? interpretacion:null ;
  }

  Future<Interpretacion?> obtener_interpretacion(int folio_usuario, int folio_obra, String ruta_interpretacion) async {
    MySQLConnection? conn;
    Interpretacion? interpretacion; // Mueve la declaración de `obras` fuera del bloque `try`
    String consulta = '';
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

      consulta =
      'SELECT folio_interpretacion, folio_usuario_interpretacion, folio_obra_interpretacion, fecha_interpretacion, ruta_interpretacion        '
          'FROM interpretacion where folio_usuario_interpretacion = ${folio_usuario} and folio_obra_interpretacion = ${folio_obra} and ruta_interpretacion = "${ruta_interpretacion}" order by folio_interpretacion DESC';

      print(consulta);

      var result = await conn.execute(consulta);

      for (final row in result.rows) {
        final Map<String, String?> rowMap = row.assoc();

        interpretacion = Interpretacion(
            folioInterpretacion: int.parse(rowMap['folio_interpretacion']!),
            folioObraInterpretacion: int.parse(rowMap['folio_obra_interpretacion']!),
            folioUsuarioInterpretacion: int.parse(rowMap['folio_usuario_interpretacion']!),
            fechaInterpretacion: DateTime.parse(rowMap['fecha_interpretacion']!),
            rutaInterpretacion: rowMap['ruta_interpretacion']!
            );
      }
    } catch (e) {
      print("Error al conectar o consultar la base de datos: $e");
    } finally {
      if (conn != null) {
        await conn.close();
        print("Conexión cerrada");
      }
    }
    return interpretacion;
  }
}
