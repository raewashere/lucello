import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class vista_contrasenia extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _vistaContraseniaState ();
}

class _vistaContraseniaState extends State<vista_contrasenia> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formularioCorreo = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recupera tu clave'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.primary ,
      body: Form(
        key: _formularioCorreo,
        child: SingleChildScrollView( // Envuelve el contenido en SingleChildScrollView
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: [
                        Image.asset('assets/images/f-key.png', scale: 20)
                      ]),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60),
                      )),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: Text(
                                    "Escribe tu correo electrónico si "
                                        "está relacionado con una cuenta, "
                                        "te haremos llegar un enlace para restablecer tu contraseña",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.tertiary,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide())),
                                child: TextFormField(
                                  controller: _emailController,
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary),
                                  decoration: InputDecoration(
                                      hintText: "Correo electrónico",
                                      hintStyle: TextStyle(
                                          color: Theme.of(context).colorScheme.surface),
                                      border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Theme.of(context).colorScheme.tertiary),
                                      )),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Favor de escribir tu correo electrónico';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formularioCorreo.currentState!.validate()) {
                                      try {
                                        _auth.sendPasswordResetEmail (email: _emailController.text);
                                      } on FirebaseAuthException catch (e) {
                                        print('Failed to sign in: $e');
                                      }
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Enviando enlace a tu correo')),
                                      );
                                      Navigator.pushNamed(context, '/login');
                                    }
                                  },
                                  child: const Text('Enviar enlace de recuperación'),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      Theme.of(context).colorScheme.secondary,
                                      foregroundColor: Theme.of(context)
                                          .colorScheme.onSecondary)),
                              const SizedBox(height: 30)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
