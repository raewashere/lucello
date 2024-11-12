import 'package:celloapp/screens/vista_afinador.dart';
import 'package:celloapp/screens/vista_analisis.dart';
import 'package:celloapp/screens/vista_bienvenida.dart';
import 'package:celloapp/screens/vista_catalogo.dart';
import 'package:celloapp/screens/vista_cuenta.dart';
import 'package:flutter/material.dart';

class vista_inicio extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _vista_inicio_state();
}

class _vista_inicio_state extends State<vista_inicio> {
  int seleccion_actual = 0;

  final List vistas = [
    vista_bienvenida(),
    vista_afinador(),
    vista_analisis(),
    vista_catalogo(),
    vista_cuenta()
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text('CelloApp'),backgroundColor: colors.primary,),
      body: vistas[seleccion_actual],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: colors.primaryContainer,
        backgroundColor: colors.primaryContainer,
          currentIndex: seleccion_actual,
          onTap: (value) {
            setState(() {
              seleccion_actual = value;
            });
          },
          elevation: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio',backgroundColor: colors.onPrimary),
            BottomNavigationBarItem(icon: Icon(Icons.tune), label: 'Afinador',backgroundColor: colors.onPrimary),
            BottomNavigationBarItem(
                icon: Icon(Icons.graphic_eq), label: 'Análisis',backgroundColor: colors.onPrimary),
            BottomNavigationBarItem(
                icon: Icon(Icons.disc_full), label: 'Catálogo',backgroundColor: colors.onPrimary),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: 'Cuenta',backgroundColor: colors.onPrimary),
          ]),
    );
  }
}
