import 'package:celloapp/models/Usuario.dart';
import 'package:celloapp/services/Usuario_controlador.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class vista_cuenta extends StatefulWidget {
  const vista_cuenta({super.key});

  @override
  State<StatefulWidget> createState() => _vistaCuentaState();
}

class _vistaCuentaState extends State<vista_cuenta> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? UsuarioActual = FirebaseAuth.instance.currentUser;
  final Usuario_controlador controlador = Usuario_controlador();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Future<Usuario?> usuario;
  Usuario? login;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _primerApellidoController = TextEditingController();
  final TextEditingController _segundoApellidoController = TextEditingController();

  Future<Usuario?> datos_usuario() async {
    final data = await controlador.obtener_usuario(UsuarioActual?.email);
    setState(() {
      login = data;
    });
    return data;
  }

  @override
  void initState() {
    super.initState();
    usuario = datos_usuario();
  }

  Future<void> _logout() async {
    try {
      _auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Saliendo de la aplicacion")),
      );
    } on FirebaseAuthException catch (e) {
      String mensajeError;

      // Verificar el tipo de error
      if (e.code == 'user-not-found') {
        mensajeError = 'No existe una cuenta con este correo electrónico.';
      } else if (e.code == 'wrong-password') {
        mensajeError = 'La contraseña es incorrecta.';
      } else if (e.code == 'invalid-email') {
        mensajeError = 'El correo electrónico no tiene un formato válido.';
      } else {
        mensajeError =
            'Error al iniciar sesión. Por favor, inténtelo de nuevo.';
      }
      // Mostrar un SnackBar con el mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensajeError)),
      );
    }
  }

  Future<void> cambiarContrasenia() async {
    try {
      _auth.sendPasswordResetEmail(email: "${UsuarioActual?.email}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Se ha enviado un enlace a tu correo para reestablecer tu contrasenia")),
      );
    } on FirebaseAuthException catch (e) {
      String mensajeError;

      // Verificar el tipo de error
      if (e.code == 'user-not-found') {
        mensajeError = 'No existe una cuenta con este correo electrónico.';
      } else if (e.code == 'wrong-password') {
        mensajeError = 'La contraseña es incorrecta.';
      } else if (e.code == 'invalid-email') {
        mensajeError = 'El correo electrónico no tiene un formato válido.';
      } else {
        mensajeError =
            'Error al iniciar sesión. Por favor, inténtelo de nuevo.';
      }
      // Mostrar un SnackBar con el mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensajeError)),
      );
    }
  }

  Future<void> borrarCuenta() async {
    try {
      await _abrirFormularioAutenticacion(context);
      controlador.borrar_usuario(UsuarioActual?.email);
      UsuarioActual?.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tu cuenta ha sido borrada")),
      );
    } on FirebaseAuthException catch (e) {
      String mensajeError;

      // Verificar el tipo de error
      if (e.code == 'user-not-found') {
        mensajeError = 'No existe una cuenta con este correo electrónico.';
      } else if (e.code == 'wrong-password') {
        mensajeError = 'La contraseña es incorrecta.';
      } else if (e.code == 'invalid-email') {
        mensajeError = 'El correo electrónico no tiene un formato válido.';
      } else {
        mensajeError =
            'Error al iniciar sesión. Por favor, inténtelo de nuevo.';
      }
      // Mostrar un SnackBar con el mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensajeError)),
      );
    }
  }

  Future<void> advertenciaBorradoCuenta(BuildContext context) async {
    showDialog(
      context: context,
      barrierColor: Theme.of(context).colorScheme.primaryContainer,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Advertencia"),
          shadowColor: Theme.of(context).colorScheme.errorContainer,
          surfaceTintColor: Theme.of(context).colorScheme.onPrimary,
          content: Text("¿Estas seguro de querer borrar tu cuenta?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                borrarCuenta();
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  // Método para abrir el formulario
  Future<void> _abrirFormularioAutenticacion(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Favor de autenticarte para poder borrar tu cuenta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Correo electrónico'),
                controller: _emailController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                controller: _passwordController,
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el formulario
              },
              child: Text('Cancelar',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
            TextButton(
              onPressed: () async {
                _auth.signInWithEmailAndPassword(
                    email: _emailController.text,
                    password: _passwordController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Se valido correctamente')),
                );

                // Lógica para guardar los datos del formulario
                Navigator.of(context)
                    .pop(); // Cierra el formulario después de guardar
              },
              child: Text('Guardar',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Theme.of(context).colorScheme.tertiary,
              margin: EdgeInsets.all(16),
              elevation: 4,
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        ProfilePicture(
                          name:
                               login != null ? '${login?.nombre} ${login?.primerApellido}':'Cargando...',
                          radius: 31,
                          fontsize: 21,
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                         Text(login != null ? 'Bienvenido ${login?.nombre}':'Cargando...',
                            style: Theme.of(context).textTheme.titleLarge),
                      ]),
                      SizedBox(height: 16),
                      Row(children: [
                        Icon(Icons.email,
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer),
                        Padding(padding: EdgeInsets.all(5)),
                        Text('${UsuarioActual?.email}'),
                      ]),
                    ],
                  )),
            ),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(Icons.dataset,
                  color: Theme.of(context).colorScheme.primary),
              title: Text("Gestion de cuenta",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              subtitle: Text("Modifica tus datos",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
              onTap: _abrirFormularioCambioDatos,
            ),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(Icons.history,
                  color: Theme.of(context).colorScheme.primary),
              title: Text("Reportes de analisis",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              subtitle: Text("Ve tus analisis anteriores",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
              onTap: (){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('En desarrollo')),
                );
              },
            ),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(Icons.password,
                  color: Theme.of(context).colorScheme.primary),
              title: Text("Recuperar contraseña",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              onTap: cambiarContrasenia,
            ),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.primary),
              title: Text("Salir",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              onTap: _logout,
            ),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(Icons.delete_forever,
                  color: Theme.of(context).colorScheme.primary),
              title: Text("Borrar cuenta",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              onTap: () {
                advertenciaBorradoCuenta(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _abrirFormularioCambioDatos() async {
    _nombreController.text = login!.nombre;
    _primerApellidoController.text = login!.primerApellido;
    _segundoApellidoController.text = login!.segundoApellido;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hacer sugerencia'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nombre'),
                controller: _nombreController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Primer apellido'),
                controller: _primerApellidoController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Segundo Apellido'),
                controller: _segundoApellidoController,
              ),
              // Agrega más campos según sea necesario
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el formulario
              },
              child: Text('Cancelar',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
            TextButton(
              onPressed: () async {
                login?.nombre = _nombreController.text;
                login?.primerApellido = _primerApellidoController.text;
                login?.segundoApellido = _segundoApellidoController.text;
                Usuario_controlador controladorUsuario =
                Usuario_controlador();
                bool correcto =
                await controladorUsuario.actualizar_usuario(login!);
                if (!correcto) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Hubo un error al actualizar')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Se actualizo correctamente')),
                  );
                }
                // Lógica para guardar los datos del formulario
                Navigator.of(context)
                    .pop(); // Cierra el formulario después de guardar
              },
              child: Text('Guardar',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
          ],
        );
      },
    );
  }
}
