import 'package:celloapp/models/Usuario.dart';
import 'package:mysql_client/mysql_client.dart';

class Usuario_controlador {
  Future<bool> registra_usuario(Usuario usuario) async {
    MySQLConnection? conn;
    bool registro_correcto = false;

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
        'INSERT INTO usuario (nombre, primer_apellido, segundo_apellido,correo_electronico, fecha_registro)'
        ' VALUES (:nombre, :primer_apellido, :segundo_apellido, :correo_electronico, NOW())',
        {
          'nombre': usuario.nombre,
          'primer_apellido': usuario.primerApellido,
          'segundo_apellido': usuario.segundoApellido,
          'correo_electronico': usuario.correoElectronico,
        },
      );
      registro_correcto = true;
    } catch (e) {
      print("Error al conectar o consultar la base de datos: $e");
    } finally {
      if (conn != null) {
        await conn.close();
        print("Conexión cerrada");
      }
    }

    return registro_correcto;
  }

  Future<Usuario?> obtener_usuario(String email) async {
    MySQLConnection? conn;
    Usuario? login ; // Mueve la declaración de `obras` fuera del bloque `try`

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
        "SELECT folio_usuario, nombre, primer_apellido, segundo_apellido, correo_electronico "
            "FROM usuario where correo_electronico =  $email",
      );

      for (final row in result.rows) {
        final Map<String, String?> rowMap = row.assoc();

       login = Usuario(
          folioUsuario: int.parse(rowMap['folio_usuario']!),
          nombre: rowMap['nombre']!,
          primerApellido: rowMap['primer_apellido']!,
          segundoApellido: rowMap['segundo_apellido']!,
          correoElectronico: rowMap['correo_electronico']!
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

    return login;
  }
}
