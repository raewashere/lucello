import 'package:celloapp/models/Interpretacion.dart';
import 'package:celloapp/models/Usuario.dart';
import 'package:mysql_client/mysql_client.dart';

import '../models/Obra.dart';
import '../models/Retroalimentacion.dart';

class Retroalimentacion_controlador {

    Future<bool> registra_retroalimentacion(Interpretacion interpretacion, Retroalimentacion retro) async {
    MySQLConnection? conn;
    bool registroCorrecto = false;

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
        'INSERT INTO retroalimentacion ('
            'folio_interpretacion_retroalimentacion, '
            'perfil_retroalimentacion,'
            'afinadas,'
            'desafinadas,'
            'num_anomalias ) '
            'VALUES ( '
            ':folio_interpretacion_retroalimentacion, '
            ':perfil_retroalimentacion, '
            ':afinadas,'
            ':desafinadas,'
            ':num_anomalias)',
        {
          'folio_interpretacion_retroalimentacion': interpretacion.folioInterpretacion,
          'perfil_retroalimentacion': retro.perfilRetroalimentacion,
          'afinadas': retro.afinadas,
          'desafinadas': retro.desafinadas,
          'num_anomalias': retro.numAnomalias,
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
    return registroCorrecto;
  }
}
