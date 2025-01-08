import 'package:celloapp/models/Interpretacion.dart';
import 'package:celloapp/models/Usuario.dart';
import 'package:mysql_client/mysql_client.dart';

import '../models/Obra.dart';
import '../models/Reporte.dart';
import '../models/Retroalimentacion.dart';

class Reporte_controlador {
  Future<List<Reporte>> obtener_reporte(Usuario usuario) async {
    MySQLConnection? conn;
    Interpretacion?
        interpretacion; // Mueve la declaración de `obras` fuera del bloque `try`
    String consulta = '';

    List<Reporte> lista_reporte = [];
    Reporte reporte;
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
          'SELECT '
              ' i.fecha_interpretacion, '
              ' i.ruta_interpretacion,'
              ' r.perfil_retroalimentacion,'
              ' r.afinadas,'
              ' r.desafinadas,'
              ' r.num_anomalias,'
              ' c.nombre_obra, '
              ' c.compositor '
              ' FROM interpretacion i '
              ' LEFT JOIN retroalimentacion r '
              ' ON i.folio_interpretacion = r.folio_interpretacion_retroalimentacion'
              ' LEFT JOIN catalogo c ON i.folio_obra_interpretacion = c.folio_obra    '
              ' WHERE  r.folio_retroalimentacion is not null and i.folio_usuario_interpretacion = ${usuario.folioUsuario} ';
      print(consulta);

      var result = await conn.execute(consulta);

      for (final row in result.rows) {
        final Map<String, String?> rowMap = row.assoc();

        reporte = Reporte(
            fechaInterpretacion: DateTime.parse(rowMap['fecha_interpretacion']!),
            rutaInterpretacion: rowMap['ruta_interpretacion']!,
            perfilRetroalimentacion: rowMap['perfil_retroalimentacion']!,
            afinadas: double.parse(rowMap['afinadas']!),
            desafinadas: double.parse(rowMap['desafinadas']!),
            numAnomalias: int.parse(rowMap['num_anomalias']!),
            nombreObra: rowMap['nombre_obra']!,
            compositor: rowMap['compositor']!);

        lista_reporte.add(reporte);
      }
    } catch (e) {
      print("Error al conectar o consultar la base de datos: $e");
    } finally {
      if (conn != null) {
        await conn.close();
        print("Conexión cerrada");
      }
    }
    return lista_reporte;
  }
}
