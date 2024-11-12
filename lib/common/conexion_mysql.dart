import 'package:mysql_client/mysql_client.dart';

class conexion_mysql {

  final conn = MySQLConnection.createConnection(
      host: "tt1-b050.mysql.database.azure.com",
      port: 3306,
      userName: "raymundo",
      password: "mysqlRTD98*21",
      databaseName: "cello",
      );

  late var _conexion = null;
  get conexion => _conexion;

  void conectar() async{
    try{
      _conexion = conn.connect();
    }
    catch (e) {
      print('Error al conectar: $e');
    }
  }

  void desconectar() async{
    try{
      _conexion.close();
    }
    catch (e) {
      print('Error al conectar: $e');
    }
  }

}

extension on Future<MySQLConnection> {
  connect() {}
}