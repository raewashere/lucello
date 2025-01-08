import 'package:celloapp/models/Sugerencia.dart';
import 'package:celloapp/models/Usuario.dart';
import 'package:celloapp/services/Usuario_controlador.dart';
import 'package:mysql_client/mysql_client.dart';

class Sugerencia_controlador {
  Future<bool> registra_sugerencia(Sugerencia sugerencia) async {
    MySQLConnection? conn;
    bool registroCorrecto = false;
    int? folioUsuario = 0;

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

      Usuario_controlador usuario_controlador = Usuario_controlador();
      Usuario? consultaUsuario =
          await usuario_controlador.obtener_usuario(sugerencia.usuario);

      folioUsuario = consultaUsuario?.folioUsuario;

      var result = await conn.execute(
        'INSERT INTO sugerencia (nombre_obra, compositor, comentario,fecha_sugerencia, folio_usuario_sugerencia)'
        ' VALUES (:nombre_obra, :compositor, :comentario, DATE_SUB(NOW(), INTERVAL 6 HOUR),:folio_usuario)',
        {
          'nombre_obra': sugerencia.nombreObra,
          'compositor': sugerencia.compositor,
          'comentario': sugerencia.comentario,
          'folio_usuario': folioUsuario != null ? folioUsuario : 13
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
