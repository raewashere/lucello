import 'package:flutter/material.dart';

class vista_bienvenida extends StatelessWidget {
  const vista_bienvenida({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(Icons.album,
                  color: Theme.of(context).colorScheme.primary),
              title: Text("Bienvenido",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              subtitle: Text("Tu platforma de analisis de interpretaciones",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
            ),
            SizedBox(height: 16),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(Icons.tune,
                  color: Theme.of(context).colorScheme.primary),
              title: Text("Afina tu instrumento",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              subtitle: Text(
                  "Un instrumento afinado ayuda a hacer un mejor analisis",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
            ),
            SizedBox(height: 16),
            ListTile(
              textColor: Theme.of(context).colorScheme.tertiary,
              leading: Icon(Icons.graphic_eq,
                  color: Theme.of(context).colorScheme.primary),
              title: Text("Analiza tu ejecucion",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary)),
              subtitle: Text("Revisa tu retroalimentacion de como tocas",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary)),
            ),
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: [
                    Image.asset('assets/images/efe.png',
                        scale: 3.5, color: Colors.black),
                    Padding(padding: EdgeInsets.all(80)),
                    Image.asset('assets/images/efe-i.png',
                        scale: 3.5, color: Colors.black)
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
